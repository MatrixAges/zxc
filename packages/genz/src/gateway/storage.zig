const std = @import("std");
const Object = @import("../zx/state.zig").Object;

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();
    write(&output.writer, objects) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn write(writer: *std.Io.Writer, objects: []const Object) std.Io.Writer.Error!void {
    for (objects, 0..) |object, index| try writer.print("const initial_{d} = @import(\"{f}\");\n", .{ index, std.zig.fmtString(object.module_name) });
    try writer.writeAll("\npub const zx_pending = struct {\n");
    for (objects, 0..) |_, index| try writer.print("    store_{0d}: ?initial_{0d}.Output = null,\n", .{index});
    try writer.writeAll("};\n");
}
