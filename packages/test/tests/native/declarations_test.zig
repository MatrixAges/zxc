const std = @import("std");
const allocation_testing = @import("allocation_testing");
const compiler = @import("compiler");
const main = "import native from \"zig:sample\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return native.apply(in)\n}\n";
const valid = "export declare function apply(allocator, input: u64): u64 throws\n";
const Code = @FieldType(compiler.Diagnostic, "code");

fn analyze(allocator: std.mem.Allocator, declaration: []const u8, expected: ?Code) !void {
    var result = try compiler.project.analyze(allocator, &.{.{ .path = "main.zx", .source = main }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = declaration, .module = "sample" }},
    });

    defer result.deinit();

    if (expected) |code| {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(code, result.value.diagnostic.code);
        try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
        try std.testing.expect(std.mem.startsWith(u8, result.value.diagnostic.message, "sample.d.zx:"));
    } else {
        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(allocator, result.value.ir) == null);
        try std.testing.expectEqual(@as(usize, 1), result.value.ir.functions.len);

        const external = result.value.ir.functions[0].external.?;

        try std.testing.expect(external.allocator_argument);
        try std.testing.expect(external.fallible);
        try std.testing.expect(!external.expand_tuple);
        try std.testing.expectEqualStrings("apply", external.member[0]);
    }
}

test "native declaration diagnostics retain source and reject malformed contracts" {
    const cases = [_]struct { source: []const u8, code: Code }{
        .{ .source = "", .code = .contract },
        .{ .source = "export declare function BadName(input: u64): u64\n", .code = .naming },
        .{ .source = "export declare function apply(badName: u64): u64\n", .code = .naming },
        .{ .source = "export declare function apply(input: u64, input: u64): u64\n", .code = .name },
        .{ .source = "export declare function apply(input: u64): u64\n export declare function apply(input: u64): u64\n", .code = .name },
        .{ .source = "export declare function apply(input: u64): u64\n export type Later = u64\n", .code = .contract },
        .{ .source = "export type bad_name = u64\n", .code = .naming },
        .{ .source = "export declare function apply(input: void): u64\n", .code = .type_mismatch },
        .{ .source = "export declare function apply(input: Missing): u64\n", .code = .name },
        .{ .source = "export declare function apply(input: u64): Missing\n", .code = .name },
        .{ .source = "export declare function apply(input: u64): u64;", .code = .syntax },
        .{ .source = "export declare function apply(allocator input: u64): u64\n", .code = .syntax },
    };

    for (cases) |case| try analyze(std.testing.allocator, case.source, case.code);
}

test "native declaration success releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, analyze, .{ valid, @as(?Code, null) });
}

test "native declaration diagnostic releases every failed allocation" {
    const source = "export type Item = { value: u64 }\n export declare function apply(input: Item[]): Missing\n";

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, analyze, .{ source, @as(?Code, .name) });
}

test "native declaration arity and namespace retain invocation attributes" {
    const cases = [_]struct { declaration: []const u8, call: []const u8, allocating: bool, fallible: bool, expanded: bool }{
        .{ .declaration = "export declare function apply(): u64\n", .call = "native.apply()", .allocating = false, .fallible = false, .expanded = false },
        .{ .declaration = "export declare function apply(allocator): u64 throws\n", .call = "native.apply()", .allocating = true, .fallible = true, .expanded = false },
        .{ .declaration = "export declare function apply(left: u64, right: u64): u64\n", .call = "native.apply(in, in)", .allocating = false, .fallible = false, .expanded = true },
        .{ .declaration = "export declare function apply(allocator, left: u64, right: u64): u64 throws\n", .call = "native.apply(in, in)", .allocating = true, .fallible = true, .expanded = true },
    };

    for (cases) |case| {
        const source = try std.mem.replaceOwned(u8, std.testing.allocator, main, "native.apply(in)", case.call);

        defer std.testing.allocator.free(source);

        var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{
            .entry = "main.zx",
            .root_dir = "/project",
            .native_interfaces = &.{.{ .specifier = "zig:sample", .path = "sample.d.zx", .source = case.declaration, .module = "sample", .namespace = &.{ "nested", "api" } }},
        });

        defer result.deinit();

        try std.testing.expect(result.value == .ir);
        try std.testing.expect(try compiler.validateIr(std.testing.allocator, result.value.ir) == null);

        const external = result.value.ir.functions[0].external.?;

        try std.testing.expectEqual(case.allocating, external.allocator_argument);
        try std.testing.expectEqual(case.fallible, external.fallible);
        try std.testing.expectEqual(case.expanded, external.expand_tuple);
        try std.testing.expectEqual(@as(usize, 3), external.member.len);
        try std.testing.expectEqualStrings("nested", external.member[0]);
        try std.testing.expectEqualStrings("api", external.member[1]);
        try std.testing.expectEqualStrings("apply", external.member[2]);
    }
}
