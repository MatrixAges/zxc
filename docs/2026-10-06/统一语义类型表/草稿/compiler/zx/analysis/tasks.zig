const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn start(self: *Analyzer, child: anytype, span: zx.Span) zx.Error!ir.ExprId {
    const first = self.nodes.items.len;
    const symbol_count = self.symbols.items.len;
    const body = try self.expression(child, null);
    var captures: std.ArrayList(ir.SymbolId) = .empty;

    for (self.nodes.items[first..]) |node| {
        switch (node.value) {
            .reference => |symbol| {
                if (@backingInt(symbol) >= symbol_count) continue;
                if (try ir.containsNativeReference(self.allocator, self.types.items.view(), self.symbols.items[@backingInt(symbol)].type_id)) return self.reporter.fail(.capability, span, "tasks cannot capture host references");
                if (self.types.get(self.symbols.items[@backingInt(symbol)].type_id) == .task) return self.reporter.fail(.ownership, span, "tasks cannot capture other task handles");
                if (std.mem.indexOfScalar(ir.SymbolId, captures.items, symbol) == null) try captures.append(self.allocator, symbol);
            },
            .store_get => return self.reporter.fail(.capability, span, "tasks cannot access Store state"),
            .call => |call| {
                if (!try @import("../ir/tasks.zig").callSafe(self.allocator, self.functions, call.function)) return self.reporter.fail(.capability, span, "task calls require Store-free functions and an explicit native concurrency contract");
            },
            else => {},
        }
    }

    const errors = try zx.error_effects.expression(self.allocator, self.types.items.view(), self.functions, self.nodes.items, body) orelse return self.reporter.fail(.type_mismatch, span, "a task requires a finite error contract");
    const error_type = try self.types.errorSet(errors);
    const type_id = try self.types.task(self.node(body).type_id, error_type);

    return self.append(.{ .span = span, .type_id = type_id, .value = .{ .task = .{ .body = body, .captures = try captures.toOwnedSlice(self.allocator) } } });
}

pub fn wait(self: *Analyzer, child: anytype, span: zx.Span) zx.Error!ir.ExprId {
    const operand = try self.expression(child, null);
    const target = self.types.get(self.node(operand).type_id);

    if (target != .task) return self.reporter.fail(.type_mismatch, span, "await requires a task");

    return self.append(.{ .span = span, .type_id = target.task.result, .value = .{ .await_task = operand } });
}

pub fn parallel(self: *Analyzer, expression: anytype) zx.Error!ir.ExprId {
    const arguments = syntax.value(expression).call.arguments;

    if (arguments.len != 1 or syntax.value(syntax.item(arguments, 0)) != .object) return self.reporter.fail(.type_mismatch, expression.span, "parallel requires an object of zero-argument callbacks");

    const source = syntax.value(syntax.item(arguments, 0)).object;
    const branches = try self.allocator.alloc(ir.ParallelBranch, source.len);
    const fields = try Types.Fields.init(self.allocator, source.len);
    var field_count: usize = 0;

    for (0..source.len) |index| {
        const field = syntax.item(source, index);

        if (field.spread or syntax.value(field.value) != .lambda or syntax.value(field.value).lambda.parameters.len != 0) return self.reporter.fail(.type_mismatch, field.value.span, "parallel branches must be zero-argument callbacks");

        for (0..index) |previous_index| {
            const previous = syntax.item(source, previous_index);

            if (std.mem.eql(u8, previous.name.text, field.name.text)) return self.reporter.fail(.name, field.name.span, "duplicate parallel branch name");
        }

        const task = try start(self, syntax.value(field.value).lambda.body, field.value.span);
        const result = self.types.get(self.node(task).type_id).task.result;

        branches[index] = .{ .task = task, .field = null };

        if (result != Types.scalarId(.void)) {
            fields.set(field_count, try self.allocator.dupe(u8, field.name.text), result);

            field_count += 1;
        }
    }

    const result_type = if (field_count == 0) Types.scalarId(.void) else try self.types.object(fields.prefix(field_count));

    if (result_type != Types.scalarId(.void)) {
        for (branches, 0..) |*branch, source_index| {
            const field = syntax.item(source, source_index);

            for (0..self.types.get(result_type).object.len, 0..) |view_index, index| {
                const result = self.types.get(result_type).object.at(view_index);

                if (std.mem.eql(u8, result.name, field.name.text)) branch.field = @intCast(index);
            }
        }
    }

    return self.append(.{ .span = expression.span, .type_id = result_type, .value = .{ .parallel = branches } });
}

pub fn cancel(self: *Analyzer, child: anytype, span: zx.Span) zx.Error!ir.ExprId {
    const operand = try self.expression(child, null);

    if (self.types.get(self.node(operand).type_id) != .task) return self.reporter.fail(.type_mismatch, span, "cancel requires a task");

    return self.append(.{ .span = span, .type_id = Types.scalarId(.void), .value = .{ .cancel_task = operand } });
}
