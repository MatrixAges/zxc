const std = @import("std");
const builtin = @import("builtin");
const Message = std.zig.Server.Message;
pub const Input = struct { prefix: Message.PathPrefix, path: []const u8 };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    inputs: []const Input,
    diagnostics: std.zig.ErrorBundle,
    digest: ?[std.Build.Cache.bin_digest_len]u8,
    cached: bool,
    succeeded: bool,
    inputs_complete: bool,
    termination: std.process.Child.Term,
    stderr: []const u8,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn decode(allocator: std.mem.Allocator, stdout: []const u8, stderr: []const u8, termination: std.process.Child.Term) !Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var inputs: std.ArrayList(Input) = .empty;
    var diagnostics: std.zig.ErrorBundle = .empty;
    var digest: ?[std.Build.Cache.bin_digest_len]u8 = null;
    var cached = false;
    var version_seen = false;
    var inputs_seen = false;
    var finished = false;
    var offset: usize = 0;

    while (offset < stdout.len) {
        if (finished or stdout.len - offset < 8) return error.InvalidBackendProtocol;

        const tag: Message.Tag = @enumFromInt(std.mem.readInt(u32, stdout[offset..][0..4], .little));
        const length = std.mem.readInt(u32, stdout[offset + 4 ..][0..4], .little);
        offset += 8;

        if (length > stdout.len - offset) return error.InvalidBackendProtocol;

        const body = stdout[offset..][0..length];

        offset += length;

        if (!version_seen and tag != .zig_version) return error.InvalidBackendProtocol;

        switch (tag) {
            .zig_version => {
                if (version_seen) return error.InvalidBackendProtocol;
                if (!std.mem.eql(u8, builtin.zig_version_string, body)) return error.BackendVersionMismatch;

                version_seen = true;
            },
            .file_system_inputs => {
                inputs_seen = true;

                inputs.clearRetainingCapacity();

                var paths = std.mem.tokenizeScalar(u8, body, 0);

                while (paths.next()) |path| {
                    if (path.len < 2) return error.InvalidBackendProtocol;

                    const prefix = std.enums.fromInt(Message.PathPrefix, path[0] - 1) orelse return error.InvalidBackendProtocol;

                    try inputs.append(owned, .{ .prefix = prefix, .path = try owned.dupe(u8, path[1..]) });
                }
            },
            .emit_digest => {
                if (digest != null or body.len != 1 + std.Build.Cache.bin_digest_len or body[0] & 0xfe != 0) return error.InvalidBackendProtocol;

                cached = body[0] & 1 != 0;
                digest = body[1..][0..std.Build.Cache.bin_digest_len].*;
            },
            .error_bundle => {
                try validateErrorBundle(body);

                diagnostics = try std.zig.Server.allocErrorBundle(owned, body);

                try @import("error_bundle.zig").validate(allocator, diagnostics);

                finished = true;
            },
            else => return error.InvalidBackendProtocol,
        }
    }

    if (!version_seen or !finished) return error.IncompleteBackendResponse;

    const owned_inputs = try inputs.toOwnedSlice(owned);
    const owned_stderr = try owned.dupe(u8, stderr);
    const succeeded = termination == .exited and termination.exited == 0 and diagnostics.errorMessageCount() == 0 and digest != null;

    return .{
        .arena = arena,
        .inputs = owned_inputs,
        .diagnostics = diagnostics,
        .digest = digest,
        .cached = cached,
        .succeeded = succeeded,
        .inputs_complete = succeeded and inputs_seen,
        .termination = termination,
        .stderr = owned_stderr,
    };
}

fn validateErrorBundle(body: []const u8) !void {
    if (body.len < 8) return error.InvalidBackendProtocol;

    const extra_length = std.mem.readInt(u32, body[0..4], .little);
    const strings_length = std.mem.readInt(u32, body[4..8], .little);
    const expected = 8 + @as(u64, extra_length) * 4 + strings_length;

    if (expected != body.len or (extra_length != 0 and extra_length < 3)) return error.InvalidBackendProtocol;
}
