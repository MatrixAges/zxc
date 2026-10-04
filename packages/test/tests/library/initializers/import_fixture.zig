const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

pub fn analyze(allocator: std.mem.Allocator, distinct: bool, call: bool) !compiler.AnalysisResult {
    var original = try f.library(std.testing.allocator, .single);

    defer original.deinit();

    const bytes = try compiler.library.codec.encode(std.testing.allocator, &original);

    defer std.testing.allocator.free(bytes);

    var library = try compiler.library.codec.decode(std.testing.allocator, bytes);

    defer library.deinit();
    @memset(bytes, 0);

    const first = compiler.project.compiled.Library{ .instance = "counter@1", .artifact = "library.zxcir", .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types, .store_initializers = library.store_initializers };
    var second = first;

    second.instance = "counter@2";

    const source = if (call)
        "import read from \"first\"\nexport type Input = void\nexport type Output = u64\nexport default function (in: Input): Output { return read(in) }\n"

    else
        "import first from \"first\"\nimport second from \"second\"\nexport type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return in }\n";

    return compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{
            .{ .specifier = "first", .compiled = .{ .instance = first.instance, .artifact = first.artifact, .name = "left" } },
            .{ .specifier = "second", .compiled = .{ .instance = if (distinct) second.instance else first.instance, .artifact = first.artifact, .name = "left" } },
        },
        .compiled_libraries = if (distinct) &.{ first, second } else &.{first},
    });
}
