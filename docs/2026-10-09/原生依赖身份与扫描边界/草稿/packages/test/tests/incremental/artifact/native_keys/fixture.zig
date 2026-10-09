const std = @import("std");
pub const compiler = @import("compiler");
pub const artifact = compiler.project.artifact;
pub const Record = @typeInfo(@FieldType(compiler.AnalysisResult, "modules")).pointer.child;
pub const Import = Record.Import;
pub const orders = [_][3]usize{ .{ 0, 1, 2 }, .{ 0, 2, 1 }, .{ 1, 0, 2 }, .{ 1, 2, 0 }, .{ 2, 0, 1 }, .{ 2, 1, 0 } };
pub const specifiers = [_][]const u8{ "zig:first", "zig:second", "zig:third" };
pub const identities = [_][]const u8{ "first@1", "second@1", "third@1" };
const imports = [_][]const u8{ "import first from \"zig:first\"\n", "import second from \"zig:second\"\n", "import third from \"zig:third\"\n" };
const signature = "export declare function echo(input: u64): u64\n";

pub fn analyze(order: [3]usize, identified: bool) !compiler.AnalysisResult {
    var source: std.Io.Writer.Allocating = .init(std.testing.allocator);

    defer source.deinit();

    for (order) |position| try source.writer.writeAll(imports[position]);
    try source.writer.writeAll("import type { Count } from \"./types\"\nimport helper from \"./helper\"\nexport type Input = Count\nexport type Output = u64\nexport default function (in: Input): Output { return first.echo(second.echo(third.echo(helper(in)))) }\n");

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = source.written() },
        .{ .path = "types.zx", .source = "export type Count = u64\n" },
        .{ .path = "helper.zx", .source = "import third from \"zig:third\"\nexport type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return third.echo(in) }\n" },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{
            .{ .specifier = specifiers[0], .identity = if (identified) identities[0] else null, .path = "first.d.zx", .source = signature, .module = "first" },
            .{ .specifier = specifiers[1], .identity = if (identified) identities[1] else null, .path = "second.d.zx", .source = signature, .module = "second" },
            .{ .specifier = specifiers[2], .identity = if (identified) identities[2] else null, .path = "third.d.zx", .source = signature, .module = "third" },
        },
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("native keys: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(std.testing.allocator, result.value.ir));
    try std.testing.expectEqual(@as(usize, 3), result.modules.len);
    try std.testing.expectEqual(@as(usize, 3), result.value.ir.native_modules.count());

    return result;
}

pub fn index(analysis: compiler.AnalysisResult, path: []const u8) !usize {
    for (analysis.modules, 0..) |record, position| {
        if (std.mem.eql(u8, record.path, path)) return position;
    }

    return error.MissingFixtureModule;
}

pub fn dependency(analysis: compiler.AnalysisResult, specifier: []const u8) !Import {
    const main = try index(analysis, "/project/main.zx");

    for (analysis.modules[main].imports) |item| {
        if (std.mem.eql(u8, item.specifier, specifier)) return item;
    }

    return error.MissingFixtureDependency;
}

pub fn snapshot(analysis: compiler.AnalysisResult) ![]u8 {
    return std.json.Stringify.valueAlloc(std.testing.allocator, .{ .program = analysis.value.ir, .modules = analysis.modules, .origins = analysis.nominal_types }, .{});
}

pub fn unchanged(before: []const u8, analysis: compiler.AnalysisResult) !void {
    const after = try snapshot(analysis);

    defer std.testing.allocator.free(after);

    try std.testing.expectEqualStrings(before, after);
}
