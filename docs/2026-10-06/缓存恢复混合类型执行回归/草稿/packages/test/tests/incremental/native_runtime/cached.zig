const std = @import("std");
const compiler = @import("compiler");
const codec = compiler.project.SemanticCache.codec;
const compiler_identity = @as([32]u8, @splat(17));

pub fn restore(allocator: std.mem.Allocator, module: compiler.project.artifact.Module, context_digest: [32]u8) !compiler.project.artifact.Result {
    const bytes = try codec.encode(allocator, module, context_digest, compiler_identity);

    defer allocator.free(bytes);

    var decoded = try codec.decode(allocator, bytes, compiler_identity);

    errdefer decoded.result.deinit();

    if (!std.mem.eql(u8, &decoded.context_digest, &context_digest)) return error.InvalidContextDigest;
    if (!std.mem.eql(u8, &decoded.result.value.source_digest, &module.source_digest)) return error.InvalidSourceDigest;
    if (!std.mem.eql(u8, decoded.result.value.path, module.path)) return error.InvalidDecodedPath;

    @memset(bytes, 0);

    return decoded.result;
}
