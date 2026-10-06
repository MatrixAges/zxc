const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    self.abi_types = self.types;
    self.abi_layouts = self.layouts;
    self.state_types = try self.allocator.dupe(*const node.Expression, self.types);
    self.state_layouts = try self.allocator.dupe(*const node.Expression, self.layouts);

    var declared: std.StringHashMapUnmanaged(void) = .empty;

    for (self.program.types, 0..) |value, index| {
        if (value == .optional) {
            self.state_types[index] = try self.builder.expression(.{ .optional_type = self.state_types[@backingInt(value.optional)] });
            self.state_layouts[index] = self.state_types[index];

            continue;
        }

        if (!self.state_plan.selected[index]) continue;

        const id: ir.TypeId = @fromBackingInt(@intCast(index));
        const base = if (self.type_names) |names| names[index] else try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});
        const name = try self.state_plan.name(self.allocator, id, base);

        const selected = if (self.shared_types) try self.field(try self.builder.identifier("zx_abi"), name) else blk: {
            const definition = switch (value) {
                .object => |fields| object: {
                    const items = try self.allocator.alloc(node.Field, fields.len + 1);

                    for (fields, items[0..fields.len]) |field, *item| item.* = .{ .name = field.name, .value = self.state_types[@backingInt(field.type_id)] };

                    items[fields.len] = .{
                        .name = try @import("origin.zig").name(self, id),
                        .value = try self.builder.expression(.{ .optional_type = self.abi_types[index] }),
                        .default_value = try self.builder.expression(.null_value),
                    };

                    break :object try self.builder.expression(.{ .struct_type = items });
                },
                .tuple => |children| tuple: {
                    const items = try self.allocator.alloc(*const node.Expression, children.len + 1);

                    for (children, items[0..children.len]) |child, *item| item.* = self.state_types[@backingInt(child)];

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
    }
}
