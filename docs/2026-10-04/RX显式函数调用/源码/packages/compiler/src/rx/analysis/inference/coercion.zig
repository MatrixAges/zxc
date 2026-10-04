const zx = @import("zx");
const Graph = @import("types.zig");

pub fn accepts(self: *const Graph, actual: zx.ir.TypeId, expected: zx.ir.TypeId) bool {
    var current = expected;

    while (true) {
        if (actual == current) return true;

        const value = self.types.get(current);

        if (value != .optional) return false;

        current = value.optional;
    }
}

pub fn apply(self: *Graph, actual: Graph.Id, expected: zx.ir.TypeId, span: zx.Span) zx.Error!void {
    var current = expected;

    while (!fits(self, actual, current, 0)) {
        const value = self.types.get(current);

        if (value != .optional) return self.reporter.fail(.type_mismatch, span, "inferred value cannot be passed to the required optional type");

        current = value.optional;
    }

    try self.unify(actual, try self.known(current, span), span);
}

fn fits(self: *const Graph, actual: Graph.Id, expected: zx.ir.TypeId, depth: usize) bool {
    if (depth >= 256) return false;

    const node = self.nodes.items[@intFromEnum(self.root(actual))];
    const value = self.types.get(expected);

    if (node.allowed) |mask| {
        if (value != .scalar or !mask.contains(value.scalar)) return false;
    }

    return switch (node.shape) {
        .unknown => true,
        .known => |id| id == expected,
        .list => |child| value == .list and fits(self, child, value.list, depth + 1),
        .optional => |child| value == .optional and fits(self, child, value.optional, depth + 1),
        .tuple => |children| block: {
            if (value != .tuple or children.len != value.tuple.len) break :block false;

            for (children, value.tuple) |child, id| {
                if (!fits(self, child, id, depth + 1)) break :block false;
            }

            break :block true;
        },
        .object => |fields| block: {
            if (value != .object) break :block false;

            for (fields) |field| {
                var found = false;

                for (value.object) |item| {
                    if (!@import("std").mem.eql(u8, item.name, field.name)) continue;
                    if (!fits(self, field.value, item.type_id, depth + 1)) break :block false;

                    found = true;

                    break;
                }

                if (!found) break :block false;
            }

            break :block true;
        },
    };
}
