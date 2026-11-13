const ir = @import("zx").ir;

namespace: ?[]const u8 = null,
name: []const u8,

id: ?ir.FunctionId = null,
input_type: ?ir.TypeId = null,
output_type: ?ir.TypeId = null,
intrinsic: ?@import("intrinsic.zig").Operation = null,
pub fn valid(self: @This()) bool {
    return if (self.intrinsic != null)
        self.id == null and self.input_type == null and self.output_type == null

    else
        self.id != null and self.input_type != null and self.output_type != null;
}

pub fn borrow(self: *const @This(), comptime Row: type) Row {
    return .{
        .namespace = self.namespace,
        .name = self.name,
        .id = if (self.id) |id| @backingInt(id) else null,
        .input_type = if (self.input_type) |id| @backingInt(id) else null,
        .output_type = if (self.output_type) |id| @backingInt(id) else null,
        .intrinsic = if (self.intrinsic) |operation| @intFromEnum(operation) else null,
    };
}
