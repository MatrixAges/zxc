const std = @import("std");
pub const compiler = @import("compiler");
pub const artifact = compiler.project.artifact;
pub const Record = @typeInfo(@FieldType(compiler.AnalysisResult, "modules")).pointer.child;
pub const main_path = "/project/main.zx";
pub const helper_path = "/project/helper.zx";
pub const types_path = "/project/types.zx";
pub const orders = [_][3]usize{ .{ 0, 1, 2 }, .{ 0, 2, 1 }, .{ 1, 0, 2 }, .{ 1, 2, 0 }, .{ 2, 0, 1 }, .{ 2, 1, 0 } };
const imports = [_][]const u8{ "import helper from \"./helper\"\n", "import native from \"zig:host\"\n", "import remote from \"lib:remote\"\n" };
const declarations = "export enum Mode { First, Second }\nexport type Count = u64\n";
const signature = "export type Input = u64\nexport type Output = u64\n";

pub fn analyze(order: [3]usize) !compiler.AnalysisResult {
    var text: std.Io.Writer.Allocating = .init(std.testing.allocator);

    defer text.deinit();

    for (order) |position| try text.writer.writeAll(imports[position]);
    try text.writer.writeAll("import { Mode } from \"./types\"\nimport type { Count } from \"./types\"\n" ++ signature ++ "export default function (in: Input): Output { return remote(native.echo(helper(in))) }\n");

    var result = try compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = text.written() },
        .{ .path = "helper.zx", .source = "import { Mode } from \"./types\"\nimport type { Count } from \"./types\"\nexport type Input = Count\nexport type Output = Count\nexport default function (in: Input): Output { return in + 1 }\n" },
        .{ .path = "types.zx", .source = declarations },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = "export declare function echo(input: u64): u64\n", .module = "host" }},
        .externals = &.{.{ .specifier = "lib:remote", .signature = signature, .implementation = .{ .module = "remote", .member = "echo" } }},
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("provenance fixture: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try compiler.validateIr(std.testing.allocator, result.value.ir));
    try std.testing.expectEqual(@as(usize, 3), result.modules.len);

    return result;
}

pub fn index(analysis: compiler.AnalysisResult, path: []const u8) !usize {
    for (analysis.modules, 0..) |record, position| {
        if (std.mem.eql(u8, record.path, path)) return position;
    }

    return error.MissingFixtureModule;
}

pub fn snapshot(analysis: compiler.AnalysisResult) ![]u8 {
    return std.json.Stringify.valueAlloc(std.testing.allocator, .{ .program = analysis.value.ir, .modules = analysis.modules, .origins = analysis.nominal_types }, .{});
}

pub fn unchanged(before: []const u8, analysis: compiler.AnalysisResult) !void {
    const after = try snapshot(analysis);

    defer std.testing.allocator.free(after);

    try std.testing.expectEqualStrings(before, after);
}

pub fn control(analysis: *const compiler.AnalysisResult, selected: usize) !void {
    var result = try artifact.extract(std.testing.allocator, analysis, selected);

    defer result.deinit();

    try std.testing.expectEqualStrings(analysis.modules[selected].path, result.value.path);
    try std.testing.expect(result.value.types.validStructure());
    try std.testing.expectEqual(analysis.modules[selected].body != .types, result.value.function != null);
    try std.testing.expectEqualDeep(analysis.modules[selected].imports, result.value.dependencies);
}
