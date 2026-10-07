const std = @import("std");
const ir = @import("zx").ir;
const Span = @import("zx").Span;
const Mapping = @import("mapping.zig");
const Error = Mapping.Error;

pub fn lower(mapping: *Mapping, statements: ir.Block, continuation: ?ir.ExprId, type_id: ir.TypeId, span: Span) Error!ir.ExprId {
    const unit = mapping.unit;

    if (unit.depth == 128) return error.ExpansionLimit;

    unit.depth += 1;
    defer unit.depth -= 1;
    const kind = unit.plan.program.typeOf(type_id);
    var result = continuation;

    if (result == null and kind == .scalar and kind.scalar == .void) result = try unit.append(.{ .type_id = type_id, .span = span, .value = .unit });

    var index = statements.len;

    while (index != 0) {
        index -= 1;

        switch (statements.at(index)) {
            .result => |value| result = if (value) |id| try mapping.expression(id) else try unit.append(.{ .type_id = type_id, .span = span, .value = .unit }),
            .constant => |binding| result = try bind(mapping, try mapping.value(ir.ScopeBinding, .{ .symbol = binding.symbol, .value = binding.value }), result.?, type_id, span),
            .evaluate => |value| result = try bind(mapping, .{ .symbol = null, .value = try mapping.expression(value) }, result.?, type_id, span),
            .destructure => |binding| {
                const value = try mapping.expression(binding.value);
                const tuple_type = mapping.source.at(@backingInt(binding.value)).type_id;
                const tuple = unit.plan.program.typeOf(tuple_type).tuple;
                const symbol = try unit.symbol(.{ .name = "inline_tuple", .type_id = tuple_type, .span = span });
                const reference = try unit.append(.{ .type_id = tuple_type, .span = span, .value = .{ .reference = symbol } });
                var position = binding.symbols.len;

                while (position != 0) {
                    position -= 1;
                    const target = binding.symbols.at(position) orelse continue;
                    const field = try unit.append(.{ .type_id = tuple.at(position), .span = span, .value = .{ .tuple_field = .{ .target = reference, .index = @intCast(position) } } });

                    result = try bind(mapping, .{ .symbol = try mapping.value(ir.SymbolId, target), .value = field }, result.?, type_id, span);
                }

                result = try bind(mapping, .{ .symbol = symbol, .value = value }, result.?, type_id, span);
            },
            .branch => |branch| {
                const condition = try mapping.expression(branch.condition);
                const continuing = !returns(branch.yes) and !returns(branch.no);
                const branch_type = if (continuing) scalarType(unit.plan.program, .void) else type_id;
                const tail = if (continuing) null else result;
                const yes = try lower(mapping, branch.yes, tail, branch_type, span);
                const no = try lower(mapping, branch.no, tail, branch_type, span);
                const value = try unit.append(.{ .type_id = branch_type, .span = span, .value = .{ .conditional = .{ .condition = condition, .yes = yes, .no = no } } });

                result = if (continuing) try bind(mapping, .{ .symbol = null, .value = value }, result.?, type_id, span) else value;
            },
            .switch_stmt => |selection| {
                const continuing = for (0..selection.cases.len) |case_index| {
                    const case = selection.cases.at(case_index);

                    if (returns(case.body)) break false;
                } else true;

                const value = try select(mapping, selection, if (continuing) null else result, if (continuing) scalarType(unit.plan.program, .void) else type_id, span);

                result = if (continuing) try bind(mapping, .{ .symbol = null, .value = value }, result.?, type_id, span) else value;
            },
            .parallel, .store_set => unreachable,
        }
    }

    if (result) |value| return value;

    std.debug.assert(unit.plan.program.typeOf(type_id) == .scalar and unit.plan.program.typeOf(type_id).scalar == .void);

    return unit.append(.{ .type_id = type_id, .span = span, .value = .unit });
}

pub fn bind(mapping: *Mapping, binding: ir.ScopeBinding, result: ir.ExprId, type_id: ir.TypeId, span: Span) Error!ir.ExprId {
    const unit = mapping.unit;
    const value = unit.expressions.view().at(@backingInt(result)).value;
    const previous_count = if (value == .scope) value.scope.bindings.len else 0;
    const bindings = try unit.allocator.alloc(ir.ScopeBinding, previous_count + 1);

    bindings[0] = binding;

    for (0..previous_count) |index| bindings[index + 1] = value.scope.bindings.at(index);

    return unit.append(.{ .type_id = type_id, .span = span, .value = .{ .scope = .{
        .bindings = bindings,
        .result = if (value == .scope) value.scope.result else result,
    } } });
}

fn select(mapping: *Mapping, selection: @FieldType(ir.StatementRow, "switch_stmt"), continuation: ?ir.ExprId, type_id: ir.TypeId, span: Span) Error!ir.ExprId {
    const unit = mapping.unit;
    const subject = try mapping.expression(selection.subject);
    const subject_type = mapping.source.at(@backingInt(selection.subject)).type_id;
    const symbol = try unit.symbol(.{ .name = "inline_subject", .type_id = subject_type, .span = span });
    const reference = try unit.append(.{ .type_id = subject_type, .span = span, .value = .{ .reference = symbol } });
    var fallback = continuation;
    var arms: std.ArrayList(ir.MatchArm) = .empty;

    for (0..selection.cases.len) |case_index| {
        const case = selection.cases.at(case_index);

        if (case.value == null) {
            fallback = try lower(mapping, case.body, continuation, type_id, span);
        }
    }

    for (0..selection.cases.len) |index| {
        const case = selection.cases.at(index);
        const value = case.value orelse continue;
        const body = try lower(mapping, case.body, continuation, type_id, span);

        if (fallback == null and selection.exhaustive and index + 1 == selection.cases.len) {
            fallback = body;

            continue;
        }

        const condition = try unit.append(.{ .type_id = scalarType(unit.plan.program, .bool), .span = span, .value = .{ .binary = .{
            .operator = .equal,
            .left = reference,
            .right = try mapping.expression(value),
        } } });

        try arms.append(unit.allocator, .{ .condition = condition, .result = body });
    }

    const last = fallback orelse try lower(mapping, (ir.ControlBody{}).block(), null, type_id, span);
    const result = try unit.append(.{ .type_id = type_id, .span = span, .value = .{ .match_expr = .{ .subject = null, .arms = try arms.toOwnedSlice(unit.allocator), .fallback = last } } });

    return bind(mapping, .{ .symbol = symbol, .value = subject }, result, type_id, span);
}

fn scalarType(program: ir.Program, kind: ir.Scalar) ir.TypeId {
    for (0..program.types.count()) |index| {
        const value = program.types.at(index);

        if (value == .scalar and value.scalar == kind) return @fromBackingInt(@intCast(index));
    }

    unreachable;
}

fn returns(statements: ir.Block) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .result => return true,
            .branch => |branch| if (returns(branch.yes) or returns(branch.no)) return true,
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (returns(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
