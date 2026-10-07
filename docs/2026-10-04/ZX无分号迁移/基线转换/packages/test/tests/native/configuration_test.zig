const std = @import("std");
const compiler = @import("compiler");
const source = "import native from \"zig:sample\"\n\nexport type Input = u64\n\nexport type Output = u64\n\nexport default function (in: Input): Output {\n  return native.apply(in)\n}\n";
const entry: compiler.project.NativeInterface = .{ .specifier = "zig:sample", .path = "sample.d.zx", .source = "export declare function apply(input: u64): u64\n", .module = "sample" };

fn reject(interfaces: []const compiler.project.NativeInterface, externals: []const compiler.project.External, message: []const u8) !void {
    var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = interfaces,
        .externals = externals,
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.module, result.value.diagnostic.code);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
    try std.testing.expect(std.mem.indexOf(u8, result.value.diagnostic.message, message) != null);
}

test "native interface registrations reject ambiguity" {
    try reject(&.{ entry, entry }, &.{}, "duplicate native interface module");

    try reject(&.{entry}, &.{.{
        .specifier = "zig:sample",
        .export_name = "apply",
        .signature = "export type Input = u64\n export type Output = u64\n",
        .implementation = .{ .module = "sample", .member = "apply" },
    }}, "native declarations conflict with legacy external signatures");
}

test "native module and namespace names reject invalid strings" {
    for ([_][]const u8{ "", "bad\x00name", "bad\xffname" }) |name| {
        var invalid_module = entry;

        invalid_module.module = name;

        try reject(&.{invalid_module}, &.{}, "native import names must be nonempty UTF-8 strings");

        var invalid_namespace = entry;

        invalid_namespace.namespace = &.{name};

        try reject(&.{invalid_namespace}, &.{}, "native namespaces require nonempty UTF-8 member names");
    }
}

test "native namespace imports require callable declarations" {
    var types_only = entry;
    types_only.source = "export type Value = u64\n";

    try reject(&.{types_only}, &.{}, "native namespaces require one binding and callable exports");
}

test "native calls reject missing members before linking" {
    const missing = try std.mem.replaceOwned(u8, std.testing.allocator, source, "native.apply(in)", "native.missing(in)");

    defer std.testing.allocator.free(missing);

    var result = try compiler.project.analyze(std.testing.allocator, &.{.{ .path = "main.zx", .source = missing }}, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = &.{entry},
    });

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(.name, result.value.diagnostic.code);
    try std.testing.expectEqualStrings("unknown module member", result.value.diagnostic.message);
    try std.testing.expectEqual(@as(?usize, 0), result.value.diagnostic.source_index);
}
