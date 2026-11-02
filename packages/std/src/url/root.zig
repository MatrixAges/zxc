pub const host = @import("host/root.zig");
pub const Url = @import("model.zig").Url;
pub const serialize = @import("serialize.zig").serialize;
pub const serializePath = @import("serialize.zig").path;
pub const origin = @import("origin.zig").origin;
pub const fileUrlToPath = @import("file/to_path.zig").toPath;
pub const fileUrlToBytes = @import("file/to_path.zig").toBytes;
pub const pathToFileUrl = @import("file/from_path.zig").fromPath;
const std = @import("std");
const parser = @import("parser/root.zig");

pub const Parsed = struct {
    arena: std.heap.ArenaAllocator,
    value: Url,
    pub fn deinit(self: *Parsed) void {
        self.arena.deinit();
    }
};

pub fn parse(allocator: std.mem.Allocator, input: []const u8, base: ?[]const u8) !Parsed {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const memory = arena.allocator();
    const parent = if (base) |text| try parser.parse(memory, text, null) else null;
    const value = try parser.parse(memory, input, parent);

    return .{ .arena = arena, .value = value };
}
