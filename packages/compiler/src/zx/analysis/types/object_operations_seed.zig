const std = @import("std");
const zx = @import("zx");
const Types = @import("../types.zig");
const node = @import("resolve_seed.zig").node;
const literal = @import("../../frontend/string_literal.zig");

pub fn resolve(types: *Types, view: anytype, value: @TypeOf(view).Ref) zx.Error!zx.ir.TypeId {
    const name = view.name(value);
    const left_id = try node(types, view, view.child(value));

    if (view.kind(value) == .selection) {
        return select(types, view, value, left_id, name);
    }

    const right_id = try node(types, view, view.right(value));
    const left = try object(types, left_id, name.span);
    const right = try object(types, right_id, name.span);
    const result = try Types.Fields.init(types.allocator, left.len + right.len);
    var lhs: usize = 0;
    var rhs: usize = 0;
    var count: usize = 0;

    while (lhs < left.len or rhs < right.len) : (count += 1) {
        const order: std.math.Order = if (lhs == left.len)
            .gt

        else if (rhs == right.len)
            .lt
        else
            std.mem.order(u8, left.names[lhs], right.names[rhs]);

        if (order == .eq and left.types[lhs] != right.types[rhs]) {
            return types.reporter.fail(.type_mismatch, name.span, "intersection has incompatible types for a shared field");
        }

        if (order != .gt) {
            result.set(count, left.names[lhs], @fromBackingInt(left.types[lhs]));

            lhs += 1;
        } else {
            result.set(count, right.names[rhs], @fromBackingInt(right.types[rhs]));
        }

        if (order != .lt) rhs += 1;
    }

    return types.object(result.prefix(count));
}

fn select(types: *Types, view: anytype, value: @TypeOf(view).Ref, id: zx.ir.TypeId, name: zx.ast.Name) zx.Error!zx.ir.TypeId {
    const omit = std.mem.eql(u8, name.text, "Omit");

    if (!omit and !std.mem.eql(u8, name.text, "Pick")) return types.reporter.fail(.name, name.span, "expected the type method Pick or Omit");

    const fields = try object(types, id, name.span);
    var scratch = std.heap.ArenaAllocator.init(types.scratch orelse types.allocator);

    defer scratch.deinit();

    const selected = try scratch.allocator().alloc(bool, fields.len);

    @memset(selected, false);

    var keys = view.keys(value).iterator();
    var count: usize = 0;

    while (keys.next()) |key| {
        const index = for (fields.names, 0..) |field, index| {
            if (literal.equal(key.text, field)) break index;
        } else return types.reporter.fail(.name, name.span, "unknown field in type selection");

        if (selected[index]) return types.reporter.fail(.name, name.span, "duplicate field in type selection");

        selected[index] = true;
        count += 1;
    }

    const size = if (omit) fields.len - count else count;

    if (size == fields.len) return id;

    const result = try Types.Fields.init(types.allocator, size);
    var position: usize = 0;

    for (fields.names, fields.types, selected) |field, child, used| {
        if (used == omit) continue;

        result.set(position, field, @fromBackingInt(child));

        position += 1;
    }

    return types.object(result);
}

fn object(types: *Types, id: zx.ir.TypeId, span: zx.Span) zx.Error!zx.ir.TypeFields {
    const selected = types.get(id);

    if (selected != .object) return types.reporter.fail(.type_mismatch, span, "type operation requires an object type");

    return selected.object;
}
