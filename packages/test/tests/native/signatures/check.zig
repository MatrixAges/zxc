const std = @import("std");
const compiler = @import("compiler");
const cases = @import("scenario.zig");

pub fn run(allocator: std.mem.Allocator, scenario: cases.Scenario) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const source = try cases.create(arena.allocator(), scenario);

    try analyze(allocator, source, scenario);
}

pub fn analyze(allocator: std.mem.Allocator, source: cases.Source, scenario: cases.Scenario) !void {
    var result = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = source.main }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:host", .path = "host.d.zx", .source = source.declaration, .module = "host" }},
    });

    defer result.deinit();

    if (scenario.invalid) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.name, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expect(std.mem.startsWith(u8, result.value.diagnostic.message, "host.d.zx:"));
        try std.testing.expect(std.mem.endsWith(u8, result.value.diagnostic.message, "unknown or unsupported type"));

        return;
    }

    if (result.value == .diagnostic) std.debug.print("unexpected signature diagnostic: {s}\n", .{result.value.diagnostic.message});
    try std.testing.expect(result.value == .ir);
    try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);

    const program = result.value.ir;
    const seen = try allocator.alloc(bool, scenario.functions);

    defer allocator.free(seen);
    @memset(seen, false);

    for (0..program.functions.count()) |row| {
        const function = program.functions.at(row);
        const external = function.external orelse continue;
        const member = external.member[external.member.len - 1];
        const index = try std.fmt.parseInt(usize, member[4..], 10);

        try std.testing.expect(index < seen.len and !seen[index]);

        seen[index] = true;

        const expected: []const ?[]const u8 = switch (index % 4) {
            0, 1 => &.{null},
            2 => &.{ source.alias, null, "Leaf", null, null, "Leaf", null },
            else => &.{ null, null, source.alias, null, "Leaf", null, null, "Leaf", null },
        };

        const actual = external.input.?.names;

        try std.testing.expectEqual(expected.len, actual.len);

        for (expected, actual) |name, value| {
            if (name) |text| try std.testing.expectEqualStrings(text, value.?) else try std.testing.expect(value == null);
        }

        try std.testing.expectEqual(index % 4 == 3, external.expand_tuple);
        try std.testing.expectEqual(.u64, program.typeOf(function.output_type).scalar);

        switch (index % 4) {
            0 => try std.testing.expectEqual(.void, program.typeOf(function.input_type).scalar),
            1 => try std.testing.expectEqual(.u64, program.typeOf(function.input_type).scalar),
            2 => try std.testing.expectEqual(@as(usize, 2), program.typeOf(function.input_type).object.len),
            else => try std.testing.expectEqual(@as(usize, 2), program.typeOf(function.input_type).tuple.len),
        }
    }

    for (seen) |value| try std.testing.expect(value);

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);
}
