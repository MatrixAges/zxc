const std = @import("std");
const ir = @import("zx").ir;
const Function = @import("../function.zig");
const Sites = @import("../sites.zig");

/// The initial seed's equivalent of analysis/uniqueness/function/transfer; generated builds use that Source plan.
pub fn build(function: *Function, allocator: std.mem.Allocator, flags: []const Function.Flags) std.mem.Allocator.Error![]const u64 {
    const selected = try allocator.alloc(bool, flags.len);

    defer allocator.free(selected);

    for (flags, selected) |value, *target| target.* = value.normalize or value.renew;

    for (function.operations) |id| {
        const expression = &function.rows[@backingInt(id)];

        const target = switch (expression.value) {
            .call => |call| call.argument,
            .list_update => |update| update.target,
            .transform => |transform| transform.target,
            .list_operation => |operation| operation.target,
            else => unreachable,
        };

        if (expression.value == .call) {
            const output = function.slots.types.get(function.slots.unwrap(expression.type_id));
            const scalar = output == .scalar or output == .enumeration or output == .error_set;

            if (scalar and !flags[@backingInt(target)].renew) continue;
        }

        selected[@backingInt(target)] = true;
    }

    for (function.order.repeated) |id| switch (function.rows[@backingInt(id)].value) {
        .iteration => |iteration| {
            selected[@backingInt(iteration.initial)] = true;
            selected[@backingInt(iteration.body)] = true;
        },
        else => {},
    };

    for (function.order.results) |id| selected[@backingInt(id)] = true;

    const first = function.sites.slot_first[function.sites.symbols.count()..];
    const count: usize = first[first.len - 1] - first[0];
    const width = @bitSizeOf(u64);
    const required_words = (count + width - 1) / width;
    var words: usize = 1;

    while (words < required_words) words *= 2;

    const transfers = try allocator.alloc(u64, words);

    @memset(transfers, 0);

    for (selected, 0..) |needed, index| {
        if (!needed) continue;

        for (0..first[index + 1] - first[index]) |slot| {
            if (!qualify(function, @fromBackingInt(@as(u32, @intCast(index))), @intCast(slot))) continue;

            const bit = first[index] - first[0] + slot;
            transfers[bit / width] |= @as(u64, 1) << @intCast(bit % width);
        }
    }

    return transfers;
}

fn qualify(function: *Function, id: ir.ExprId, slot: u32) bool {
    const expression = &function.rows[@backingInt(id)];

    switch (expression.value) {
        .field, .tuple_field => |projection| {
            const target = &function.rows[@backingInt(projection.target)];
            const member = function.slots.member(target.type_id, projection.index);

            return qualify(function, projection.target, member.offset + slot);
        },
        .reference => |symbol| {
            const definition = function.order.definition(symbol);

            switch (definition) {
                .condition, .element, .unknown => return false,
                else => {},
            }

            if (function.order.crossesConcurrent(function.order.loopAt(@backingInt(id)), function.order.defLoopAt(@backingInt(symbol)))) return false;
            if (!function.sites.linear(Sites.symbolRoot(symbol), slot)) return false;

            return switch (definition) {
                .value => |value| qualify(function, value, slot),
                .part => |part| qualify(function, part.value, function.slots.member(function.rows[@backingInt(part.value)].type_id, part.index).offset + slot),
                else => true,
            };
        },
        else => {},
    }

    if (!function.sites.linear(function.sites.nodeRoot(id), slot)) return false;

    return switch (expression.value) {
        .object => |object_value| object: {
            for (0..object_value.fields.len) |index| {
                const field = object_value.fields.at(index);
                const member = function.slots.member(expression.type_id, field.index);

                if (slot >= member.offset and slot - member.offset < function.slots.count(member.type_id)) break :object qualify(function, field.value, slot - member.offset);
            }

            break :object false;
        },
        .tuple => |items| tuple: {
            for (items, 0..) |item, index| {
                const member = function.slots.member(expression.type_id, @intCast(index));

                if (slot >= member.offset and slot - member.offset < function.slots.count(member.type_id)) break :tuple qualify(function, item, slot - member.offset);
            }

            break :tuple false;
        },
        .scope => |scope| qualify(function, scope.result, slot),
        .optional_value, .some => |child| qualify(function, child, slot),
        .conditional => |choice| qualify(function, choice.yes, slot) and qualify(function, choice.no, slot),
        .match_expr => |choice| selection: {
            if (!qualify(function, choice.fallback, slot)) break :selection false;
            for (0..choice.arms.len) |index| if (!qualify(function, choice.arms.at(index).result, slot)) break :selection false;

            break :selection true;
        },
        .binary => |binary| binary.operator == .coalesce and qualify(function, binary.left, slot) and qualify(function, binary.right, slot),
        .capture, .task, .await_task, .parallel => false,
        else => true,
    };
}
