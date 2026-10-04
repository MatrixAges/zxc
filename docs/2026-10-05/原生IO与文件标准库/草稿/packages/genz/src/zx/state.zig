const std = @import("std");

pub const Object = struct { module_name: []const u8, writable: bool };

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    return renderWithIo(allocator, objects, false);
}

pub fn renderWithIo(allocator: std.mem.Allocator, objects: []const Object, needs_io: bool) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();
    write(&output.writer, objects, needs_io) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn write(writer: *std.Io.Writer, objects: []const Object, needs_io: bool) std.Io.Writer.Error!void {
    try writer.writeAll("const std = @import(\"std\");\nconst application = @import(\"application\");\nconst Self = @This();\n\n");
    for (objects, 0..) |object, index| try writer.print("const initial_{d} = @import(\"{f}\");\n", .{ index, std.zig.fmtString(object.module_name) });

    var writable = false;

    for (objects) |object| writable = writable or object.writable;
    try writer.writeAll("\narena: *std.heap.ArenaAllocator,\n");
    if (writable) try writer.writeAll("retained: ?*Region = null,\n");
    for (objects, 0..) |_, index| try writer.print("value_{0d}: initial_{0d}.Output = undefined,\nstore_{0d}: *initial_{0d}.Output = undefined,\n", .{index});
    try writer.writeAll("\npub fn initialize(self: *Self) !void {\n");
    for (objects, 0..) |_, index| try writer.print("    self.value_{0d} = try initial_{0d}.execute(self.arena, {{}});\n    self.store_{0d} = &self.value_{0d};\n", .{index});
    try writer.writeAll("}\n\npub fn commit(self: *Self, changes: application.zx_pending) !void {\n    if (try validate(changes)) self.apply(changes);\n}\n\nfn validate(changes: application.zx_pending) !bool {\n    var count: usize = 0;\n");
    for (objects, 0..) |_, index| try writer.print("    if (changes.store_{d} != null) count += 1;\n", .{index});
    try writer.writeAll("    if (count > 1) return error.MultipleStoreObjects;\n\n");

    for (objects, 0..) |object, index| {
        if (!object.writable) try writer.print("    if (changes.store_{d} != null) return error.StoreNotWritable;\n", .{index});
    }

    try writer.writeAll("    return count != 0;\n}\n\nfn apply(self: *Self, changes: application.zx_pending) void {\n");
    if (!writable) try writer.writeAll("    _ = self;\n    _ = changes;\n");

    for (objects, 0..) |object, index| {
        if (object.writable) try writer.print("    if (changes.store_{0d}) |value| self.value_{0d} = value;\n", .{index});
    }

    try writer.writeAll("}\n\n");
    try @import("state/request.zig").write(writer, objects.len, writable, needs_io);
}
