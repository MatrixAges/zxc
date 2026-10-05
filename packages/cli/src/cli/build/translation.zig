const std = @import("std");
const protocol = @import("../backend/protocol.zig");
const Cache = @import("observed.zig").Cache;
const Self = @This();

arena: std.heap.ArenaAllocator,
cache: Cache,
inputs: std.ArrayList(protocol.Input) = .empty,
complete: bool = true,
failure: ?protocol.Result = null,
pub fn init(allocator: std.mem.Allocator, cache: Cache) Self {
    return .{ .arena = .init(allocator), .cache = cache };
}

pub fn deinit(self: *Self) void {
    if (self.failure) |*failure| failure.deinit();

    self.arena.deinit();
}

pub fn execute(self: *Self, io: std.Io, arguments: []const []const u8, environment: *const std.process.Environ.Map, stem: []const u8) !?[]const u8 {
    const allocator = self.arena.allocator();
    var response = try @import("../backend/process.zig").run(io, self.arena.child_allocator, arguments, environment);

    if (!response.succeeded) {
        self.failure = response;

        return null;
    }

    defer response.deinit();

    self.complete = self.complete and response.inputs_complete;

    for (response.inputs) |input| try self.inputs.append(allocator, .{ .prefix = input.prefix, .path = try allocator.dupe(u8, input.path) });

    const digest = std.fmt.bytesToHex(response.digest.?, .lower);

    return try std.fmt.allocPrint(allocator, "{s}/o/{s}/{s}.zig", .{ self.cache.local, digest, stem });
}

pub fn merge(self: *Self, response: *protocol.Result) !void {
    const allocator = response.arena.allocator();
    const inputs = try allocator.alloc(protocol.Input, self.inputs.items.len + response.inputs.len);

    for (self.inputs.items, inputs[0..self.inputs.items.len]) |input, *copy| copy.* = .{ .prefix = input.prefix, .path = try allocator.dupe(u8, input.path) };

    @memcpy(inputs[self.inputs.items.len..], response.inputs);

    response.inputs = inputs;
    response.inputs_complete = response.inputs_complete and self.complete;
}
