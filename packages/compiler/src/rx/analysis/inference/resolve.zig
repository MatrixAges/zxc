const zx = @import("zx");
const Graph = @import("types.zig");
const Scalar = @import("scalar.zig");
const Types = @import("frontend").types;

pub fn resolve(self: *Graph, value: Graph.Id, depth: usize) zx.Error!zx.ir.TypeId {
    const index = @backingInt(self.root(value));
    const node = self.nodes.items[index];

    if (depth >= 256) return self.reporter.fail(.unsupported, node.span, "type inference nesting exceeds 256 levels");

    const id = switch (node.shape) {
        .known => |id| id,
        .sequence => return self.reporter.fail(.contract, node.span, "sequence constraints must be finalized before type resolution"),
        .unknown => if (node.fallback) |scalar| block: {
            const numeric_default = Scalar.default(node.allowed, scalar) orelse
                return self.reporter.fail(.type_mismatch, node.span, "numeric constraints do not determine an accepted default type");

            break :block Types.scalarId(numeric_default);
        } else return self.reporter.fail(.type_mismatch, node.span, "input type cannot be inferred from the available constraints"),
        .object => |fields| block: {
            const output = try Types.Fields.init(self.allocator, fields.len);

            for (fields, 0..) |field, field_index| output.set(field_index, field.name, try resolve(self, field.value, depth + 1));

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

    if (node.shape != .known) {
        self.nodes.items[index].shape = .{ .known = id };
        self.object_revision += 1;
    }

    return id;
}
