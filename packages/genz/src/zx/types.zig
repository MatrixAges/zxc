const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    var declared: std.StringHashMapUnmanaged(void) = .empty;

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
            .error_set => |members| try self.builder.expression(.{ .error_set = members }),
            .task => |task| try self.call(try @import("intrinsics.zig").standardField(self, &.{ "Io", "Future" }), &.{try self.builder.expression(.{ .error_union = .{ .errors = self.program.typeOf(task.errors).error_set, .payload = self.types[@backingInt(task.result)] } })}, false),
            .optional => |child| try self.builder.expression(.{ .optional_type = self.types[@backingInt(child)] }),
            .list => |child| try self.builder.expression(.{ .const_slice = self.types[@backingInt(child)] }),
            .object, .tuple, .enumeration, .native_reference => blk: {
                const name = if (self.type_names) |names| names[index] else try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});

                if (self.shared_types) {
                    self.layouts[index] = try self.field(try self.builder.identifier("zx_abi"), name);

                    break :blk if (value == .enumeration) self.layouts[index] else try self.builder.expression(.{ .const_pointer = self.layouts[index] });
                }

                const definition = switch (value) {
                    .native_reference => try self.builder.expression(.opaque_type),
                    .enumeration => |enumeration| try self.builder.expression(.{ .enum_type = enumeration.members }),
                    .tuple => |children| tuple: {
                        const items = try self.allocator.alloc(*const node.Expression, children.len);

                        for (children, 0..) |child, child_index| items[child_index] = self.types[@backingInt(child)];

                        break :tuple try self.builder.expression(.{ .tuple_type = items });
                    },
                    .object => |fields| object: {
                        const items = try self.allocator.alloc(node.Field, fields.len);

                        for (fields, 0..) |item, field_index| items[field_index] = .{ .name = item.name, .value = self.types[@backingInt(item.type_id)] };

                        break :object try self.builder.expression(.{ .struct_type = items });
                    },
                    else => unreachable,
                };

                const entry = try declared.getOrPut(self.allocator, name);

                if (!entry.found_existing) try output.append(self.allocator, .{ .constant = .{ .name = name, .value = definition, .exported = exported } });

                self.layouts[index] = try self.builder.identifier(name);

                break :blk if (value == .enumeration) self.layouts[index] else try self.builder.expression(.{ .const_pointer = self.layouts[index] });
            },
        };

        if (value != .object and value != .tuple and value != .native_reference) self.layouts[index] = self.types[index];
    }

    try @import("state_value/types.zig").lower(self, output, exported);
}
