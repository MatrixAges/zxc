const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("lower.zig");

pub fn constantLabels(self: *Lower, selection: ir.MatchRow) Lower.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("selection/seed.zig").constantLabels(self, selection);

    return query(self, selection.subject, selection.arms.conditions[0..selection.arms.len]);
}

pub fn literal(self: *Lower, id: ir.ExprId) Lower.Error!@import("../node.zig").ExpressionId {
    const previous = self.cache.get(id);

    if (previous != null) _ = self.cache.remove(id);

    defer if (previous) |value| self.cache.put(self.allocator, id, value) catch unreachable;

    return self.regular(id);
}

pub fn labels(self: *Lower, subject: ir.ExprId, conditions: []const u32) Lower.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("selection/seed.zig").labels(self, subject, conditions);

    return query(self, subject, conditions);
}

fn query(self: *Lower, subject: ?ir.ExprId, conditions: []const u32) Lower.Error!bool {
    const generated = @import("generated_selection_labels");
    const Input = std.meta.Child(generated.Input);
    const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
    const expressions = zx.columns.borrow(Expressions, @as(*const ir.ExpressionTable, &self.program.expressions));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .expressions = &expressions,
        .types = &types,
        .subject = if (subject) |id| @backingInt(id) else null,
        .conditions = conditions,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    return zx.columns.invoke(generated.executeValue, buffered.allocator(), @as(*const Input, &input)) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };
}
