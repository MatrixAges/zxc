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
/// Source targets borrow the normalized unit path held by the project arena.
pub fn copyImport(allocator: std.mem.Allocator, item: anytype, target: Target) std.mem.Allocator.Error!Import {
    const names = try @import("module_record/names/host.zig").own(allocator, item);

    return .{
        .kind = item.kind,
        .exported = item.exported,
        .wildcard = item.wildcard,
        .source_names = names.originals,
        .specifier = try allocator.dupe(u8, item.path),
        .names = names.locals,
        .span = item.span,
        .target = switch (target) {
            .compiled => |value| .{ .compiled = try @import("compiled.zig").copyTarget(allocator, value) },
            else => target,
        },
    };
}
