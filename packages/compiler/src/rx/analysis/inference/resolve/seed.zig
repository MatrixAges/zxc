const zx = @import("zx");
const Graph = @import("../types.zig");
const Scalar = @import("../scalar.zig");
const Types = @import("frontend").types;

pub fn resolve(self: *Graph, value: Graph.Id, depth: usize) zx.Error!zx.ir.TypeId {
    const index = @backingInt(self.root(value));
    const node = self.nodeAt(index);

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
            const output = try self.scratch.alloc(u32, fields.len);

            defer self.scratch.free(output);

            for (fields.values(), output) |field, *type_id| type_id.* = @backingInt(try resolve(self, field, depth + 1));

            break :block try self.types.objectWithNames(fields.names(), output);
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
        self.setShape(index, .{ .known = id });

        self.object_revision += 1;
    }

    return id;
}
