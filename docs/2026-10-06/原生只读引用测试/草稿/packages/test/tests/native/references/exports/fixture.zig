const std = @import("std");
pub const compiler = @import("compiler");

pub fn analyze(allocator: std.mem.Allocator, shape: []const u8) !compiler.AnalysisResult {
    const source = try std.fmt.allocPrint(allocator, "import host from \"zig:host\"\n\nimport type {{ Node }} from \"zig:host\"\n\nexport type Input = {s}\n\nexport type Output = Input\n\nexport default function (in: Input): Output {{\n  return in\n}}\n", .{shape});

    defer allocator.free(source);

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .module = "host", .path = "host.d.zx", .source = "export type Node = opaque\n\nexport declare function identity(node: Node): Node\n" }},
    });

    errdefer result.deinit();

    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    return result;
}

pub fn rejectNapi(allocator: std.mem.Allocator, shape: []const u8, incoming: bool) !void {
    var result = try analyze(allocator, shape);

    defer result.deinit();

    const program = result.value.ir;
    const scalar: compiler.ir.TypeId = @fromBackingInt(@backingInt(compiler.ir.Scalar.u64));

    const source = compiler.zig.host.node.napi.render(allocator, program.types, if (incoming) program.input_type else scalar, if (incoming) scalar else program.output_type) catch |err| {
        if (err == error.UnsupportedNodeType) return;

        return err;
    };

    defer allocator.free(source);

    return error.ExpectedUnsupportedNodeType;
}

pub fn gateway(allocator: std.mem.Allocator, shape: []const u8, rejected: bool) !void {
    var analysis = try analyze(allocator, shape);

    defer analysis.deinit();

    var library = try compiler.library.link(allocator, &.{.{ .name = "read", .analysis = &analysis }});

    defer library.deinit();

    var bundle = try compiler.zig.emitLibrary(allocator, &library);

    var generated = compiler.zig.gateway.create(&library, &bundle, .{
        .routes = &.{},
        .listen = "127.0.0.1:8080",
        .max_header_bytes = 4096,
        .max_body_bytes = 4096,
    }) catch |err| {
        bundle.deinit();

        if (rejected and err == error.UnsupportedHostReference) return;

        return err;
    };

    defer generated.deinit();

    try std.testing.expect(!rejected);
    try std.testing.expect(generated.entry.source.len != 0);
}
