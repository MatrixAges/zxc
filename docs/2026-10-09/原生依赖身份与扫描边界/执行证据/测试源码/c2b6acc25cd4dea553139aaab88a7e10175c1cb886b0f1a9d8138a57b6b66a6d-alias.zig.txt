const std = @import("std");
const f = @import("fixture.zig");
const signature = "export declare function echo(input: u64): u64\n";

pub fn analyze() !f.compiler.AnalysisResult {
    var result = try f.compiler.project.analyze(std.testing.allocator, &.{
        .{ .path = "main.zx", .source = "import helper from \"./helper\"\nimport alias from \"zig:alias\"\nimport type { Count } from \"./types\"\nexport type Input = Count\nexport type Output = Count\nexport default function (in: Input): Output { return alias.echo(helper(in)) }\n" },
        .{ .path = "helper.zx", .source = "import native from \"zig:canonical\"\nexport type Input = u64\nexport type Output = u64\nexport default function (in: Input): Output { return native.echo(in) }\n" },
        .{ .path = "types.zx", .source = "export type Count = u64\n" },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{
            .{ .specifier = "zig:canonical", .identity = "host@1", .module = "host", .path = "canonical.d.zx", .source = signature },
            .{ .specifier = "zig:alias", .identity = "host@1", .module = "host", .path = "alias.d.zx", .source = signature },
        },
    });

    errdefer result.deinit();

    if (result.value == .diagnostic) std.debug.print("native alias: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, result.value.ir));
    try std.testing.expectEqual(@as(usize, 1), result.value.ir.native_modules.count());
    try std.testing.expectEqualStrings("zig:canonical", result.value.ir.native_modules.at(0).specifier);
    try std.testing.expectEqualStrings("host@1", result.value.ir.native_modules.at(0).identity.?);

    return result;
}
