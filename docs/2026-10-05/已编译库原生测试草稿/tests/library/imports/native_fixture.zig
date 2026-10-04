const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

pub fn library() !compiler.library.Result {
    const source = "import native from \"zig:choice\"\nimport { Mode } from \"zig:choice\"\nexport type SharedMode = Mode\nexport type Input = Mode\nexport type Output = Mode\nexport default function (in: Input): Output { return native.flip(in) }\n";
    var analyzed = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/library",
        .native_interfaces = &.{.{ .specifier = "zig:choice", .module = "choice", .path = "choice.d.zx", .source = "export enum Mode { First, Second }\nexport declare function flip(input: Mode): Mode throws\n" }},
    });
    defer analyzed.deinit();
    try std.testing.expect(analyzed.value == .ir);

    return compiler.library.link(std.testing.allocator, &.{ .{ .name = "call", .analysis = &analyzed }, .{ .name = "repeat", .analysis = &analyzed } });
}

pub fn analyze(value: *const compiler.library.Result, distinct: bool) !compiler.AnalysisResult {
    const first = f.dependency(value);
    var second = first;
    second.instance = "sample@2";
    var right = f.package("right", "repeat");
    if (distinct) right.compiled.?.instance = second.instance;

    return compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "left.zx", .source = "import type { SharedMode } from \"left\"\nexport type Left = SharedMode\n" },
        .{ .path = "right.zx", .source = "import type { SharedMode } from \"right\"\nexport type Right = SharedMode\n" },
        .{ .path = "main.zx", .source = "import first from \"left\"\nimport second from \"right\"\nimport type { Left } from \"./left.zx\"\nimport type { Right } from \"./right.zx\"\nexport type Input = { left: Left, right: Right }\nexport type Output = Input\nexport default function (in: Input): Output { return { left: first(in.left), right: second(in.right) } }\n" },
    }, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{ f.package("left", "call"), right },
        .compiled_libraries = if (distinct) &.{ first, second } else &.{first},
    });
}
