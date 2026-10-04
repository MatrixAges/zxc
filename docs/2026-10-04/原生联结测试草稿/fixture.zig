const std = @import("std");
pub const compiler = @import("compiler");
pub const artifact = compiler.project.artifact;
const signature = "export enum Mode { First, Second } export declare function flip(input: Mode): Mode;";
const prefix = "import native from \"zig:choice\"; import { Mode } from \"zig:choice\"; export type Input = Mode; export type Output = Mode; ";

pub const Fixture = struct {
    results: [2]artifact.Result,
    modules: [2]artifact.Module,

    pub fn init() !Fixture {
        var analysis = try compiler.project.analyze(std.testing.allocator, &.{
            .{ .path = "main.zx", .source = "import helper from \"./helper.zx\"; " ++ prefix ++ "export default function (in: Input): Output { return native.flip(helper(in)); }" },
            .{ .path = "helper.zx", .source = prefix ++ "export default function (in: Input): Output { return native.flip(in); }" },
        }, .{
            .entry = "main.zx",
            .root_dir = "/project",
            .native_interfaces = &.{.{ .specifier = "zig:choice", .path = "choice.d.zx", .source = signature, .module = "choice" }},
        });

        defer analysis.deinit();

        if (analysis.value == .diagnostic) std.debug.print("{t}: {s}\n", .{ analysis.value.diagnostic.code, analysis.value.diagnostic.message });

        try std.testing.expect(analysis.value == .ir);
        try std.testing.expectEqual(@as(usize, 2), analysis.modules.len);

        var result: Fixture = undefined;
        var count: usize = 0;

        errdefer for (result.results[0..count]) |*item| item.deinit();

        for (&result.results, &result.modules, 0..) |*item, *module, index| {
            item.* = try artifact.extract(std.testing.allocator, &analysis, index);
            module.* = item.value;
            count += 1;
        }

        return result;
    }

    pub fn deinit(self: *Fixture) void {
        for (&self.results) |*item| item.deinit();
    }
};

pub fn check(result: artifact.linker.Result) !void {
    try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.program) == null);
    try std.testing.expectEqual(@as(usize, 1), result.program.native_modules.len);
    try std.testing.expectEqual(@as(usize, 1), result.nominal_types.len);
    try std.testing.expectEqualStrings("zig:choice", result.nominal_types[0].origin.native);
    try std.testing.expectEqualStrings("Mode", result.nominal_types[0].name);
    try std.testing.expectEqual(@as(usize, 2), result.program.functions.len);

    var external_count: usize = 0;

    for (result.program.functions) |function| {
        if (function.external) |external| {
            external_count += 1;

            try std.testing.expectEqualStrings("flip", external.exportName());
            try std.testing.expectEqual(result.nominal_types[0].type_id, function.input_type);
            try std.testing.expectEqual(result.nominal_types[0].type_id, function.output_type);
        }
    }

    try std.testing.expectEqual(@as(usize, 1), external_count);
}
