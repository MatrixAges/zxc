const zx = @import("zx");
const Graph = @import("types.zig");
const Plan = @import("unification/plan.zig");
const Fields = @import("unification/fields.zig");

pub fn merge(self: *Graph, left: Graph.Id, right: Graph.Id, span: zx.Span, depth: usize) zx.Error!void {
    if (depth >= 256) return self.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");

    const a = self.root(left);
    const b = self.root(right);

    if (a == b) return;
    if (try contains(self, a, b, span, 0) or try contains(self, b, a, span, 0)) return self.reporter.fail(.type_mismatch, span, "inference would require a recursive input type");

    const first = self.nodes.items[@backingInt(a)];
    const second = self.nodes.items[@backingInt(b)];
    const shape = try combine(self, first.shape, second.shape, span, depth);
    const allowed = if (first.allowed) |value| if (second.allowed) |other| value.intersectWith(other) else value else second.allowed;

    self.nodes.items[@backingInt(a)].shape = shape;
    self.nodes.items[@backingInt(a)].fallback = fallback(first.fallback, second.fallback);
    self.nodes.items[@backingInt(b)].parent = a;

    self.revision += 1;
    self.object_revision += 1;

    if (allowed) |mask| try self.restrict(a, mask, span);
}

fn combine(self: *Graph, left: Graph.Shape, right: Graph.Shape, span: zx.Span, depth: usize) zx.Error!Graph.Shape {
    const concrete: ?zx.ir.Type = if (left == .known and right != .unknown and right != .known)
        self.types.get(left.known)

    else if (right == .known and left != .unknown and left != .known)
        self.types.get(right.known)
    else
        null;

    switch (Plan.choose(left, right, concrete)) {
        .Left => return left,
        .Right => return right,
        .Known => {
            const declared = if (left == .known) left else right;
            const inferred = if (left == .known) right else left;

            try applyKnown(self, inferred, concrete, span, depth);

            return declared;
        },
        .Child => {
            const a = if (left == .list) left.list else left.optional;
            const b = if (right == .list) right.list else right.optional;

            try merge(self, a, b, span, depth + 1);
        },
        .Tuple => for (left.tuple, right.tuple) |a, b| {
            try merge(self, a, b, span, depth + 1);
        },
        .Object => return .{ .object = try Fields.combine(self, left.object, right.object, span, depth + 1) },
        else => |issue| return self.reporter.fail(.type_mismatch, span, message(issue)),
    }

    return left;
}

fn applyKnown(self: *Graph, shape: Graph.Shape, concrete: ?zx.ir.Type, span: zx.Span, depth: usize) zx.Error!void {
    switch (shape) {
        .known, .sequence => {},
        .object => |fields| try Fields.applyKnown(self, fields, concrete.?.object, span, depth + 1),
        .list, .optional => |child| {
            const value = concrete.?;
            const type_id = if (shape == .list) value.list else value.optional;

            try merge(self, child, try self.known(type_id, span), span, depth + 1);
        },
        .tuple => |children| {
            const tuple = concrete.?.tuple;

            for (children, 0..) |child, index| {
                try merge(self, child, try self.known(tuple.at(index), span), span, depth + 1);
            }
        },
        .unknown => unreachable,
    }
}

fn message(route: Plan.Route) []const u8 {
    return switch (route) {
        .SequenceMismatch => "a sequence requires a list or tuple type",
        .ShapeMismatch => "incompatible inferred input shapes",
        .TupleMismatch => "incompatible inferred tuple lengths",
        .ConcreteMismatch => "input uses require different concrete types",
        .ConcreteObjectMismatch => "input object requirements conflict with its complete type",
        .ConcreteContainerMismatch => "input container requirements conflict with its complete type",
        .ConcreteTupleMismatch => "input tuple requirements conflict with its complete type",
        else => unreachable,
    };
}

fn contains(self: *const Graph, parent: Graph.Id, child: Graph.Id, span: zx.Span, depth: usize) zx.Error!bool {
    if (depth >= 256) return self.reporter.fail(.unsupported, span, "type inference nesting exceeds 256 levels");

    const root = self.root(parent);

    if (root == child) return true;

    switch (self.nodes.items[@backingInt(root)].shape) {
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
