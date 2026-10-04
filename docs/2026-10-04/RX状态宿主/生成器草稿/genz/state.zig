const std = @import("std");
pub const Object = struct { module_name: []const u8, writable: bool };

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();
    write(&output.writer, objects) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn write(writer: *std.Io.Writer, objects: []const Object) std.Io.Writer.Error!void {
    try writer.writeAll("const std = @import(\"std\");\nconst application = @import(\"application\");\nconst Self = @This();\n\n");
    for (objects, 0..) |object, index| try writer.print("const initial_{d} = @import(\"{f}\");\n", .{ index, std.zig.fmtString(object.module_name) });
    try writer.writeAll("\narena: *std.heap.ArenaAllocator,\n");
    for (objects, 0..) |_, index| try writer.print("value_{0d}: initial_{0d}.Output = undefined,\nstore_{0d}: *initial_{0d}.Output = undefined,\n", .{index});
    try writer.writeAll("\npub fn initialize(self: *Self) !void {\n");
    for (objects, 0..) |_, index| try writer.print("    self.value_{0d} = try initial_{0d}.execute(self.arena, {{}});\n    self.store_{0d} = &self.value_{0d};\n", .{index});
    try writer.writeAll("}\n\npub fn commit(self: *Self, changes: application.zx_pending) !void {\n    var count: usize = 0;\n");
    for (objects, 0..) |_, index| try writer.print("    if (changes.store_{d} != null) count += 1;\n", .{index});
    try writer.writeAll("    if (count > 1) return error.MultipleStoreObjects;\n\n");

    var writable = false;

    for (objects, 0..) |object, index| {
        writable = writable or object.writable;

        if (!object.writable) try writer.print("    if (changes.store_{d} != null) return error.StoreNotWritable;\n", .{index});
    }

    if (!writable) try writer.writeAll("    _ = self;\n");

    for (objects, 0..) |object, index| {
        if (object.writable) try writer.print("    if (changes.store_{0d}) |value| self.value_{0d} = value;\n", .{index});
    }

    try writer.writeAll("}\n");
}
