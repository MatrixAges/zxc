const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const modules = @import("modules.zig");

pub fn append(lower: *Lower, names: modules.Names, members: []const modules.PublicMember) modules.Error!@import("../node/stored.zig").Declarations {
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for (members) |member| {
        const module = try lower.builder.builtin(.import, &.{try lower.builder.string(names.functions[@backingInt(member.function)])});

        try declarations.append(lower.allocator, .{ .constant = .{
            .exported = true,
            .name = member.name,
            .value = try lower.builder.field(module, "call"),
        } });
    }

    return lower.builder.nodes.declarations(lower.allocator, declarations.items);
}
