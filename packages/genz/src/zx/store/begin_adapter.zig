const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const begin = @import("begin.zig");

pub fn declaration(self: *Lower, mapping: []const u32) Lower.Error!node.Declaration {
    const selected = try self.builder.identifier("selected");
    const slot = try self.builder.expression(.{ .dereference = try self.builder.identifier("slot") });

    const mapped = try self.builder.expression(.{ .block = .{
        .label = "mapped_slots",
        .statements = try self.allocator.dupe(node.Statement, &.{
            .{ .variable = .{ .name = "selected", .value = try self.builder.identifier("slots") } },
            .{ .for_loop = .{
                .iterable = try self.builder.expression(.{ .address_of = selected }),
                .capture = "slot",
                .capture_reference = true,
                .body = try self.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = slot, .value = try self.builder.expression(.{ .index = .{ .target = try begin.array(self, mapping), .index = slot } }) } }}),
            } },
            .{ .break_value = .{ .label = "mapped_slots", .value = selected } },
        }),
    } });

    const parent = try self.field(try self.builder.identifier("self"), "parent");

    const parameters = try self.allocator.dupe(node.Field, &.{
        .{ .name = "self", .value = try self.builtin(.This, &.{}) },
        .{ .name = "slots", .value = try self.builder.expression(.{ .primitive = .@"anytype" }), .comptime_parameter = true },
    });

    return .{ .function = .{
        .name = "begin",
        .parameters = parameters,
        .return_type = try self.builder.expression(.{ .error_union = try self.builder.expression(.{ .primitive = .void }) }),
        .body = try self.allocator.dupe(node.Statement, &.{try begin.invoke(self, parent, try self.builder.expression(.{ .comptime_value = mapped }))}),
        .exported = true,
    } };
}
