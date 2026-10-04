const std = @import("std");

pub const Object = struct { identity: []const u8, schema_version: u32, module_name: []const u8, type_name: []const u8, writable: bool };

pub fn render(allocator: std.mem.Allocator, objects: []const Object) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();

    const order = try allocator.alloc(usize, objects.len);

    defer allocator.free(order);

    for (order, 0..) |*index, position| index.* = position;

    std.mem.sort(usize, order, objects, lessThan);
    write(&output.writer, objects, order) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn lessThan(objects: []const Object, left: usize, right: usize) bool {
    return std.mem.lessThan(u8, objects[left].identity, objects[right].identity);
}

fn write(writer: *std.Io.Writer, objects: []const Object, order: []const usize) std.Io.Writer.Error!void {
    try writer.writeAll("const std = @import(\"std\");\nconst application = @import(\"application\");\nconst Self = @This();\n\n");

    for (objects, 0..) |object, index| {
        try writer.print("const initial_{d} = @import(\"{f}\");\n", .{ index, std.zig.fmtString(object.module_name) });
        try writer.print("const Snapshot_{0d} = struct {{ format_version: u32, identity: []const u8, schema_version: u32, type_identity: []const u8, revision: u64, value: initial_{0d}.Output }};\n", .{index});
    }

    try writer.writeAll("\narena: *std.heap.ArenaAllocator,\nio: std.Io,\ndirectory: std.Io.Dir,\n");
    for (objects, 0..) |_, index| try writer.print("value_{0d}: initial_{0d}.Output = undefined,\nstore_{0d}: *initial_{0d}.Output = undefined,\nrevision_{0d}: u64 = 0,\n", .{index});
    try writer.writeAll("\npub fn initialize(self: *Self) !void {\n");
    for (order) |index| try writer.print("    try self.initialize_{d}();\n", .{index});
    try writer.writeAll("}\n\npub fn begin(self: *Self, comptime slots: anytype) !void {\n");
    try writer.print("    comptime {{ for (slots) |slot| {{ if (slot >= {d}) @compileError(\"Invalid Store slot\"); }} }}\n", .{objects.len});

    for (order) |index| {
        try writer.print("    const guard_{0d}: ?std.Io.File = if (comptime std.mem.indexOfScalar(u32, &slots, {0d}) != null) try self.lock_{0d}() else null;\n", .{index});
        try writer.print("    defer if (guard_{d}) |file| file.close(self.io);\n", .{index});
    }

    try writer.writeByte('\n');
    for (objects, 0..) |_, index| try writer.print("    const next_{0d}: ?Snapshot_{0d} = if (comptime std.mem.indexOfScalar(u32, &slots, {0d}) != null) try self.read_{0d}() else null;\n", .{index});
    try writer.writeByte('\n');
    for (objects, 0..) |_, index| try writer.print("    if (next_{0d}) |snapshot| {{ self.value_{0d} = snapshot.value; self.revision_{0d} = snapshot.revision; }}\n", .{index});
    try writer.writeAll("}\n\npub fn commit(self: *Self, changes: application.zx_pending) !void {\n    var count: usize = 0;\n");
    for (objects, 0..) |_, index| try writer.print("    if (changes.store_{d} != null) count += 1;\n", .{index});
    try writer.writeAll("    if (count > 1) return error.MultipleStoreObjects;\n\n");

    for (objects, 0..) |object, index| {
        if (!object.writable) try writer.print("    if (changes.store_{d} != null) return error.StoreNotWritable;\n", .{index});
    }

    var writable = false;

    for (objects) |object| writable = writable or object.writable;
    if (!writable) try writer.writeAll("    _ = self;\n");

    for (objects, 0..) |object, index| {
        if (object.writable) try writer.print("    if (changes.store_{0d}) |value| try self.commit_{0d}(value);\n", .{index});
    }

    try writer.writeAll("}\n\nfn sync(self: *Self) !void {\n    const file = self.directory.openFile(self.io, \".\", .{ .allow_directory = true }) catch return error.StoreDurabilityUnconfirmed;\n    defer file.close(self.io);\n    file.sync(self.io) catch return error.StoreDurabilityUnconfirmed;\n}\n\n");
    for (objects, 0..) |object, index| try @import("state/object.zig").write(writer, object, index);
}
