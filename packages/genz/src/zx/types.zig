const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

/// A type expression not built yet: a file that imports the shared type bundle builds each one when first used.
const unset: node.ExpressionId = @fromBackingInt(std.math.maxInt(u32));

pub fn lower(self: *Lower, output: *std.ArrayList(node.Declaration), exported: bool) Lower.Error!void {
    if (self.shared_types) return shared(self, output);

    var declared: std.StringHashMapUnmanaged(void) = .empty;
    var has_lists = false;

    for (0..self.program.types.count()) |index| {
        const value = self.program.types.at(index);

        if (value == .list) has_lists = true;

        self.types[index] = switch (value) {
            .object, .tuple, .enumeration, .native_reference => blk: {
                const name = try typeName(self, index);

                const definition = switch (value) {
                    .native_reference => try self.builder.expression(.opaque_type),
                    .enumeration => |enumeration| try self.builder.expression(.{ .enum_type = enumeration.members }),
                    .tuple => |children| tuple: {
                        const items = try self.allocator.alloc(node.ExpressionId, children.len);

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
            else => try plain(self, value, self.types),
        };

        if (value != .object and value != .tuple and value != .native_reference) self.layouts[index] = self.types[index];
    }

    try @import("state_value/types.zig").lower(self, output, exported);
    if (has_lists) try output.appendSlice(self.allocator, &try @import("growth.zig").declarations(self, exported));
}

/// The expression `table` holds for `id`, built first when the file imports the shared type bundle.
pub fn get(self: *Lower, table: []const node.ExpressionId, id: ir.TypeId) Lower.Error!node.ExpressionId {
    const index = @backingInt(id);

    if (table[index] == unset) {
        if (table.ptr == self.state_types.ptr or table.ptr == self.state_layouts.ptr) try state(self, index) else try abi(self, index);
    }

    return table[index];
}

/// A file that imports the shared type bundle declares only the import; a function uses few of the program's types.
fn shared(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    try output.append(self.allocator, .{ .constant = .{
        .name = "zx_abi",
        .value = try self.builtin(.import, &.{try self.builder.string("zxc_abi")}),
    } });

    self.abi_types = self.types;
    self.abi_layouts = self.layouts;
    self.state_types = try self.allocator.alloc(node.ExpressionId, self.types.len);
    self.state_layouts = try self.allocator.alloc(node.ExpressionId, self.types.len);

    for ([_][]node.ExpressionId{ self.abi_types, self.abi_layouts, self.state_types, self.state_layouts }) |table| @memset(table, unset);
}

fn abi(self: *Lower, index: usize) Lower.Error!void {
    const value = self.program.types.at(index);

    switch (value) {
        .object, .tuple, .enumeration, .native_reference => {
            const layout = try self.field(try self.builder.identifier("zx_abi"), try typeName(self, index));

            self.abi_layouts[index] = layout;
            self.abi_types[index] = if (value == .enumeration) layout else try self.builder.expression(.{ .const_pointer = layout });
        },
        else => {
            const expression = try plain(self, value, self.abi_types);

            self.abi_types[index] = expression;
            self.abi_layouts[index] = expression;
        },
    }
}

/// The value layout of a type the state plan selected; other types keep their ABI expressions, and optionals wrap
/// their child's state expression.
fn state(self: *Lower, index: usize) Lower.Error!void {
    const value = self.program.types.at(index);
    const id: ir.TypeId = @fromBackingInt(@intCast(index));

    if (value == .optional) {
        const optional = try self.builder.expression(.{ .optional_type = try get(self, self.state_types, value.optional) });

        self.state_types[index] = optional;
        self.state_layouts[index] = optional;

        return;
    }

    if (!self.state_plan.selected[index]) {
        self.state_types[index] = try get(self, self.abi_types, id);
        self.state_layouts[index] = try get(self, self.abi_layouts, id);

        return;
    }

    const selected = try self.field(try self.builder.identifier("zx_abi"), try self.state_plan.name(self.allocator, id, try typeName(self, index)));

    self.state_types[index] = selected;
    self.state_layouts[index] = selected;
}

/// Scalars, error sets, tasks, optionals and lists, over the child expressions `table` holds.
fn plain(self: *Lower, value: ir.Type, table: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    return switch (value) {
        .scalar => |scalar| switch (scalar) {
            .string => try self.builder.expression(.{ .const_slice = try self.builder.expression(.{ .primitive = .u8 }) }),
            else => try self.builder.expression(.{ .primitive = std.meta.stringToEnum(@FieldType(node.Expression, "primitive"), @tagName(scalar)).? }),
        },
        .error_set => |members| try self.builder.expression(.{ .error_set = members }),
        .task => |task| try self.call(try @import("intrinsics.zig").standardField(self, &.{ "Io", "Future" }), &.{try self.builder.expression(.{ .error_union = .{ .errors = self.program.typeOf(task.errors).error_set, .payload = try get(self, table, task.result) } })}, false),
        .optional => |child| try self.builder.expression(.{ .optional_type = try get(self, table, child) }),
        .list => |child| try self.builder.expression(.{ .const_slice = try get(self, table, child) }),
        .object, .tuple, .enumeration, .native_reference => unreachable,
    };
}

fn typeName(self: *Lower, index: usize) Lower.Error![]const u8 {
    return if (self.type_names) |names| names[index] else try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{index});
}
