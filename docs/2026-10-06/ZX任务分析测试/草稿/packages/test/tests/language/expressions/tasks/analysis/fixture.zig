const std = @import("std");
pub const compiler = @import("compiler");

pub const declarations =
    "export declare function apply(input: u64): u64 throws { NativeFailure } concurrent\n" ++
    "export declare function other(input: u64): u64 throws { OtherFailure } concurrent\n" ++
    "export declare function effect(input: u64): void throws { EffectFailure } concurrent\n";

pub const helper = "import native from \"zig:sample\"\nexport type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return native.apply(in) }\n";

pub const Case = struct {
    body: []const u8,
    input: []const u8 = "u64",
    output: []const u8 = "u64",
    declaration: []const u8 = declarations,
    imports: []const u8 = "",
    sources: []const compiler.project.Source = &.{},
};

pub const Failure = struct {
    code: @FieldType(compiler.Diagnostic, "code"),
    message: ?[]const u8 = null,
};

pub fn analyze(allocator: std.mem.Allocator, case: Case) !compiler.AnalysisResult {
    const source = try sourceText(allocator, case);

    defer allocator.free(source);

    const sources = try allocator.alloc(compiler.project.Source, 1 + case.sources.len);

    defer allocator.free(sources);

    sources[0] = .{ .path = "main.zx", .source = source };

    @memcpy(sources[1..], case.sources);

    return compiler.project.analyze(allocator, sources, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = case.declaration, .module = "sample" }},
    });
}

pub fn accepted(allocator: std.mem.Allocator, case: Case) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    if (result.value == .diagnostic) std.debug.print("unexpected diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
}

pub fn rejected(allocator: std.mem.Allocator, case: Case, expected: Failure) !void {
    var result = try analyze(allocator, case);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;
    const source = try sourceText(allocator, case);

    defer allocator.free(source);

    if (issue.code != expected.code or (expected.message != null and !std.mem.eql(u8, expected.message.?, issue.message))) std.debug.print("unexpected diagnostic {t}: {s}\n", .{ issue.code, issue.message });
    try std.testing.expectEqual(expected.code, issue.code);
    try std.testing.expectEqual(@as(?usize, 0), issue.source_index);
    try std.testing.expect(issue.span.start <= issue.span.end and issue.span.end <= source.len);
    if (expected.message) |message| try std.testing.expectEqualStrings(message, issue.message);
}

pub fn expectErrors(actual: []const []const u8, expected: []const []const u8) !void {
    try std.testing.expectEqual(expected.len, actual.len);

    for (expected) |name| {
        var found = false;

        for (actual) |member| if (std.mem.eql(u8, name, member)) {
            found = true;
        };

        try std.testing.expect(found);
    }
}

fn sourceText(allocator: std.mem.Allocator, case: Case) ![]u8 {
    return std.fmt.allocPrint(allocator, "import native from \"zig:sample\"\n{s}\nexport type Input = {s}\nexport type Output = {s}\nexport default function (in: Input): Output {{\n{s}\n}}\n", .{ case.imports, case.input, case.output, case.body });
}
