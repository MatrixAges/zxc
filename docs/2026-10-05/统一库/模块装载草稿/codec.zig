const std = @import("std");
const zx = @import("zx");
const model = @import("root.zig");
const validation = @import("validate.zig");
const marker = "zxc.library.v1\n";

const Payload = struct {
    ir_version: u32,
    program: zx.ir.Program,
    exports: []const model.Export,
    nominal_types: @FieldType(model.Result, "nominal_types"),
};

pub const Error = validation.Error || error{IncompatibleLibraryVersion};

pub fn encode(allocator: std.mem.Allocator, library: *const model.Result) Error![]u8 {
    try validation.validate(allocator, library);

    const payload = try std.json.Stringify.valueAlloc(allocator, Payload{
        .ir_version = zx.ir_version,
        .program = library.program,
        .exports = library.exports,
        .nominal_types = library.nominal_types,
    }, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, marker ++ "{s}\n{s}", .{ std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn decode(allocator: std.mem.Allocator, bytes: []const u8) Error!model.Result {
    const header_len = marker.len + 65;

    if (bytes.len < header_len or !std.mem.startsWith(u8, bytes, marker) or bytes[header_len - 1] != '\n') return error.InvalidLibrary;

    const payload = bytes[header_len..];
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    const expected = std.fmt.bytesToHex(digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len..][0..64], &expected)) return error.InvalidLibrary;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    try depth(arena.allocator(), payload);

    const parsed = std.json.parseFromSliceLeaky(Payload, arena.allocator(), payload, .{ .allocate = .alloc_always }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidLibrary;
    };

    if (parsed.ir_version != zx.ir_version or parsed.program.version != zx.ir_version) return error.IncompatibleLibraryVersion;

    const result = model.Result{ .arena = arena, .program = parsed.program, .exports = parsed.exports, .nominal_types = parsed.nominal_types };

    try validation.validate(allocator, &result);

    return result;
}

fn depth(allocator: std.mem.Allocator, bytes: []const u8) Error!void {
    var scanner = std.json.Scanner.initCompleteInput(allocator, bytes);

    defer scanner.deinit();

    while (true) {
        const token = scanner.next() catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return error.InvalidLibrary;
        };

        if (scanner.stackHeight() > 2048) return error.InvalidLibrary;
        if (token == .end_of_document) return;
    }
}
