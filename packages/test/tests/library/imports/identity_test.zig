const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

test "compiled analysis owns library data after decoded input release" {
    var result = block: {
        var original = try f.library();
        defer original.deinit();
        const bytes = try compiler.library.codec.encode(std.testing.allocator, &original);
        defer std.testing.allocator.free(bytes);
        var decoded = try compiler.library.codec.decode(std.testing.allocator, bytes);
        defer decoded.deinit();
        @memset(bytes, 0);

        break :block try f.analyze(f.call, &.{ f.package("sample", "call"), f.package("sample/types", "types") }, &.{f.dependency(&decoded)});
    };
    defer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);
    var bundle = try compiler.zig.emitModules(std.testing.allocator, &result);
    defer bundle.deinit();
    try std.testing.expect(bundle.modules.len > 0);
    try std.testing.expect(bundle.types.len > 0);
}

fn compareInstances(distinct: bool) !void {
    var value = try f.library();
    defer value.deinit();
    const first = f.dependency(&value);
    var second = first;
    second.instance = "sample@2";
    var right = f.package("right", "types");
    if (distinct) right.compiled.?.instance = second.instance;

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "left.zx", .source = "import { Mode } from \"left\"\nexport type Left = Mode\n" },
        .{ .path = "right.zx", .source = "import { Mode } from \"right\"\nexport type Right = Mode\n" },
        .{ .path = "main.zx", .source = "import type { Left } from \"./left.zx\"\nimport type { Right } from \"./right.zx\"\nexport type Input = Left\nexport type Output = Right\nexport default function (in: Input): Output { return in }\n" },
    }, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{ f.package("left", "types"), right },
        .compiled_libraries = if (distinct) &.{ first, second } else &.{first},
    });
    defer result.deinit();

    if (distinct) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.type_mismatch, result.value.diagnostic.code);
    } else {
        try std.testing.expect(result.value == .ir);
        try std.testing.expectEqual(result.value.ir.input_type, result.value.ir.output_type);
    }
}

test "compiled aliases of one instance preserve nominal enum identity" {
    try compareInstances(false);
}

test "compiled copies in distinct instances isolate nominal enum identity" {
    try compareInstances(true);
}
