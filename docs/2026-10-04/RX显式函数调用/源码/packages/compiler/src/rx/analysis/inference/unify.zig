const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");

pub fn merge(self: *Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, depth: usize) zx.Error!void {
    if (depth >= 256) return self.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");

    const a = self.root(left);
    const b = self.root(right);

    if (a == b) return;
    if (try contains(self, a, b, span, 0) or try contains(self, b, a, span, 0)) return self.reporter.fail(.type_mismatch, span, "inference would require a recursive input type");

    const first = self.nodes.items[@intFromEnum(a)];
    const second = self.nodes.items[@intFromEnum(b)];
    const shape = try combine(self, first.shape, second.shape, span, depth);
    const allowed = if (first.allowed) |value| if (second.allowed) |other| value.intersectWith(other) else value else second.allowed;

    self.nodes.items[@intFromEnum(a)].shape = shape;
    self.nodes.items[@intFromEnum(a)].fallback = fallback(first.fallback, second.fallback);
    self.nodes.items[@intFromEnum(b)].parent = a;

    self.revision += 1;

    if (allowed) |mask| try self.restrict(a, mask, span);
}

fn combine(self: *Graph, left: Graph.Shape, right: Graph.Shape, span: zx.Span, depth: usize) zx.Error!Graph.Shape {
    if (left == .unknown) return right;
    if (right == .unknown) return left;

    if (left == .known) {
        try matchKnown(self, left.known, right, span, depth);

        return left;
    }

    if (right == .known) {
        try matchKnown(self, right.known, left, span, depth);

        return right;
    }

    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return self.reporter.fail(.type_mismatch, span, "incompatible inferred input shapes");

    switch (left) {
        .list, .optional => |child| try merge(self, child, if (right == .list) right.list else right.optional, span, depth + 1),
        .tuple => |children| {
            if (children.len != right.tuple.len) return self.reporter.fail(.type_mismatch, span, "incompatible inferred tuple lengths");
            for (children, right.tuple) |a, b| try merge(self, a, b, span, depth + 1);
        },
        .object => |fields| {
            var merged: std.ArrayList(Graph.Field) = .empty;

            try merged.appendSlice(self.allocator, fields);

            for (right.object) |field| {
                var found = false;

                for (fields) |existing| {
                    if (!std.mem.eql(u8, existing.name, field.name)) continue;
                    try merge(self, existing.value, field.value, span, depth + 1);

                    found = true;

                    break;
                }

                if (!found) try merged.append(self.allocator, field);
            }

            return .{ .object = merged.items };
        },
        else => unreachable,
    }

    return left;
}

fn matchKnown(self: *Graph, id: zx.ir.TypeId, shape: Graph.Shape, span: zx.Span, depth: usize) zx.Error!void {
    if (shape == .known) {
        if (id != shape.known) return self.reporter.fail(.type_mismatch, span, "input uses require different concrete types");

        return;
    }

    const concrete = self.types.get(id);

    switch (shape) {
        .object => |fields| {
            if (concrete != .object) return self.reporter.fail(.type_mismatch, span, "input object requirements conflict with its complete type");

            for (fields) |field| {
                var found = false;

                for (concrete.object) |existing| {
                    if (!std.mem.eql(u8, existing.name, field.name)) continue;
                    try merge(self, field.value, try self.known(existing.type_id, span), span, depth + 1);

                    found = true;

                    break;
                }

                if (!found) return self.reporter.fail(.type_mismatch, span, "the complete input type does not contain a required field");
            }
        },
        .list, .optional => |child| {
            if ((shape == .list and concrete != .list) or (shape == .optional and concrete != .optional)) return self.reporter.fail(.type_mismatch, span, "input container requirements conflict with its complete type");

            try merge(self, child, try self.known(if (concrete == .list) concrete.list else concrete.optional, span), span, depth + 1);
        },
        .tuple => |children| {
            if (concrete != .tuple or concrete.tuple.len != children.len) return self.reporter.fail(.type_mismatch, span, "input tuple requirements conflict with its complete type");
            for (children, concrete.tuple) |child, known| try merge(self, child, try self.known(known, span), span, depth + 1);
        },
        else => unreachable,
    }
}

fn contains(self: *const Graph, parent: Graph.Id, child: Graph.Id, span: zx.Span, depth: usize) zx.Error!bool {
    if (depth >= 256) return self.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");
    if (self.root(parent) == self.root(child)) return true;

    switch (self.shape(parent)) {
        .list, .optional => |nested| return contains(self, nested, child, span, depth + 1),
        .tuple => |items| for (items) |item| {
            if (try contains(self, item, child, span, depth + 1)) return true;
        },
        .object => |fields| for (fields) |field| {
            if (try contains(self, field.value, child, span, depth + 1)) return true;
        },
        else => {},
    }

    return false;
}

fn fallback(left: ?zx.ir.Scalar, right: ?zx.ir.Scalar) ?zx.ir.Scalar {
    if (left == null) return right;
    if (right == null) return left;
    if (left.? == .f64 or right.? == .f64) return .f64;
    if (left.? == .i64 or right.? == .i64) return .i64;

    return left;
}
