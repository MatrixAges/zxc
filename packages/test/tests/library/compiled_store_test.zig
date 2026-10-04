const std = @import("std");
const compiler = @import("compiler");
const fixture = @import("store_fixture.zig");

fn analyze(call: bool, distinct: bool) !compiler.AnalysisResult {
    var original = try fixture.link(std.testing.allocator, "state.store.rx", "u64", false);
    defer original.deinit();
    const bytes = try compiler.library.codec.encode(std.testing.allocator, &original);
    defer std.testing.allocator.free(bytes);
    var library = try compiler.library.codec.decode(std.testing.allocator, bytes);
    defer library.deinit();
    @memset(bytes, 0);

    const first = compiler.project.compiled.Library{ .instance = "sample@1", .artifact = "sample.zxlib", .program = library.program, .exports = library.exports, .nominal_types = library.nominal_types };
    var second = first;
    second.instance = "sample@2";
    const source = if (call)
        "import run from \"left\"\nexport type Input = void\nexport type Output = u64\nexport default function (in: Input): Output { return run(in) }\n"
    else
        "import first from \"left\"\nimport second from \"right\"\nexport type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return in }\n";

    var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{
            .{ .specifier = "left", .compiled = .{ .instance = first.instance, .artifact = first.artifact, .name = "left" } },
            .{ .specifier = "right", .compiled = .{ .instance = if (distinct) second.instance else first.instance, .artifact = first.artifact, .name = "right" } },
        },
        .compiled_libraries = if (distinct) &.{ first, second } else &.{first},
    });
    errdefer result.deinit();
    if (!call and result.value == .diagnostic) {
        std.debug.print("compiled Store import: {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    }

    return result;
}

test "compiled Store import preserves valid IR without granting caller state" {
    var result = try analyze(false, false);
    defer result.deinit();
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(@as(usize, 0), result.value.ir.stores.len);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);

    var bundle = try compiler.zig.emitModules(std.testing.allocator, &result);
    defer bundle.deinit();
}

test "compiled Store instances keep valid distinct state paths" {
    var result = try analyze(false, true);
    defer result.deinit();
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);

    var paths: std.StringHashMapUnmanaged(void) = .empty;
    defer paths.deinit(std.testing.allocator);

    for (result.value.ir.functions) |function| for (function.stores) |slot| {
        try std.testing.expect(std.mem.startsWith(u8, slot.path, "store."));
        try paths.put(std.testing.allocator, slot.path, {});
    };
    try std.testing.expectEqual(@as(usize, 2), paths.count());
}

test "ordinary ZX rejects imported Store calls without orchestration authority" {
    var result = try analyze(true, false);
    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.capability, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
}
