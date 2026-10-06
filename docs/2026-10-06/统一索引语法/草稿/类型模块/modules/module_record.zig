const std = @import("std");
const zx = @import("zx");

pub const Target = union(enum) { source: []const u8, compiled: @import("compiled.zig").Target, native, external };

pub const Import = struct {
    kind: @FieldType(zx.ast.Import, "kind"),
    specifier: []const u8,
    identity: ?[]const u8 = null,
    names: []const []const u8,
    span: zx.Span,
    target: Target,
};

path: []const u8,
source_digest: [32]u8,
type_range: struct { start: usize, end: usize },
exports: []const zx.ir.Export,
imports: []const Import,
type_imports: []const zx.ir.Export,
function_imports: []const @import("function_import.zig"),
body: union(enum) { types, entry, function: zx.ir.FunctionId },
pub fn copyImport(allocator: std.mem.Allocator, item: anytype, target: Target) std.mem.Allocator.Error!Import {
    const names = try allocator.alloc([]const u8, item.nameCount());

    for (names, 0..) |*owned, index| owned.* = try allocator.dupe(u8, item.nameAt(index).text);

    return .{
        .kind = item.kind,
        .specifier = try allocator.dupe(u8, item.path),
        .names = names,
        .span = item.span,
        .target = switch (target) {
            .source => |path| .{ .source = try allocator.dupe(u8, path) },
            .compiled => |value| .{ .compiled = try @import("compiled.zig").copyTarget(allocator, value) },
            .native, .external => target,
        },
    };
}
