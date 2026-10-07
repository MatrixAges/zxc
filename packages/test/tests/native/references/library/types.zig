const std = @import("std");
const f = @import("fixture.zig");
const compiler = f.compiler;

pub fn library(allocator: std.mem.Allocator) !compiler.library.Result {
    var analyzed = try compiler.analyzeProject(allocator, &.{.{ .path = "types.zx", .source = "import type { Node } from \"zig:host\"\n\nexport type SharedNode = Node\n" }}, .{
        .entry = "types.zx",
        .root_dir = "/types",
        .native_interfaces = &.{.{ .specifier = "zig:host", .module = "host", .path = "host.d.zx", .source = "export type Node = opaque\n" }},
    });

    defer analyzed.deinit();

    try std.testing.expect(analyzed.value == .ir);
    try std.testing.expect(analyzed.value.ir.type_only);
    try std.testing.expect(try compiler.validateIr(allocator, analyzed.value.ir) == null);

    return compiler.library.link(allocator, &.{.{ .name = "types", .analysis = &analyzed }});
}

pub fn inspect(value: *const compiler.library.Result) !void {
    const program = value.program;

    try std.testing.expectEqual(@as(usize, 0), program.functions.count());
    try std.testing.expectEqual(@as(usize, 1), program.native_modules.count());
    try std.testing.expectEqual(@as(usize, 1), value.nominal_types.count());
    try std.testing.expectEqual(@as(usize, 1), value.exports.len);

    const nominal = value.nominal_types.at(0);
    const module = program.native_modules.at(0);

    try std.testing.expect(program.typeOf(nominal.type_id) == .native_reference);
    try std.testing.expectEqualStrings("Node", program.typeOf(nominal.type_id).native_reference);
    try std.testing.expectEqualStrings("Node", nominal.name);
    try std.testing.expect(nominal.origin == .native);
    try std.testing.expectEqualStrings(module.key(), nominal.origin.native);
    try std.testing.expectEqualStrings(module.key(), compiler.ir.nativeReferenceOwner(program, nominal.type_id).?);
    try std.testing.expectEqualStrings("types", value.exports[0].name);
    try std.testing.expect(value.exports[0].function == null);
    try std.testing.expectEqual(@as(usize, 1), value.exports[0].types.len);
    try std.testing.expectEqualStrings("SharedNode", value.exports[0].types[0].name);
    try std.testing.expectEqual(nominal.type_id, value.exports[0].types[0].type_id);
}
