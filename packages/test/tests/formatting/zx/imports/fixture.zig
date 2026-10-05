const std = @import("std");
const compiler = @import("compiler");
const lint = @import("lint");
pub const body = "export type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return in\n}\n";
pub const Declaration = struct { text: []const u8, group: u8 };

pub const declarations = [_]Declaration{
    .{ .text = "import stdFn from \"std:zeta\"", .group = 0 },
    .{ .text = "import zigFn from \"zig:zeta\"", .group = 0 },
    .{ .text = "import cFn from \"c:zeta\"", .group = 0 },
    .{ .text = "import packageFn from \"zeta\"", .group = 0 },
    .{ .text = "import { Mode } from \"@/mode\"", .group = 1 },
    .{ .text = "import localFn from \"./zeta\"", .group = 2 },
    .{ .text = "import type { StdType } from \"std:zeta\"", .group = 3 },
    .{ .text = "import type { ZigType } from \"zig:zeta\"", .group = 3 },
    .{ .text = "import type { CType } from \"c:zeta\"", .group = 3 },
    .{ .text = "import type { PackageType } from \"zeta\"", .group = 3 },
    .{ .text = "import type { RootType } from \"@/zeta\"", .group = 3 },
    .{ .text = "import type { LocalType } from \"./zeta\"", .group = 3 },
};

pub fn check(allocator: std.mem.Allocator, source: []const u8, expected: []const u8) !void {
    const formatted = try compiler.format(allocator, source, "imports.zx");

    defer formatted.deinit(allocator);

    try std.testing.expect(formatted == .source);
    try std.testing.expectEqualStrings(expected, formatted.source);

    var original = try compiler.parse(allocator, source, "imports.zx");

    defer original.deinit();

    try std.testing.expect(original.value == .parsed);

    const input = original.value.parsed;
    const issue = try lint.source.check(allocator, .{ .source = input.source, .comments = input.lexed.comments, .program = input.ast });

    if (std.mem.eql(u8, source, expected)) try std.testing.expect(issue == null) else {
        const diagnostic = issue orelse return error.MissingDiagnostic;

        try std.testing.expectEqual(.spacing, diagnostic.code);
        try std.testing.expectEqualStrings("import order or blank lines do not match built-in rules; run zxc fmt", diagnostic.message);
        try std.testing.expect(diagnostic.span.start < diagnostic.span.end);
        try std.testing.expect(diagnostic.span.end <= source.len);
    }

    var parsed = try compiler.parse(allocator, formatted.source, "imports.zx");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .parsed);

    const output = parsed.value.parsed;

    try std.testing.expect((try lint.source.check(allocator, .{ .source = output.source, .comments = output.lexed.comments, .program = output.ast })) == null);

    const repeated = try compiler.format(allocator, formatted.source, "imports.zx");

    defer repeated.deinit(allocator);

    try std.testing.expect(repeated == .source);
    try std.testing.expectEqualStrings(expected, repeated.source);
}
