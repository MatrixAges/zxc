const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    var declared: std.StringHashMapUnmanaged(void) = .empty;
    var has_lists = false;

    if (self.shared_types) try output.append(self.allocator, .{ .constant = .{
        .name = "zx_abi",
        .value = try self.builtin(.import, &.{try self.builder.string("zxc_abi")}),
    } });

    for (0..self.program.types.count()) |index| {
        const value = self.program.types.at(index);

        if (value == .list) has_lists = true;

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

                        for (0..children.len, 0..) |view_index, child_index| {
                            const child = children.at(view_index);
                            items[child_index] = self.types[@backingInt(child)];
                        }

                        break :tuple try self.builder.expression(.{ .tuple_type = items });
                    },
                    .object => |fields| object: {
                        const items = try self.allocator.alloc(node.Field, fields.len);

                        for (0..fields.len, 0..) |item_index, field_index| {
                            const item = fields.at(item_index);

                            items[field_index] = .{ .name = item.name, .value = self.types[@backingInt(item.type_id)] };
                        }

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
    if (has_lists and !self.shared_types) try output.append(self.allocator, try @import("buffer_call/slot.zig").declaration(self, exported));
}
