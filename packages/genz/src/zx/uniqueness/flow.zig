const std = @import("std");
const ir = @import("zx").ir;
const Order = @import("order.zig");
const Slots = @import("slots.zig");
const Memo = @import("memo.zig");
const Self = @This();
const generated_analysis = @import("genz_options").generated_analysis;
const Seed = @import("flow/seed.zig");
const Body = if (generated_analysis) @import("flow/body.zig") else Seed.Body;
const Walk = if (generated_analysis) @import("flow/walk.zig") else Seed.Walk;

/// Which input slots of each function its output may hold and its updates may write in place, closed over the call
/// graph. A value is followed back from where it ends up to the input slots it can come from: through projections,
/// aggregates, bindings, loop state and the inputs of callees that hold them. What an output holds includes the lists
/// stored as elements of its lists; what an update writes is one buffer, and elements are never written in place. A
/// value whose origin the walk cannot follow counts as every input slot.
held: []const []const bool,
text_held: []const []const bool,
written: []const []const bool,
/// `memo` keeps the summaries of each body by its `contents` and its callees' summaries, so a later program walks only
/// the bodies whose content or callees changed.
pub fn create(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, slots: Slots, texts: []const bool, contents: []const [32]u8, types: [32]u8, memo: ?*Memo) std.mem.Allocator.Error!Self {
    const count = program.functions.count();
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const self = try @import("flow/initial.zig").create(allocator, program, slots, texts);

    if (try @import("flow/layers/root.zig").build(temporary, program.functions)) |found| {
        const remembered: ?Remembered = if (memo) |value| .{
            .memo = value,
            .types = types,
            .contents = contents,
            .keys = try temporary.alloc(Memo.Digest, count),
            .found = try temporary.alloc(bool, count),
        } else null;

        try self.layered(program, slots, found, remembered);
    } else try self.settle(temporary, workspace, program, slots);

    return self;
}

const Layers = @import("flow/layers/root.zig").Plan;

/// What looking bodies up in a memo needs: the digests of the types and of each body, and per body its key and whether
/// the memo held it.
const Remembered = struct {
    memo: *Memo,
    types: [32]u8,
    contents: []const [32]u8,
    keys: []Memo.Digest,
    found: []bool,
    /// The key of a body: its content within the types, and the summaries of each function it calls.
    fn key(self: Remembered, flow: Self, function: ir.Function, index: usize) Memo.Digest {
        var hash = @import("zx").Sha256.init(.{});
        var result: Memo.Digest = undefined;

        hash.update("zxc.uniqueness.flow.v5");
        hash.update(&self.types);
        hash.update(&self.contents[index]);

        for (function.expressions.kinds, 0..) |_, expression| {
            const callee = @backingInt(function.expressions.callee(expression) orelse continue);

            hash.update(std.mem.asBytes(&@as(u32, @intCast(flow.held[callee].len))));
            hash.update(std.mem.sliceAsBytes(flow.held[callee]));
            hash.update(std.mem.asBytes(&@as(u32, @intCast(flow.text_held[callee].len))));
            hash.update(std.mem.sliceAsBytes(flow.text_held[callee]));
            hash.update(std.mem.sliceAsBytes(flow.written[callee]));
        }

        hash.final(&result);

        return result;
    }
};

fn layered(self: Self, program: ir.Program, slots: Slots, found: Layers, remembered: ?Remembered) std.mem.Allocator.Error!void {
    const width = @import("zx").parallel.width();
    const walkers = try std.heap.page_allocator.alloc(Walker, width);

    defer std.heap.page_allocator.free(walkers);

    for (walkers) |*walker| walker.* = .{ .bodies = .init(std.heap.page_allocator), .lasting = .init(std.heap.page_allocator) };

    defer for (walkers) |*walker| {
        if (walker.walk) |*walk| walk.deinit();

        walker.bodies.deinit();
        walker.lasting.deinit();
    };

    var start: usize = 0;

    for (found.ends) |boundary| {
        const end: usize = @intCast(boundary);
        var layer = Layer{ .flow = self, .program = program, .slots = slots, .functions = found.order[start..end], .walkers = walkers, .remembered = remembered };

        start = end;

        @import("zx").parallel.spread(Layer, &layer, Layer.run, @min(width, layer.functions.len));

        if (layer.failed.load(.monotonic)) return error.OutOfMemory;

        const kept = remembered orelse continue;

        for (layer.functions) |index| {
            if (program.functions.at(index).external != null) continue;
            if (kept.found[index]) kept.memo.keepFlowed(kept.keys[index]) else try kept.memo.putFlowed(kept.keys[index], self.held[index], self.text_held[index], self.written[index]);
        }
    }
}

const Walker = struct { bodies: std.heap.ArenaAllocator, lasting: std.heap.ArenaAllocator, walk: ?Walk = null };

/// Walks the bodies of one layer, each participant with its own arenas.
const Layer = struct {
    flow: Self,
    program: ir.Program,
    slots: Slots,
    functions: []const u32,
    walkers: []Walker,
    remembered: ?Remembered,
    next: std.atomic.Value(usize) = .init(0),
    failed: std.atomic.Value(bool) = .init(false),
    fn run(self: *Layer, participant: usize) void {
        const walker = &self.walkers[participant];

        if (walker.walk == null) walker.walk = .{ .allocator = walker.lasting.allocator(), .flow = self.flow, .slots = self.slots };

        while (true) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.functions.len) return;

            const index = self.functions[position];

            self.step(walker, index) catch {
                self.failed.store(true, .monotonic);

                return;
            };
        }
    }
    fn step(self: *Layer, walker: *Walker, index: u32) std.mem.Allocator.Error!void {
        const function = self.program.functions.at(index);

        if (function.external != null) return;

        const held = @constCast(self.flow.held[index]);
        const text_held = @constCast(self.flow.text_held[index]);
        const written = @constCast(self.flow.written[index]);

        if (self.remembered) |kept| {
            kept.keys[index] = kept.key(self.flow, function, index);
            kept.found[index] = false;

            if (kept.memo.getFlowed(kept.keys[index])) |value| if (value.held.len == held.len and value.text_held.len == text_held.len and value.written.len == written.len) {
                @memcpy(held, value.held);
                @memcpy(text_held, value.text_held);
                @memcpy(written, value.written);

                kept.found[index] = true;

                return;
            };
        }

        if (held.len == 0) return;

        defer _ = walker.bodies.reset(.retain_capacity);
        const body = try Body.create(walker.bodies.allocator(), walker.bodies.allocator(), function, self.slots);
        const walk = &walker.walk.?;

        _ = try walk.analyze(index, &body, held, text_held, written);
    }
};

/// Settles summaries over a call graph with cycles: a body is walked again whenever a callee's summary grows.
fn settle(self: Self, allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, slots: Slots) std.mem.Allocator.Error!void {
    var building = std.heap.ArenaAllocator.init(workspace);

    defer building.deinit();

    const count = program.functions.count();
    const bodies = try allocator.alloc(?Body, count);
    const callers = try allocator.alloc(std.ArrayList(u32), count);

    for (callers) |*list| list.* = .empty;

    for (0..count) |index| {
        defer _ = building.reset(.retain_capacity);
        const function = program.functions.at(index);

        bodies[index] = if (function.external == null and self.held[index].len != 0) try Body.create(allocator, building.allocator(), function, slots) else null;

        if (bodies[index] == null) continue;

        for (function.expressions.kinds, 0..) |_, expression| {
            const callee = function.expressions.callee(expression) orelse continue;

            try callers[@backingInt(callee)].append(allocator, @intCast(index));
        }
    }

    var queued = try allocator.alloc(bool, count);
    var queue: std.ArrayList(u32) = .empty;

    // Callees come before their callers in the table, and the queue pops from its end, so it starts with the first
    // function on top: most bodies then read finished callee summaries and are walked once.
    for (0..count) |position| {
        const index = count - 1 - position;

        queued[index] = bodies[index] != null;

        if (queued[index]) try queue.append(allocator, @intCast(index));
    }

    var walk = Walk{ .allocator = allocator, .flow = self, .slots = slots };

    defer walk.deinit();

    while (queue.pop()) |index| {
        queued[index] = false;
        const body = &bodies[index].?;
        const text_held = @constCast(self.text_held[index]);

        if (!try walk.analyze(index, body, @constCast(self.held[index]), text_held, @constCast(self.written[index]))) continue;

        for (callers[index].items) |caller| {
            if (queued[caller]) continue;

            queued[caller] = true;

            try queue.append(allocator, caller);
        }
    }
}
