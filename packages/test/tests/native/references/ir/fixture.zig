const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;

pub fn analyze(allocator: std.mem.Allocator) !compiler.AnalysisResult {
    const source = "import host from \"zig:host\"\n\nimport type { Node } from \"zig:host\"\n\nexport type Input = Node\n\nexport type Output = { node: Node, nodes: Node?[] }\n\nexport default function (in: Input): Output {\n  return { node: host.identity(in), nodes: [in, null] }\n}\n";

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = "export type Node = opaque\n\nexport declare function identity(node: Node): Node\n", .module = "host" }},
    });

    errdefer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}

pub fn rejected(allocator: std.mem.Allocator, program: ir.Program) !void {
    const diagnostic = (try compiler.validateIr(allocator, program)).?;

    try std.testing.expectEqual(.contract, diagnostic.code);
    try std.testing.expectEqualStrings("invalid ZX IR version, structure, types or bindings", diagnostic.message);
    try std.testing.expectEqual(@as(usize, 0), diagnostic.span.start);
    try std.testing.expectEqual(@as(usize, 0), diagnostic.span.end);

    const bundle = compiler.zig.emitBundle(allocator, program) catch |err| {
        if (err == error.InvalidIr) return;

        return err;
    };

    defer bundle.deinit(allocator);

    return error.ExpectedInvalidIr;
}

pub fn nativeOnly(program: ir.Program) ir.Program {
    var result = program;

    result.input_type = @fromBackingInt(@backingInt(ir.Scalar.void));
    result.output_type = result.input_type;
    result.output_ownership = .borrowed;
    result.type_only = true;
    result.symbols = .{};
    result.expressions = .{};
    result.body = .{};

    return result;
}
