const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const function_sources = @import("function_sources.zig");
const indexing = @import("generated_regular_calls_index");
const scanning = @import("generated_regular_calls_scan");
const selection = @import("generated_regular_calls_select");
const Index = std.meta.Child(indexing.Output);
const zx = @import("zx");

pub fn complete(owned: std.mem.Allocator, batch: *const Batch, roots: []const []const u8, units: []generating.Unit, sources: [][]const u8) generating.Error!void {
    if (comptime !@import("parser_options").generated_parser) return @import("regular_calls_seed.zig").complete(owned, batch, roots, units, sources);

    var scratch = std.heap.ArenaAllocator.init(batch.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const values = batch.analysis.value.value.values;
    const ids = try temporary.alloc(?u32, units.len);

    for (units, ids) |unit, *id| id.* = if (unit == .function) @backingInt(unit.function) else null;

    const Input = std.meta.Child(indexing.Input);
    const input: Input = .{ .ids = ids, .names = batch.names.functions, .values = values };
    const output = zx.columns.invoke(indexing.executeValue, temporary, &input) catch |err| return failure(err);
    const index = zx.columns.view(Index, output);

    if (index.keys.len == 0) return;

    const wanted = try temporary.alloc(u8, values.len);

    @memset(wanted, 0);

    var rows: [1][]u8 = .{wanted};
    var cells: [][]u8 = &rows;
    var scanned = try std.mem.concat(temporary, []const u8, &.{ roots, sources });

    while (true) {
        var scan = Scan{ .sources = scanned, .index = index, .wanted = @ptrCast(&cells) };

        try function_sources.spread(Scan, &scan, try arenas(temporary, scanned.len));

        const SelectInput = std.meta.Child(selection.Input);
        const request: SelectInput = .{ .source = &input, .index = &index, .wanted = @ptrCast(&cells) };
        const selected = selection.executeValue(temporary, &request) catch |err| return failure(err);

        if (selected.ids.len == 0) return;

        const added = try temporary.alloc(generating.Unit, selected.ids.len);

        for (selected.ids, selected.positions, added) |id, position, *unit| {
            unit.* = .{ .regular = @fromBackingInt(id) };

            units[@intCast(position)] = unit.*;
            ids[@intCast(position)] = null;
        }

        const regenerated = try function_sources.create(owned, batch, added);

        for (selected.positions, regenerated) |position, source| sources[@intCast(position)] = source;

        scanned = regenerated;
    }
}

const Scan = struct {
    sources: []const []const u8,
    index: Index,
    wanted: *const anyopaque,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    pub fn run(self: *Scan, _: *std.heap.ArenaAllocator) void {
        while (self.failure.load(.monotonic) == 0) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.sources.len) return;

            const Input = std.meta.Child(scanning.Input);
            const input: Input = .{ .source = self.sources[position], .index = &self.index, .wanted = @ptrCast(self.wanted) };
            var memory = std.heap.FixedBufferAllocator.init(&.{});

            scanning.executeValue(memory.allocator(), &input) catch |err| {
                const problem = failure(err);
                _ = self.failure.cmpxchgStrong(0, @intFromError(problem), .monotonic, .monotonic);

                return;
            };
        }
    }
};

fn arenas(temporary: std.mem.Allocator, count: usize) std.mem.Allocator.Error![]std.heap.ArenaAllocator {
    const result = try temporary.alloc(std.heap.ArenaAllocator, @min(@import("zx").parallel.width(), count));

    for (result) |*arena| arena.* = .init(temporary);

    return result;
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid regular call demand"),
    };
}
