const std = @import("std");
const compiler = @import("compiler");

pub const Case = struct {
    input: []const u8 = "u64",
    output: []const u8 = "u64",
    parameters: []const u8 = "input: Value",
    arguments: []const u8 = "in",
    prefix: []const u8 = "",
    suffix: []const u8 = "",
    pure: bool = true,
    local: bool = true,
    io: bool = false,
    process: bool = false,
    allocating: bool = false,
    expanded: bool = false,
};

pub fn analyze(allocator: std.mem.Allocator, case: Case) !compiler.AnalysisResult {
    const declaration = try std.fmt.allocPrint(allocator, "export type Node = opaque\n\nexport type Cell = {{ value: u64 }}\n\nexport type Value = {s}\n\nexport type Result = {s}\n\nexport declare function apply({s}{s}): Result{s}\n", .{ case.input, case.output, case.prefix, case.parameters, case.suffix });

    defer allocator.free(declaration);

    const leaf = try std.fmt.allocPrint(allocator, "import host from \"zig:host\"\n\nimport type {{ Input, Output }} from \"./model\"\n\nexport default function (in: Input): Output {{\n  return {{ value: host.apply({s}) }}\n}}\n", .{case.arguments});

    defer allocator.free(leaf);

    var result = try compiler.analyzeProject(allocator, &.{
        .{ .path = "model.zx", .source = "import type { Value, Result } from \"zig:host\"\n\nexport type Input = Value\n\nexport type Output = { value: Result }\n" },
        .{ .path = "leaf.zx", .source = leaf },
        .{ .path = "middle.zx", .source = "import leaf from \"./leaf\"\n\nimport type { Input, Output } from \"./model\"\n\nexport default function (in: Input): Output {\n  return leaf(in)\n}\n" },
        .{ .path = "main.zx", .source = "import middle from \"./middle\"\n\nimport type { Input, Output } from \"./model\"\n\nexport type Entry = Input\n\nexport default function (in: Input): Output {\n  return middle(in)\n}\n" },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = declaration, .module = "host" }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected native boundary diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}

pub fn check(allocator: std.mem.Allocator, case: Case) !void {
    var decoded = block: {
        var analysis = try analyze(allocator, case);

        defer analysis.deinit();

        try @import("inspection.zig").check(allocator, analysis.value.ir, case, 2);

        var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &analysis }});

        defer library.deinit();

        const bytes = try compiler.library.codec.encode(allocator, &library);

        defer allocator.free(bytes);

        const restored = try compiler.library.codec.decode(allocator, bytes);

        @memset(bytes, 0xdd);

        break :block restored;
    };

    defer decoded.deinit();

    try @import("inspection.zig").check(allocator, try decoded.module(0), case, 3);
}
