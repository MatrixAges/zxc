const std = @import("std");
const node = @import("genz").node;
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    if (self.shared_types) try output.append(self.allocator, .{ .constant = .{
        .name = "zx_abi",
        .value = try self.builtin(.import, &.{try self.builder.string("zxc_abi")}),
    } });

    for (self.program.types, 0..) |value, index| {
        self.types[index] = switch (value) {
            .scalar => |scalar| switch (scalar) {
                .string => try self.builder.expression(.{ .const_slice = try self.builder.expression(.{ .primitive = .u8 }) }),
                else => try self.builder.expression(.{ .primitive = std.meta.stringToEnum(@FieldType(node.Expression, "primitive"), @tagName(scalar)).? }),
            },
            .optional => |child| try self.builder.expression(.{ .optional_type = self.types[@intFromEnum(child)] }),
            .list => |child| try self.builder.expression(.{ .const_slice = self.types[@intFromEnum(child)] }),
            .object, .tuple, .enumeration => blk: {
                const name = try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});

                if (self.shared_types) {
                    self.layouts[index] = try self.field(try self.builder.identifier("zx_abi"), name);

                    break :blk if (value == .enumeration) self.layouts[index] else try self.builder.expression(.{ .const_pointer = self.layouts[index] });
                }

                const definition = switch (value) {
                    .enumeration => |enumeration| try self.builder.expression(.{ .enum_type = enumeration.members }),
                    .tuple => |children| tuple: {
                        const items = try self.allocator.alloc(*const node.Expression, children.len);

                        for (children, 0..) |child, child_index| items[child_index] = self.types[@intFromEnum(child)];

                        break :tuple try self.builder.expression(.{ .tuple_type = items });
                    },
                    .object => |fields| object: {
                        const items = try self.allocator.alloc(node.Field, fields.len);

                        for (fields, 0..) |item, field_index| items[field_index] = .{ .name = item.name, .value = self.types[@intFromEnum(item.type_id)] };

                        break :object try self.builder.expression(.{ .struct_type = items });
                    },
                    else => unreachable,
                };

                try output.append(self.allocator, .{ .constant = .{ .name = name, .value = definition, .exported = exported } });

                self.layouts[index] = try self.builder.identifier(name);

                break :blk if (value == .enumeration) self.layouts[index] else try self.builder.expression(.{ .const_pointer = self.layouts[index] });
            },
        };

        if (value != .object and value != .tuple) self.layouts[index] = self.types[index];
    }
}
