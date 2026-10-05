const std = @import("std");

pub fn write(writer: *std.Io.Writer, count: usize, writable: bool, requirements: @import("../state.zig").Requirements) std.Io.Writer.Error!void {
    try writeMode(writer, count, writable, requirements, true);
}

pub fn writeStorage(writer: *std.Io.Writer, count: usize, writable: bool) std.Io.Writer.Error!void {
    try writeMode(writer, count, writable, .{}, false);
}

fn writeMode(writer: *std.Io.Writer, count: usize, writable: bool, requirements: @import("../state.zig").Requirements, execute: bool) std.Io.Writer.Error!void {
    if (writable) {
        try writer.writeAll(
            \\const Region = struct {
            \\    arena: std.heap.ArenaAllocator,
            \\    next: ?*Region,
            \\};
            \\
            \\pub fn deinit(self: *Self) void {
            \\    var region = self.retained;
            \\
            \\    while (region) |current| {
            \\        const next = current.next;
            \\
            \\        current.arena.deinit();
            \\        region = next;
            \\    }
            \\
            \\    self.retained = null;
            \\}
            \\
        );
    } else try writer.writeAll("pub fn deinit(self: *Self) void {\n    _ = self;\n}\n");

    try writer.writeAll("\npub fn request(self: *Self) Request {\n    return .{\n        .parent = self,\n        .arena = std.heap.ArenaAllocator.init(self.arena.child_allocator),\n");
    for (0..count) |index| try writer.print("        .store_{0d} = self.store_{0d},\n", .{index});
    try writer.writeAll("    };\n}\n\npub const Request = struct {\n    parent: *Self,\n    arena: std.heap.ArenaAllocator,\n");
    if (writable) try writer.writeAll("    retained: ?*Region = null,\n");
    for (0..count) |index| try writer.print("    store_{0d}: *initial_{0d}.Output,\n", .{index});
    if (execute) try writer.print("\n    pub fn execute(self: *Request, input: application.Input{s}{s}) !application.Output {{\n        return application.execute(&self.arena, input, self{s}{s});\n    }}\n", .{ if (requirements.io) ", io: std.Io" else "", if (requirements.process) ", process: std.process.Init.Minimal" else "", if (requirements.io) ", io" else "", if (requirements.process) ", process" else "" });
    try writer.writeAll("\n    pub fn deinit(self: *Request) void {\n");

    if (writable) {
        try writer.writeAll("        if (self.retained) |region| {\n            region.arena = self.arena;\n        } else self.arena.deinit();\n");
    } else try writer.writeAll("        self.arena.deinit();\n");

    try writer.writeAll("\n        self.* = undefined;\n    }\n\n    pub fn commit(self: *Request, changes: application.zx_pending) !void {\n");

    if (writable) {
        try writer.writeAll(
            \\        if (!try Self.validate(changes)) return;
            \\
            \\        if (self.retained == null) {
            \\            const region = try self.parent.arena.allocator().create(Region);
            \\
            \\            region.* = .{
            \\                .arena = std.heap.ArenaAllocator.init(self.parent.arena.child_allocator),
            \\                .next = self.parent.retained,
            \\            };
            \\
            \\            self.parent.retained = region;
            \\            self.retained = region;
            \\        }
            \\
            \\        self.parent.apply(changes);
            \\
        );
    } else try writer.writeAll("        try self.parent.commit(changes);\n");

    try writer.writeAll("    }\n};\n");
}
