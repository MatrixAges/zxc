const std = @import("std");
const ir = @import("zx").ir;
const represented = @import("../iteration_layout.zig").represented;

/// The pure `functions` that compare no represented aggregates by identity, themselves or through their callees; a
/// fact of the whole program, computed once. A function may only rely on functions before it, so every body is
/// checked on its own on all cores, keeping the functions it calls, and a pass in order then joins the callees.
pub fn functions(allocator: std.mem.Allocator, program: ir.Program, pure: []const bool) std.mem.Allocator.Error![]bool {
    const Checking = struct {
        program: ir.Program,
        pure: []const bool,
        local: []bool,
        callees: [][]const u32,
        arenas: []std.heap.ArenaAllocator,
        next: std.atomic.Value(usize) = .init(0),
        failed: std.atomic.Value(bool) = .init(false),
        fn run(work: *@This(), participant: usize) void {
            const arena = work.arenas[participant].allocator();
            var found: std.ArrayList(u32) = .empty;

            while (!work.failed.load(.monotonic)) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.local.len) return;

                work.callees[index] = &.{};
                work.local[index] = false;

                if (!work.pure[index]) continue;

                const function = work.program.functions.at(index);

                found.clearRetainingCapacity();

                work.local[index] = body(arena, work.program, function.expressions, function.contracts, index, &found) catch return work.failed.store(true, .monotonic);
                work.callees[index] = arena.dupe(u32, found.items) catch return work.failed.store(true, .monotonic);
            }
        }
    };

    const count = program.functions.count();
    const arenas = try allocator.alloc(std.heap.ArenaAllocator, @import("zx").parallel.width());

    defer allocator.free(arenas);

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    const safe = try allocator.alloc(bool, count);
    var work = Checking{ .program = program, .pure = pure, .local = safe, .callees = try allocator.alloc([]const u32, count), .arenas = arenas };

    defer allocator.free(work.callees);

    @import("zx").parallel.spread(Checking, &work, Checking.run, @min(arenas.len, count));

    if (work.failed.load(.monotonic)) return error.OutOfMemory;

    for (safe, work.callees) |*value, called| {
        if (value.*) value.* = for (called) |callee| {
            if (!safe[callee]) break false;
        } else true;
    }

    return safe;
}

/// Whether a body compares no represented aggregates by identity, keeping the functions it calls in `callees`; false
/// once it calls a function from `limit` on, which has not been decided before it.
fn body(allocator: std.mem.Allocator, program: ir.Program, expressions: ir.ExpressionTable, contracts: ir.ContractTable, limit: usize, callees: *std.ArrayList(u32)) std.mem.Allocator.Error!bool {
    for (0..expressions.count()) |index| switch (expressions.at(index).value) {
        .call => |call| {
            const callee = @backingInt(call.function);

            if (callee >= limit) return false;
            try callees.append(allocator, @intCast(callee));
        },
        .binary => |binary| {
            if (binary.operator != .equal and binary.operator != .not_equal) continue;

            const left = expressions.at(@backingInt(binary.left));
            const right = expressions.at(@backingInt(binary.right));

            if (left.value != .none and right.value != .none and (represented(program, left.type_id) or represented(program, right.type_id))) return false;
        },
        else => {},
    };

    for (contracts.expressions) |table| if (!try body(allocator, program, table.*, .{}, limit, callees)) return false;

    return true;
}
