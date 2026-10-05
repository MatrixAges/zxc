const std = @import("std");
const Observed = @import("observed").Observed;
const Self = @This();
pub const Inputs = @import("observed").Inputs;
pub const Options = @import("observed").Options;
const io = std.testing.io;
const allocator = std.testing.allocator;

temporary: std.testing.TmpDir,
inputs: Inputs,
result: Observed,
options: Options,
root: []const u8,
pub fn init() !Self {
    var temporary = std.testing.tmpDir(.{});

    errdefer temporary.cleanup();

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const root = try temporary.dir.realPathFileAlloc(io, ".", owned);
    var inputs = try Inputs.init(io, allocator);

    errdefer inputs.deinit();

    for ([_][]const u8{ "input", "binary", "assembly", "output", "output.s" }, [_][]const u8{ "source", "new-bin", "new-asm", "old-bin", "old-asm" }) |name, data| {
        try temporary.dir.writeFile(io, .{ .sub_path = name, .data = data });
    }

    const input = try std.fs.path.join(owned, &.{ root, "input" });

    try inputs.add(io, input);

    const binary = try std.fs.path.join(owned, &.{ root, "binary" });
    const assembly = try std.fs.path.join(owned, &.{ root, "assembly" });
    const output = try std.fs.path.join(owned, &.{ root, "output" });
    const output_assembly = try std.fs.path.join(owned, &.{ root, "output.s" });

    return .{
        .temporary = temporary,
        .inputs = inputs,
        .result = .{
            .response = .{ .arena = arena, .inputs = &.{}, .diagnostics = .empty, .digest = @as([std.Build.Cache.bin_digest_len]u8, @splat(0)), .cached = false, .succeeded = true, .inputs_complete = true, .termination = .{ .exited = 0 }, .stderr = "" },
            .input_paths = &.{},
            .new_inputs = false,
            .binary = binary,
            .assembly = assembly,
        },
        .options = .{ .input = input, .output = output, .assembly = output_assembly },
        .root = root,
    };
}

pub fn deinit(self: *Self) void {
    self.inputs.deinit();
    self.result.deinit();
    self.temporary.cleanup();
}

pub fn publish(self: *Self) !bool {
    return self.result.publish(io, allocator, &self.inputs, self.options);
}

pub fn expectOutputs(self: *Self, binary: []const u8, assembly: []const u8) !void {
    for ([_][]const u8{ "output", "output.s" }, [_][]const u8{ binary, assembly }) |path, expected| {
        const actual = try self.temporary.dir.readFileAlloc(io, path, allocator, .limited(1024));

        defer allocator.free(actual);

        try std.testing.expectEqualStrings(expected, actual);
    }
}
