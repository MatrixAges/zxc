const std = @import("std");
const zx = @import("zx");
const Artifact = @import("../artifact/model.zig");
const marker = "zxc.module.v2\n";
const Payload = struct { ir_version: u32, context_digest: [32]u8, module: Artifact.Module };
pub const Decoded = struct { result: Artifact.Result, context_digest: [32]u8 };
pub const Error = std.mem.Allocator.Error || error{InvalidCache};

pub fn encode(allocator: std.mem.Allocator, module: Artifact.Module, context_digest: [32]u8, compiler_digest: [32]u8) std.mem.Allocator.Error![]u8 {
    const payload = try std.json.Stringify.valueAlloc(allocator, Payload{ .ir_version = zx.ir_version, .context_digest = context_digest, .module = module }, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, marker ++ "{s}\n{s}\n{s}", .{ std.fmt.bytesToHex(compiler_digest, .lower), std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn decode(allocator: std.mem.Allocator, bytes: []const u8, compiler_digest: [32]u8) Error!Decoded {
    const header_len = marker.len + 65 + 65;

    if (bytes.len < header_len or !std.mem.startsWith(u8, bytes, marker)) return error.InvalidCache;

    const expected_compiler = std.fmt.bytesToHex(compiler_digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len..][0..64], &expected_compiler) or bytes[marker.len + 64] != '\n' or bytes[header_len - 1] != '\n') return error.InvalidCache;

    const payload = bytes[header_len..];
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    const expected_content = std.fmt.bytesToHex(digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len + 65 ..][0..64], &expected_content)) return error.InvalidCache;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    try checkDepth(arena.allocator(), payload);

    const parsed = std.json.parseFromSliceLeaky(Payload, arena.allocator(), payload, .{ .allocate = .alloc_always }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidCache;
    };

    if (parsed.ir_version != zx.ir_version or !@import("../../ir/type_rules.zig").validate(parsed.module.types)) return error.InvalidCache;

    return .{ .result = .{ .arena = arena, .value = parsed.module }, .context_digest = parsed.context_digest };
}

fn checkDepth(allocator: std.mem.Allocator, bytes: []const u8) Error!void {
    var scanner = std.json.Scanner.initCompleteInput(allocator, bytes);

    defer scanner.deinit();

    while (true) {
        const token = scanner.next() catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return error.InvalidCache;
        };

        if (scanner.stackHeight() > 2048) return error.InvalidCache;
        if (token == .end_of_document) return;
    }
}
