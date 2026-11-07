const std = @import("std");
const ir = @import("zx").ir;
const Children = @import("../../inline_call/children.zig");
pub const Last = std.AutoHashMapUnmanaged(ir.SymbolId, usize);

pub fn collect(allocator: std.mem.Allocator, program: *const ir.Program, scope: ir.ScopeRow) std.mem.Allocator.Error!Last {
    var last: Last = .empty;

    errdefer last.deinit(allocator);

    var seen: std.AutoHashMapUnmanaged(ir.ExprId, void) = .empty;

    defer seen.deinit(allocator);

    var pending: std.ArrayList(ir.ExprId) = .empty;

    defer pending.deinit(allocator);

    var position = scope.bindings.len;

    while (true) {
        const root = if (position == scope.bindings.len) scope.result else scope.bindings.at(position).value;

        try pending.append(allocator, root);

        while (pending.pop()) |id| {
            if ((try seen.getOrPut(allocator, id)).found_existing) continue;

            const value = program.expression(id).value;

            if (value == .reference) {
                const entry = try last.getOrPut(allocator, value.reference);

                if (!entry.found_existing) entry.value_ptr.* = position;
            }

            if (value == .task) for (value.task.captures) |symbol| {
                const entry = try last.getOrPut(allocator, symbol);

                if (!entry.found_existing) entry.value_ptr.* = position;
            };

            const children = Children.init(value);

            for (0..children.len) |index| try pending.append(allocator, children.at(index));
        }

        if (position == 0) break;

        position -= 1;
    }

    return last;
}
