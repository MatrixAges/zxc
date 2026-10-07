const std = @import("std");
const ir = @import("zx").ir;
const Unit = @import("root.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{ExpansionLimit};

unit: *Unit,
source: ir.ExpressionTable,
selected: ?[]const bool,
ids: []?ir.ExprId,
symbol_offset: usize,
pub fn init(unit: *Unit, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, selected: ?[]const bool) Error!Self {
    const offset = unit.symbols.count();
    const ids = try unit.allocator.alloc(?ir.ExprId, expressions.count());

    @memset(ids, null);
    for (0..symbols.count()) |index| try unit.symbols.append(unit.allocator, symbols.at(index));

    return .{ .unit = unit, .source = expressions, .selected = selected, .ids = ids, .symbol_offset = offset };
}

pub fn expression(self: *Self, id: ir.ExprId) Error!ir.ExprId {
    if (self.ids[@backingInt(id)]) |mapped| return mapped;
    if (self.unit.depth == 128) return error.ExpansionLimit;

    self.unit.depth += 1;
    defer self.unit.depth -= 1;

    const item = self.source.at(@backingInt(id));
    const selected = if (self.selected) |flags| flags[@backingInt(id)] else true;

    const result = if (selected and item.value == .call and self.unit.plan.accepts(item.value.call.function)) blk: {
        const call = item.value.call;
        const argument = try self.expression(call.argument);
        const function = self.unit.plan.program.functions[@backingInt(call.function)];
        var child = try init(self.unit, function.symbols, function.expressions, null);
        const returned = try @import("block.zig").lower(&child, function.body.block(), null, function.output_type, item.span);
        const input: ir.SymbolId = @fromBackingInt(@intCast(child.symbol_offset));

        if (self.unit.costs.items[@backingInt(returned)] > @import("plan.zig").limit) return error.ExpansionLimit;

        break :blk try @import("block.zig").bind(&child, .{ .symbol = input, .value = argument }, returned, item.type_id, item.span);
    } else blk: {
        break :blk try self.unit.append(.{ .type_id = item.type_id, .span = item.span, .value = try self.expressionValue(item.value) });
    };

    self.ids[@backingInt(id)] = result;

    return result;
}

pub fn block(self: *Self, source: ir.Block) Error!ir.BlockId {
    const statements = try self.unit.allocator.alloc(ir.Statement, source.len);

    defer self.unit.allocator.free(statements);

    for (statements, 0..) |*target, index| {
        target.* = switch (source.at(index)) {
            .parallel => |items| .{ .parallel = try self.records(ir.ParallelCall, items) },
            .destructure => |binding| .{ .destructure = .{ .symbols = try self.records(?ir.SymbolId, binding.symbols), .value = try self.expression(binding.value) } },
            .branch => |branch| .{ .branch = .{ .condition = try self.expression(branch.condition), .yes = try self.block(branch.yes), .no = try self.block(branch.no) } },
            .switch_stmt => |selection| blk: {
                const cases = try self.unit.allocator.alloc(ir.SwitchCase, selection.cases.len);

                for (cases, 0..) |*target_case, position| {
                    const case = selection.cases.at(position);
                    target_case.* = .{ .value = try self.value(?ir.ExprId, case.value), .body = try self.block(case.body) };
                }

                break :blk .{ .switch_stmt = .{ .subject = try self.expression(selection.subject), .cases = cases, .exhaustive = selection.exhaustive } };
            },
            inline else => |item, tag| @unionInit(ir.Statement, @tagName(tag), try self.value(@TypeOf(item), item)),
        };
    }

    return self.unit.control.appendBlock(self.unit.allocator, statements);
}

fn expressionValue(self: *Self, source: @FieldType(ir.ExpressionRow, "value")) Error!@FieldType(ir.Expression, "value") {
    return switch (source) {
        .parallel => |items| .{ .parallel = try self.records(ir.ParallelBranch, items) },
        .scope => |item| .{ .scope = .{ .bindings = try self.records(ir.ScopeBinding, item.bindings), .result = try self.expression(item.result) } },
        .match_expr => |item| .{ .match_expr = .{ .subject = try self.value(?ir.ExprId, item.subject), .arms = try self.records(ir.MatchArm, item.arms), .fallback = try self.expression(item.fallback) } },
        .object => |item| .{ .object = .{ .fields = try self.records(ir.ObjectField, item.fields), .evaluation = try self.value([]const ir.ExprId, item.evaluation) } },
        inline else => |item, tag| @unionInit(@FieldType(ir.Expression, "value"), @tagName(tag), try self.value(@TypeOf(item), item)),
    };
}

fn records(self: *Self, comptime Item: type, items: anytype) Error![]const Item {
    const result = try self.unit.allocator.alloc(Item, items.len);

    for (result, 0..) |*mapped, index| mapped.* = try self.value(Item, items.at(index));

    return result;
}

pub fn value(self: *Self, comptime T: type, source: T) Error!T {
    if (T == ir.ExprId) return self.expression(source);
    if (T == ir.SymbolId) return @fromBackingInt(@intCast(self.symbol_offset + @backingInt(source)));

    return switch (@typeInfo(T)) {
        .@"struct" => |info| blk: {
            var result = source;

            inline for (info.field_names) |name| @field(result, name) = try self.value(@FieldType(T, name), @field(source, name));

            break :blk result;
        },
        .@"union" => |info| blk: {
            inline for (info.field_names) |name| if (std.mem.eql(u8, @tagName(source), name)) {
                break :blk @unionInit(T, name, try self.value(@FieldType(T, name), @field(source, name)));
            };

            unreachable;
        },
        .optional => |info| if (source) |child| try self.value(info.child, child) else null,
        .pointer => |info| blk: {
            if (info.size != .slice or info.child == u8) break :blk source;

            const result = try self.unit.allocator.alloc(info.child, source.len);

            for (source, result) |item, *mapped| mapped.* = try self.value(info.child, item);

            break :blk result;
        },
        else => source,
    };
}
