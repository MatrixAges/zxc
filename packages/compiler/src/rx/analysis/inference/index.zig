const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub fn infer(self: *Expression, source: *const zx.ast.Expression) zx.Error!Graph.Id {
    const item = source.value.index;
    const span = self.sourceSpan(source.span);
    const target = try self.infer(item.target, null);

    _ = try self.infer(item.index, try self.graph.scalar(.u64, span));

    const shape = self.graph.shape(target);

    if (shape == .tuple) {
        const index = try tupleIndex(self, item.index, shape.tuple.len);

        return shape.tuple[index];
    }

    if (shape == .known) {
        const known = self.graph.types.get(shape.known);

        if (known == .tuple) {
            const index = try tupleIndex(self, item.index, known.tuple.len);

            return self.graph.known(known.tuple[index], span);
        }
    }

    return self.graph.payload(target, .list, span);
}

fn tupleIndex(self: *Expression, source: *const zx.ast.Expression, length: usize) zx.Error!usize {
    const span = self.sourceSpan(source.span);

    if (source.value != .number) return self.graph.reporter.fail(.type_mismatch, span, "tuple indexing requires an integer literal");

    var clean: std.ArrayList(u8) = .empty;

    defer clean.deinit(self.graph.allocator);

    for (source.value.number) |byte| if (byte != '_') try clean.append(self.graph.allocator, byte);

    const index = std.fmt.parseInt(u64, clean.items, 10) catch return self.graph.reporter.fail(.type_mismatch, span, "tuple indexing requires an integer literal");

    if (index >= length) return self.graph.reporter.fail(.type_mismatch, span, "tuple index is out of bounds");

    return @intCast(index);
}
