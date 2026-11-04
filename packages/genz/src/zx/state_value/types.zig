const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

/// The value layouts of a file that declares its own types; files importing the shared bundle build them on use.
pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    self.abi_types = self.types;
    self.abi_layouts = self.layouts;
    self.state_types = try self.allocator.dupe(node.ExpressionId, self.types);
    self.state_layouts = try self.allocator.dupe(node.ExpressionId, self.layouts);
    self.view_types = try self.allocator.dupe(node.ExpressionId, self.types);

    if (@import("genz_options").generated_analysis) return @import("../types/state.zig").build(self, output, exported);

    var declared: std.StringHashMapUnmanaged(void) = .empty;

    for (0..self.program.types.count()) |index| {
        const value = self.program.types.at(index);

        if (value == .optional) {
            self.state_types[index] = try self.builder.expression(.{ .optional_type = self.state_types[@backingInt(value.optional)] });
            self.state_layouts[index] = self.state_types[index];
            self.view_types[index] = if (self.view_types[@backingInt(value.optional)] == self.state_types[@backingInt(value.optional)]) self.state_types[index] else try self.builder.expression(.{ .optional_type = self.view_types[@backingInt(value.optional)] });

            continue;
        }

        if (!self.state_plan.selected[index]) continue;

        const id: ir.TypeId = @fromBackingInt(@intCast(index));
        const base = if (self.type_names) |names| names[index] else try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});
        const name = try self.state_plan.name(self.allocator, id, base);

        const selected = blk: {
            const definition = switch (value) {
                .list => |child| try @import("list.zig").definition(self, child),
                .object => |fields| object: {
                    const items = try self.allocator.alloc(node.Field, fields.len + 1);

                    for (0..fields.len, items[0..fields.len]) |view_index, *item| {
                        const field = fields.at(view_index);

                        item.* = .{ .name = field.name, .value = self.state_types[@backingInt(field.type_id)] };
                    }

                    items[fields.len] = .{
                        .name = try @import("origin.zig").name(self, id),
                        .value = try self.builder.expression(.{ .optional_type = self.abi_types[index] }),
                        .default_value = try self.builder.expression(.null_value),
                    };

                    break :object try self.builder.expression(.{ .struct_type = items });
                },
                .tuple => |children| tuple: {
                    const items = try self.allocator.alloc(node.ExpressionId, children.len + 1);

                    for (0..children.len, items[0..children.len]) |item_index, *item| {
                        const child = children.at(item_index);
                        item.* = self.state_types[@backingInt(child)];
                    }

                    items[children.len] = try self.builder.expression(.{ .optional_type = self.abi_types[index] });

                    break :tuple try self.builder.expression(.{ .tuple_type = items });
                },
                else => unreachable,
            };

            if (!(try declared.getOrPut(self.allocator, name)).found_existing) try output.append(self.allocator, .{ .constant = .{ .name = name, .value = definition, .exported = exported } });

            break :blk try self.builder.identifier(name);
        };

        self.state_types[index] = selected;
        self.state_layouts[index] = selected;

        if (value == .list and @import("elements.zig").inlineStored(self, id)) {
            self.view_types[index] = try self.builder.expression(.{ .const_slice = self.abi_layouts[@backingInt(value.list)] });
        }

        if (value == .object or value == .tuple) {
            const changed = switch (value) {
                .object => |fields| changed: {
                    for (0..fields.len) |field_index| {
                        const child = @backingInt(fields.at(field_index).type_id);

                        if (self.view_types[child] != self.state_types[child]) break :changed true;
                    }

                    break :changed false;
                },
                .tuple => |children| changed: {
                    for (0..children.len) |child_index| {
                        const child = @backingInt(children.at(child_index));

                        if (self.view_types[child] != self.state_types[child]) break :changed true;
                    }

                    break :changed false;
                },
                else => unreachable,
            };

            const definition = if (!changed) selected else switch (value) {
                .object => |fields| object: {
                    const items = try self.allocator.alloc(node.Field, fields.len + 1);

                    for (items[0..fields.len], 0..) |*item, field_index| {
                        const field = fields.at(field_index);

                        item.* = .{ .name = field.name, .value = self.view_types[@backingInt(field.type_id)] };
                    }

                    items[fields.len] = .{ .name = try @import("origin.zig").name(self, id), .value = try self.builder.expression(.{ .optional_type = self.abi_types[index] }), .default_value = try self.builder.expression(.null_value) };

                    break :object try self.builder.expression(.{ .struct_type = items });
                },
                .tuple => |children| tuple: {
                    const items = try self.allocator.alloc(node.ExpressionId, children.len + 1);

                    for (items[0..children.len], 0..) |*item, child_index| item.* = self.view_types[@backingInt(children.at(child_index))];

                    items[children.len] = try self.builder.expression(.{ .optional_type = self.abi_types[index] });

                    break :tuple try self.builder.expression(.{ .tuple_type = items });
                },
                else => unreachable,
            };

            const view_name = try std.fmt.allocPrint(self.allocator, "view_{s}", .{name});

            if (!(try declared.getOrPut(self.allocator, view_name)).found_existing) try output.append(self.allocator, .{ .constant = .{ .name = view_name, .value = definition, .exported = exported } });

            self.view_types[index] = if (changed) try self.builder.identifier(view_name) else selected;
        }
    }
}
