const std = @import("std");
pub const compiler = @import("compiler");
pub const Case = struct { distinct: bool = false, swap: bool = false };

pub fn library(allocator: std.mem.Allocator) !compiler.library.Result {
    const source = "import host from \"zig:host\"\n\nimport type { Node } from \"zig:host\"\n\nexport type SharedNode = Node\n\nexport type Input = Node\n\nexport type Output = Node\n\nexport default function (in: Input): Output {\n  return host.identity(in)\n}\n";

    var analyzed = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/library",
        .native_interfaces = &.{.{ .specifier = "zig:host", .module = "host", .path = "host.d.zx", .source = "export type Node = opaque\n\nexport declare function identity(node: Node): Node\n" }},
    });

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, analyzed.value.ir) == null);

    return compiler.library.link(allocator, &.{ .{ .name = "call", .analysis = &analyzed }, .{ .name = "repeat", .analysis = &analyzed } });
}

pub fn consumerSource(allocator: std.mem.Allocator, case: Case) ![]u8 {
    return std.fmt.allocPrint(allocator, "import first from \"left\"\nimport second from \"right\"\n\nimport type {{ Left }} from \"./left\"\nimport type {{ Right }} from \"./right\"\n\nexport type Input = {{ left: Left, right: Right }}\n\nexport type Output = Input\n\nexport default function (in: Input): Output {{\n  return {{ left: first(in.left), right: second(in.{s}) }}\n}}\n", .{if (case.swap) "left" else "right"});
}

pub fn consume(allocator: std.mem.Allocator, value: *const compiler.library.Result, case: Case) !compiler.AnalysisResult {
    const first = compiler.project.compiled.Library{ .instance = "sample@1", .artifact = "sample.zxlib", .program = value.program, .exports = value.exports, .nominal_types = value.nominal_types };
    var second = first;
    second.instance = "sample@2";

    const source = try consumerSource(allocator, case);

    defer allocator.free(source);

    return compiler.analyzeProject(allocator, &.{
        .{ .path = "left.zx", .source = "import type { SharedNode } from \"left\"\n\nexport type Left = SharedNode\n" },
        .{ .path = "right.zx", .source = "import type { SharedNode } from \"right\"\n\nexport type Right = SharedNode\n" },
        .{ .path = "main.zx", .source = source },
    }, .{
        .entry = "main.zx",
        .root_dir = "/consumer",
        .packages = &.{
            .{ .specifier = "left", .compiled = .{ .instance = first.instance, .artifact = first.artifact, .name = "call" } },
            .{ .specifier = "right", .compiled = .{ .instance = if (case.distinct) second.instance else first.instance, .artifact = first.artifact, .name = "repeat" } },
        },
        .compiled_libraries = if (case.distinct) &.{ first, second } else &.{first},
    });
}

pub fn inspect(allocator: std.mem.Allocator, program: compiler.ir.Program, distinct: bool) !void {
    try std.testing.expect(try compiler.validateIr(allocator, program) == null);
    try std.testing.expectEqual(@as(usize, if (distinct) 2 else 1), program.native_modules.len);

    const fields = program.typeOf(program.input_type).object;

    try std.testing.expectEqual(@as(usize, 2), fields.len);
    try std.testing.expectEqualStrings("left", fields[0].name);
    try std.testing.expectEqualStrings("right", fields[1].name);
    try std.testing.expectEqual(distinct, fields[0].type_id != fields[1].type_id);

    for (fields) |field| {
        try std.testing.expect(program.typeOf(field.type_id) == .native_reference);
        try std.testing.expectEqualStrings("Node", program.typeOf(field.type_id).native_reference);
        try std.testing.expect(compiler.ir.nativeReferenceOwner(program, field.type_id) != null);
    }

    const left = compiler.ir.nativeReferenceOwner(program, fields[0].type_id).?;
    const right = compiler.ir.nativeReferenceOwner(program, fields[1].type_id).?;

    try std.testing.expectEqual(distinct, !std.mem.eql(u8, left, right));

    for (program.native_modules) |module| {
        try std.testing.expectEqualStrings("zig:host", module.specifier);
        try std.testing.expect(!std.mem.eql(u8, "host", module.import_name));
        try std.testing.expect(!std.mem.eql(u8, "zig:host", module.key()));
    }

    if (distinct) try std.testing.expect(!std.mem.eql(u8, program.native_modules[0].import_name, program.native_modules[1].import_name));
}
