const std = @import("std");
const zx = @import("zx");
const model = @import("root.zig");
const validation = @import("validate.zig");
const generated = @import("parser_options").generated_parser;
const marker = "zxc.library.v2\n";
const legacy_marker = "zxc.library.v1\n";
const Frame = @import("envelope.zig").Payload;
const Versions = struct { ir_version: u32, program: struct { version: u32 } };

const Payload = struct {
    ir_version: u32,
    program: zx.ir.Program,
    exports: []const model.Export,
    nominal_types: @FieldType(model.Result, "nominal_types"),
    store_initializers: @FieldType(model.Result, "store_initializers") = &.{},
};

pub const Error = validation.Error || error{IncompatibleLibraryVersion};

pub fn encode(allocator: std.mem.Allocator, library: *const model.Result) Error![]u8 {
    try validation.validate(allocator, library);

    const value: Payload = .{
        .ir_version = zx.ir_version,
        .program = library.program,
        .exports = library.exports,
        .nominal_types = library.nominal_types,
        .store_initializers = library.store_initializers,
    };

    if (generated) return @import("envelope.zig").encode(allocator, value);

    const payload = try std.json.Stringify.valueAlloc(allocator, value, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    @import("zx").Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, marker ++ "{s}\n{s}", .{ std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn decode(allocator: std.mem.Allocator, bytes: []const u8) Error!model.Result {
    const frame = (if (generated) @import("envelope.zig").open(bytes) else openSeed(bytes)) orelse return error.InvalidLibrary;
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const memory = arena.allocator();

    try checkVersions(memory, frame);

    const parsed = std.json.parseFromSliceLeaky(Payload, memory, frame.bytes, .{ .allocate = .alloc_always }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidLibrary;
    };

    if (frame.legacy and parsed.store_initializers.len != 0) return error.InvalidLibrary;

    const result = model.Result{ .arena = arena, .program = parsed.program, .exports = parsed.exports, .nominal_types = parsed.nominal_types, .store_initializers = parsed.store_initializers };

    try validation.validate(allocator, &result);

    return result;
}

fn checkVersions(allocator: std.mem.Allocator, frame: Frame) Error!void {
    const options: std.json.ParseOptions = .{ .ignore_unknown_fields = true };

    if (!generated) try checkSeedDepth(allocator, frame.bytes, frame.maximum_depth);

    const versions = (if (generated)
        @import("frontend").artifact_json.parse(Versions, allocator, frame.bytes, frame.maximum_depth, options)
    else
        std.json.parseFromSliceLeaky(Versions, allocator, frame.bytes, options)) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidLibrary,
    };

    const compatible = if (generated)
        @import("envelope.zig").compatible(versions.ir_version, versions.program.version, zx.ir_version)
    else
        versions.ir_version == zx.ir_version and versions.program.version == zx.ir_version;

    if (!compatible) return error.IncompatibleLibraryVersion;
}

fn openSeed(bytes: []const u8) ?Frame {
    const header_len = marker.len + 65;
    const legacy = std.mem.startsWith(u8, bytes, legacy_marker);

    if (bytes.len < header_len or (!legacy and !std.mem.startsWith(u8, bytes, marker)) or bytes[header_len - 1] != '\n') return null;

    const payload = bytes[header_len..];
    var digest: [32]u8 = undefined;

    zx.Sha256.hash(payload, &digest, .{});

    const expected = std.fmt.bytesToHex(digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len..][0..64], &expected)) return null;

    return .{ .bytes = payload, .maximum_depth = 2048, .legacy = legacy };
}

fn checkSeedDepth(allocator: std.mem.Allocator, bytes: []const u8, maximum_depth: usize) Error!void {
    var scanner = std.json.Scanner.initCompleteInput(allocator, bytes);

    defer scanner.deinit();

    while (true) {
        const token = scanner.next() catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return error.InvalidLibrary;
        };

        if (scanner.stackHeight() > maximum_depth) return error.InvalidLibrary;
        if (token == .end_of_document) return;
    }
}
