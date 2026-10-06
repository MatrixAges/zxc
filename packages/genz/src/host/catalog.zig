const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub const Module = struct {
    specifier: []const u8,
    path: []const u8,
    source: []const u8,
    module: []const u8,
    namespace: []const []const u8,
    implementation_path: []const u8,
};

pub fn render(allocator: std.mem.Allocator, modules: []const Module) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const string = try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) });
    var fields: std.ArrayList(node.Field) = .empty;
    var values: std.ArrayList(*const node.Expression) = .empty;

    inline for (.{ "specifier", "path", "source", "module", "namespace", "implementation_path" }) |name| {
        try fields.append(builder.allocator, .{ .name = name, .value = if (comptime std.mem.eql(u8, name, "namespace")) try builder.expression(.{ .const_slice = string }) else string });
    }

    for (modules) |module| {
        var namespace: std.ArrayList(*const node.Expression) = .empty;

        for (module.namespace) |part| try namespace.append(builder.allocator, try builder.string(part));

        try values.append(builder.allocator, try builder.object(&.{
            .{ .name = "specifier", .value = try builder.string(module.specifier) },
            .{ .name = "path", .value = try builder.string(module.path) },
            .{ .name = "source", .value = try builder.builtin(.embedFile, &.{try builder.string(module.source)}) },
            .{ .name = "module", .value = try builder.string(module.module) },
            .{ .name = "namespace", .value = try builder.expression(.{ .address_of = try builder.tuple(namespace.items) }) },
            .{ .name = "implementation_path", .value = try builder.string(module.implementation_path) },
        }));
    }

    return @import("../render.zig").render(allocator, &.{
        .{ .constant = .{ .name = "Source", .value = try builder.expression(.{ .struct_type = try fields.toOwnedSlice(builder.allocator) }), .exported = true } },
        .{ .constant = .{ .name = "modules", .type_expr = try builder.expression(.{ .const_slice = try builder.identifier("Source") }), .value = try builder.expression(.{ .address_of = try builder.tuple(values.items) }), .exported = true } },
    });
}
