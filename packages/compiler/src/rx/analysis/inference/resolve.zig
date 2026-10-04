const zx = @import("zx");
const Graph = @import("types.zig");
const Types = @import("frontend").types;

pub fn resolve(self: *Graph, value: Graph.Id, depth: usize) zx.Error!zx.ir.TypeId {
    const index = @intFromEnum(self.root(value));
    const node = self.nodes.items[index];

    if (depth >= 256) return self.reporter.fail(.unsupported, node.span, "type inference nesting exceeds 256 levels");

    const id = switch (node.shape) {
        .known => |id| id,
        .unknown => if (node.fallback) |scalar| block: {
            var numeric_default = scalar;

            if (node.allowed) |mask| {
                if (!mask.contains(numeric_default)) {
                    const preferred = [_]zx.ir.Scalar{ .i64, .f64, .i32, .f32, .u64, .u32, .u16, .u8 };
                    var found = false;

                    for (preferred) |candidate| {
                        if (!mask.contains(candidate)) continue;

                        numeric_default = candidate;
                        found = true;

                        break;
                    }

                    if (!found) return self.reporter.fail(.type_mismatch, node.span, "numeric constraints do not determine an accepted default type");
                }
            }

            break :block Types.scalarId(numeric_default);
        } else return self.reporter.fail(.type_mismatch, node.span, "input type cannot be inferred from the available constraints"),
        .object => |fields| block: {
            const output = try self.allocator.alloc(zx.ir.TypeField, fields.len);

            for (fields, output) |field, *item| item.* = .{ .name = field.name, .type_id = try resolve(self, field.value, depth + 1) };

            break :block try self.types.object(output);
        },
        .list => |child| try self.types.wrap(.list, try resolve(self, child, depth + 1)),
        .optional => |child| try self.types.wrap(.optional, try resolve(self, child, depth + 1)),
        .tuple => |children| block: {
            const output = try self.allocator.alloc(zx.ir.TypeId, children.len);

            for (children, output) |child, *item| item.* = try resolve(self, child, depth + 1);

            break :block try self.types.tuple(output);
        },
    };

    self.nodes.items[index].shape = .{ .known = id };

    return id;
}
