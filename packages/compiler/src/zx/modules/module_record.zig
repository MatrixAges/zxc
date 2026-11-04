const std = @import("std");
const zx = @import("zx");

pub const Target = union(enum) { source: []const u8, compiled: @import("compiled.zig").Target, native, external, intrinsic };
pub const Reexports = struct { types: []const zx.ir.Export = &.{}, constants: []const zx.ir.Constant = &.{}, functions: []const @import("function_import.zig") = &.{} };

pub const Import = struct {
    kind: @FieldType(zx.ast.Import, "kind"),
    specifier: []const u8,
    identity: ?[]const u8 = null,
    names: []const []const u8,
    source_names: []const []const u8 = &.{},
    exported: bool = false,
    wildcard: bool = false,
    span: zx.Span,
    target: Target,
};

path: []const u8,
source_digest: [32]u8,
type_range: struct { start: usize, end: usize },
exports: []const zx.ir.Export,
constant_exports: []const zx.ir.Constant = &.{},
reexports: Reexports = .{},
constant_imports: []const zx.ir.Constant = &.{},
imports: []const Import,
type_imports: []const zx.ir.Export,
function_imports: []const @import("function_import.zig"),
body: union(enum) { types, entry, function: zx.ir.FunctionId },
own_function: ?zx.ir.FunctionId = null,
pub fn copyImport(allocator: std.mem.Allocator, item: anytype, target: Target) std.mem.Allocator.Error!Import {
    const names = try allocator.alloc([]const u8, item.nameCount());

    for (names, 0..) |*owned, index| owned.* = try allocator.dupe(u8, item.nameAt(index).text);

    var source_names: ?[][]const u8 = null;

    for (names, 0..) |name, index| {
        const original = item.sourceAt(index).text;

        if (source_names == null and !std.mem.eql(u8, name, original)) {
            source_names = try allocator.alloc([]const u8, names.len);

            @memcpy(source_names.?[0..index], names[0..index]);
        }

        if (source_names) |sources| sources[index] = try allocator.dupe(u8, original);
    }

    return .{
        .kind = item.kind,
        .exported = item.exported,
        .wildcard = item.wildcard,
        .source_names = source_names orelse &.{},
        .specifier = try allocator.dupe(u8, item.path),
        .names = names,
        .span = item.span,
        .target = switch (target) {
            .source => |path| .{ .source = try allocator.dupe(u8, path) },
            .compiled => |value| .{ .compiled = try @import("compiled.zig").copyTarget(allocator, value) },
            .native, .external, .intrinsic => target,
        },
    };
}
