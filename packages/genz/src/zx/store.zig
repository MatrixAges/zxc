const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn declaration(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (self.program.stores.count() == 0) return;

    const fields = try self.allocator.alloc(node.Field, self.program.stores.count());

    for (self.program.stores.types, 0..) |type_id, index| fields[index] = .{
        .name = try slotName(self, index),
        .value = try self.builder.expression(.{ .optional_type = try self.typeExpr(@fromBackingInt(type_id)) }),
    };

    try output.append(self.allocator, .{ .constant = .{ .name = self.pending_name, .value = try self.builder.expression(.{ .struct_type = fields }), .exported = true } });
}

pub fn adapter(self: *Lower, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("store/adapter_seed.zig").lower(self, invocation);

    return @import("store/adapter.zig").lower(self, invocation);
}

fn slotName(self: *Lower, index: usize) Lower.Error![]const u8 {
    return std.fmt.allocPrint(self.allocator, "store_{d}", .{index});
}
