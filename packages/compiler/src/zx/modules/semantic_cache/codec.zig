const std = @import("std");
const zx = @import("zx");
const Artifact = @import("../artifact/model.zig");
pub const marker = "zxc.module.v7\n";
const Payload = struct { ir_version: u32, context_digest: [32]u8, module: Artifact.Module };
pub const Decoded = struct { result: Artifact.Result, context_digest: [32]u8 };
pub const Error = std.mem.Allocator.Error || error{InvalidCache};
const generated = @import("parser_options").generated_parser;

pub fn encode(allocator: std.mem.Allocator, module: Artifact.Module, context_digest: [32]u8, compiler_digest: [32]u8) std.mem.Allocator.Error![]u8 {
    const value = Payload{ .ir_version = zx.ir_version, .context_digest = context_digest, .module = module };

    if (generated) return @import("envelope.zig").encode(allocator, value, compiler_digest);

    const payload = try std.json.Stringify.valueAlloc(allocator, value, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    @import("zx").Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, marker ++ "{s}\n{s}\n{s}", .{ std.fmt.bytesToHex(compiler_digest, .lower), std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn decode(allocator: std.mem.Allocator, bytes: []const u8, compiler_digest: [32]u8) Error!Decoded {
    const payload = (if (generated) @import("envelope.zig").open(bytes, compiler_digest) else openSeed(bytes, compiler_digest)) orelse return error.InvalidCache;
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    try checkDepth(arena.allocator(), payload);

    const Envelope = struct { ir_version: u32 };

    const envelope = std.json.parseFromSliceLeaky(Envelope, arena.allocator(), payload, .{ .ignore_unknown_fields = true }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidCache;
    };

    if (envelope.ir_version != zx.ir_version) return error.InvalidCache;

    const parsed = std.json.parseFromSliceLeaky(Payload, arena.allocator(), payload, .{ .allocate = .alloc_always }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidCache;
    };

    if (generated) {
        if (!try @import("validation.zig").validate(allocator, arena.allocator(), &parsed.module)) return error.InvalidCache;
    } else {
        try validateSeed(allocator, arena.allocator(), &parsed.module);
    }

    return .{ .result = .{ .arena = arena, .value = parsed.module }, .context_digest = parsed.context_digest };
}

fn validateSeed(allocator: std.mem.Allocator, artifact_allocator: std.mem.Allocator, module: *const Artifact.Module) Error!void {
    if (!module.functions.validStructure() or !module.native_modules.validStructure() or !module.stores.validStructure() or !@import("../../ir/type_rules.zig").validate(module.types)) return error.InvalidCache;
    if (!try @import("../../analysis/constants/check.zig").validate(artifact_allocator, module.types, module.constant_exports)) return error.InvalidCache;
    if (!try @import("../../analysis/constants/check.zig").validate(artifact_allocator, module.types, module.constant_imports)) return error.InvalidCache;

    for ([_][]const @import("../function_import.zig"){ module.function_imports, module.members }) |bindings| for (bindings) |binding| {
        if (!binding.valid()) return error.InvalidCache;
        if (binding.intrinsic != null) continue;
        if (@backingInt(binding.id.?) >= module.functions.count()) return error.InvalidCache;

        const signature = module.functions.at(@backingInt(binding.id.?));

        if (binding.input_type != signature.input_type or binding.output_type != signature.output_type) return error.InvalidCache;
    };

    if (module.function) |function| {
        if (!function.stores.validStructure() or !try function.body.validStructure(allocator) or !function.symbols.validStructure() or !function.expressions.validStructure()) return error.InvalidCache;
        if (!function.contracts.validStructure()) return error.InvalidCache;

        for (0..function.contracts.count()) |contract_index| {
            const contract = function.contracts.at(contract_index);

            if (!contract.symbols.validStructure() or !contract.expressions.validStructure()) return error.InvalidCache;
        }
    }
}

fn openSeed(bytes: []const u8, compiler_digest: [32]u8) ?[]const u8 {
    const header_len = marker.len + 65 + 65;

    if (bytes.len < header_len or !std.mem.startsWith(u8, bytes, marker)) return null;

    const expected_compiler = std.fmt.bytesToHex(compiler_digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len..][0..64], &expected_compiler) or bytes[marker.len + 64] != '\n' or bytes[header_len - 1] != '\n') return null;

    const payload = bytes[header_len..];
    var digest: [32]u8 = undefined;

    @import("zx").Sha256.hash(payload, &digest, .{});

    const expected_content = std.fmt.bytesToHex(digest, .lower);

    if (!std.mem.eql(u8, bytes[marker.len + 65 ..][0..64], &expected_content)) return null;

    return payload;
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
