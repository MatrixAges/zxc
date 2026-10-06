const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
pub const Alias = struct { name: []const u8, identity: []const u8 };

pub fn render(allocator: std.mem.Allocator, type_names: []const []const u8, aliases: []const Alias, imported: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();
    const builder = Builder{ .allocator = temporary };
    var declarations: std.ArrayList(node.Declaration) = .empty;
    const canonical = try builder.identifier("canonical");

    if (imported) {
        try declarations.append(temporary, .{ .constant = .{ .name = "canonical", .value = try builder.expression(.{ .builtin = .{ .name = .import, .arguments = try temporary.dupe(*const node.Expression, &.{try builder.string("zxc_abi_canonical")}) } }) } });
        for (type_names) |name| try declarations.append(temporary, .{ .constant = .{ .name = name, .value = try builder.expression(.{ .field = .{ .target = canonical, .name = name } }), .exported = true } });
    }

    for ([_][]const u8{ "native", "layouts" }) |namespace| {
        const name = try std.fmt.allocPrint(temporary, "{s}_by_identity", .{namespace});
        const target = if (imported) try builder.expression(.{ .field = .{ .target = canonical, .name = name } }) else try builder.identifier(name);
        const members = try temporary.alloc(node.Declaration, aliases.len);

        for (aliases, members) |alias, *member| member.* = .{ .constant = .{ .name = alias.name, .value = try builder.expression(.{ .field = .{ .target = target, .name = alias.identity } }), .exported = true } };
        try declarations.append(temporary, .{ .constant = .{ .name = namespace, .value = try builder.expression(.{ .namespace_type = members }), .exported = true } });
    }

    return @import("../render.zig").render(allocator, declarations.items);
}
