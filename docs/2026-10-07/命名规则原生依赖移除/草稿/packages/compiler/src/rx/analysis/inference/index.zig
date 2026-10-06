const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub const Projection = struct { target: Graph.Id, value: Graph.Id, position: ?u64, span: zx.Span, index_span: zx.Span, resolved: bool = false };

pub fn infer(self: *Expression, source: anytype) zx.Error!Graph.Id {
    const item = syntax.value(source).index;
    const span = self.sourceSpan(source.span);
    const target = try self.infer(item.target, null);

    _ = try self.infer(item.index, try self.graph.scalar(.u64, span));

    const value = try self.graph.add(.unknown, span);
    const projection = Projection{ .target = target, .value = value, .position = try literalIndex(self, item.index), .span = span, .index_span = self.sourceSpan(item.index.span) };

    _ = try propagate(self.graph, projection);

    const shape = self.graph.shape(target);

    if (shape == .unknown or shape == .sequence) try self.graph.indexes.append(self.graph.allocator, projection);

    return value;
}

pub fn propagate(graph: *Graph, projection: Projection) zx.Error!bool {
    const shape = graph.shape(projection.target);

    const value = switch (shape) {
        .unknown, .sequence => return false,
        .list => |child| child,
        .tuple => |children| children[try tupleIndex(graph, projection, children.len)],
        .known => |id| value: {
            const known = graph.types.get(id);

            break :value switch (known) {
                .scalar => |scalar| if (scalar == .string) try graph.scalar(.u8, projection.span) else return graph.reporter.fail(.type_mismatch, projection.span, "indexing requires a list, tuple or string"),
                .list => |child| try graph.known(child, projection.span),
                .tuple => |children| try graph.known(children.at(try tupleIndex(graph, projection, children.len)), projection.span),
                else => return graph.reporter.fail(.type_mismatch, projection.span, "indexing requires a list, tuple or string"),
            };
        },
        else => return graph.reporter.fail(.type_mismatch, projection.span, "indexing requires a list, tuple or string"),
    };

    try graph.unify(value, projection.value, projection.span);

    return true;
}

pub fn isResult(graph: *const Graph, id: Graph.Id) bool {
    for (graph.indexes.items) |projection| {
        if (!projection.resolved and graph.root(projection.value) == graph.root(id)) return true;
    }

    return false;
}

pub fn defaultLists(graph: *Graph) zx.Error!bool {
    for (graph.indexes.items) |projection| {
        if (graph.shape(projection.target) != .unknown) continue;

        const value = try graph.payload(projection.target, .list, projection.span);

        try graph.unify(value, projection.value, projection.span);

        return true;
    }

    return false;
}

fn literalIndex(self: *Expression, source: anytype) zx.Error!?u64 {
    if (syntax.value(source) != .number) return null;

    var clean: std.ArrayList(u8) = .empty;

    defer clean.deinit(self.graph.allocator);

    for (syntax.value(source).number) |byte| if (byte != '_') try clean.append(self.graph.allocator, byte);

    return std.fmt.parseInt(u64, clean.items, 10) catch null;
}

fn tupleIndex(graph: *Graph, projection: Projection, length: usize) zx.Error!usize {
    const index = projection.position orelse return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple indexing requires an integer literal");

    if (index >= length) return graph.reporter.fail(.type_mismatch, projection.index_span, "tuple index is out of bounds");

    return @intCast(index);
}
