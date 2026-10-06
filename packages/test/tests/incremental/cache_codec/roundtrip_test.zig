const std = @import("std");
const f = @import("fixture.zig");

test "decoded type artifact owns strings after encoded bytes are destroyed" {
    var decoded = block: {
        const bytes = try f.bytes(std.testing.allocator);

        defer std.testing.allocator.free(bytes);

        const result = try f.codec.decode(std.testing.allocator, bytes, f.identity);

        @memset(bytes, 0);

        break :block result;
    };

    defer decoded.result.deinit();

    try std.testing.expectEqualSlices(u8, &f.context, &decoded.context_digest);
    try std.testing.expectEqualStrings("/project/shared.zx", decoded.result.value.path);
    try std.testing.expectEqual(@as(usize, 2), decoded.result.value.exports.len);
    try std.testing.expectEqualStrings("Mode", decoded.result.value.nominal_types.at(0).name);

    const origin = decoded.result.value.nominal_types.at(0);
    const enumeration = decoded.result.value.types.get(origin.type_id).enumeration;

    try std.testing.expectEqualStrings("/project/shared.zx", origin.origin.source);
    try std.testing.expectEqualStrings("First", enumeration.members[0]);
    try std.testing.expectEqualStrings("Second", enumeration.members[1]);
}

test "all decoded artifacts relink after original analysis and encoded bytes are freed" {
    var decoded: [4]f.codec.Decoded = undefined;
    var count: usize = 0;

    defer for (decoded[0..count]) |*item| item.result.deinit();

    {
        var analysis = try f.source.analyze(std.testing.allocator);

        defer analysis.deinit();

        try f.source.check(analysis);

        for (&decoded, 0..) |*item, index| {
            var artifact = try f.compiler.project.artifact.extract(std.testing.allocator, &analysis, index);

            defer artifact.deinit();

            const bytes = try f.codec.encode(std.testing.allocator, artifact.value, f.context, f.identity);

            defer std.testing.allocator.free(bytes);

            item.* = try f.codec.decode(std.testing.allocator, bytes, f.identity);
            count += 1;

            try std.testing.expectEqualSlices(u8, &artifact.value.source_digest, &item.result.value.source_digest);
        }
    }

    var modules: [4]f.compiler.project.artifact.Module = undefined;

    for (decoded, 0..) |item, index| modules[3 - index] = item.result.value;

    var linked = try f.compiler.project.artifact.linker.link(std.testing.allocator, &modules, "/project/main.zx");

    defer linked.deinit();

    try std.testing.expect(try f.compiler.validateIr(std.testing.allocator, linked.program) == null);
    try std.testing.expectEqual(@as(usize, 2), linked.program.functions.len);
    try std.testing.expectEqual(@as(usize, 1), linked.nominal_types.count());

    const generated = try f.compiler.zig.emit(std.testing.allocator, linked.program);

    defer std.testing.allocator.free(generated);

    try std.testing.expect(generated.len != 0);
}
