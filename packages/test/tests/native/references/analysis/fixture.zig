const std = @import("std");
pub const compiler = @import("compiler");
pub const declaration = "export type Node = opaque\n\nexport declare function identity(node: Node): Node\n\nexport declare function count(node: Node): u64\n\nexport declare function childAt(node: Node, index: u64): Node throws { IndexOutOfBounds }\n";

pub const Case = struct {
    body: []const u8 = "return host.identity(in)",
    input: []const u8 = "Node",
    output: []const u8 = "Node",
    declaration: []const u8 = declaration,
    extra: []const u8 = "",
    context: compiler.Context = .{},
    sources: []const compiler.project.Source = &.{},
    imports: []const u8 = "",
};

pub const Failure = struct {
    code: @FieldType(compiler.Diagnostic, "code"),
    message: []const u8,
    span_text: ?[]const u8 = null,
    native: bool = false,
};

pub fn sourceText(allocator: std.mem.Allocator, case: Case) ![]u8 {
    return std.fmt.allocPrint(allocator, "import host from \"zig:host\"\n{s}\nimport type {{ Node }} from \"zig:host\"\n\n{s}export type Input = {s}\n\nexport type Output = {s}\n\nexport default function (in: Input): Output {{\n  {s}\n}}\n", .{ case.imports, case.extra, case.input, case.output, case.body });
}

pub fn analyze(allocator: std.mem.Allocator, case: Case) !compiler.AnalysisResult {
    const source = try sourceText(allocator, case);

    defer allocator.free(source);

    const sources = try allocator.alloc(compiler.project.Source, 1 + case.sources.len);

    defer allocator.free(sources);

    sources[0] = .{ .path = "main.zx", .source = source };

    @memcpy(sources[1..], case.sources);

    return compiler.analyzeProject(allocator, sources, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .context = case.context,
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = case.declaration, .module = "host" }},
    });
}

pub fn accepted(allocator: std.mem.Allocator, case: Case) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected reference diagnostic {t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    const program = result.value.ir;
    const binding = program.native_modules.at(0).types.at(0);

    try std.testing.expectEqualStrings("Node", binding.name);
    try std.testing.expect(program.typeOf(binding.type_id) == .native_reference);
    try std.testing.expectEqualStrings("Node", program.typeOf(binding.type_id).native_reference);
    try std.testing.expectEqualStrings("zig:host", compiler.ir.nativeReferenceOwner(program, binding.type_id).?);
}

pub fn rejected(allocator: std.mem.Allocator, case: Case, expected: Failure) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;
    const source = try sourceText(allocator, case);

    defer allocator.free(source);

    if (issue.code != expected.code) std.debug.print("unexpected reference diagnostic {t}: {s}\n", .{ issue.code, issue.message });
    try std.testing.expectEqual(expected.code, issue.code);
    try std.testing.expectEqual(@as(?usize, 0), issue.source_index);
    try std.testing.expect(issue.span.start <= issue.span.end and issue.span.end <= source.len);

    if (expected.native) {
        try std.testing.expect(std.mem.startsWith(u8, issue.message, "host.d.zx:"));
        try std.testing.expect(std.mem.endsWith(u8, issue.message, expected.message));
        try std.testing.expectEqual(@as(usize, 0), issue.span.start);
        try std.testing.expectEqualStrings("import host from \"zig:host\"", source[issue.span.start..issue.span.end]);
    } else {
        try std.testing.expectEqualStrings(expected.message, issue.message);
    }

    if (expected.span_text) |text| try std.testing.expectEqualStrings(text, source[issue.span.start..issue.span.end]);
}
