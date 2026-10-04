const std = @import("std");
const zx = @import("zx");

pub const Target = union(enum) { source: []const u8, native, external };

pub const Import = struct {
    kind: @FieldType(zx.ast.Import, "kind"),
    specifier: []const u8,
    names: []const []const u8,
    span: zx.Span,
    target: Target,
};

path: []const u8,
source_digest: [32]u8,
exports: []const zx.ir.Export,
imports: []const Import,
body: union(enum) { types, entry, function: zx.ir.FunctionId },
pub fn copyImport(allocator: std.mem.Allocator, item: zx.ast.Import, target: Target) std.mem.Allocator.Error!Import {
    const names = try allocator.alloc([]const u8, item.names.len);

    for (item.names, names) |name, *owned| owned.* = try allocator.dupe(u8, name.text);

    return .{
        .kind = item.kind,
        .specifier = try allocator.dupe(u8, item.path),
        .names = names,
        .span = item.span,
        .target = switch (target) {
            .source => |path| .{ .source = try allocator.dupe(u8, path) },
            .native, .external => target,
        },
    };
}
