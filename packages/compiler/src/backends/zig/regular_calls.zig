//! The value functions generated code still calls through their pointer-ABI `call`. A value function's file holds
//! only its value variant unless a caller lowers a call to it the pointer way, which lowering decides per call site;
//! the decision is read back from the generated sources, where each such call reads `@import("<module>")).call(`.
const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const function_sources = @import("function_sources.zig");
const search = @import("search.zig");

const needle = "\")).call(";

/// Gives `call` to every value function in `units` that `roots` or the files reach through it, regenerating those
/// files until every `call` they reach exists; `sources` are the files of `units` and are updated in place.
pub fn complete(owned: std.mem.Allocator, batch: *const Batch, roots: []const []const u8, units: []generating.Unit, sources: [][]const u8) generating.Error!void {
    var scratch = std.heap.ArenaAllocator.init(batch.backing);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const values = batch.analysis.value.value.values;
    const wanted = try temporary.alloc(bool, values.len);
    var modules: std.StringHashMapUnmanaged(u32) = .empty;

    @memset(wanted, false);

    for (units) |unit| if (unit == .function and values[@backingInt(unit.function)]) {
        try modules.put(temporary, batch.names.functions[@backingInt(unit.function)], @backingInt(unit.function));
    };

    if (modules.count() == 0) return;

    var scanned = try std.mem.concat(temporary, []const u8, &.{ roots, sources });

    while (true) {
        var scan = Scan{ .sources = scanned, .modules = &modules, .wanted = wanted };

        try function_sources.spread(Scan, &scan, temporary, try arenas(temporary, scanned.len));

        var added: std.ArrayList(generating.Unit) = .empty;
        var positions: std.ArrayList(usize) = .empty;

        for (units, 0..) |*unit, position| if (unit.* == .function and wanted[@backingInt(unit.function)]) {
            const id = unit.function;

            unit.* = .{ .regular = id };

            try added.append(temporary, unit.*);
            try positions.append(temporary, position);
        };

        if (added.items.len == 0) return;

        const regenerated = try function_sources.create(owned, batch, added.items);

        for (positions.items, regenerated) |position, source| sources[position] = source;

        scanned = regenerated;
    }
}

/// Marks the value functions each source calls through `call`, on all cores.
const Scan = struct {
    sources: []const []const u8,
    modules: *const std.StringHashMapUnmanaged(u32),
    wanted: []bool,
    next: std.atomic.Value(usize) = .init(0),
    failure: std.atomic.Value(u16) = .init(0),
    pub fn run(self: *Scan, _: *std.heap.ArenaAllocator) void {
        while (true) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.sources.len) return;

            const source = self.sources[position];
            var cursor: usize = 0;

            while (search.find(source, cursor, needle)) |at| {
                cursor = at + needle.len;

                const open = std.mem.lastIndexOfScalar(u8, source[0..at], '"') orelse continue;
                const index = self.modules.get(source[open + 1 .. at]) orelse continue;

                @atomicStore(bool, &self.wanted[index], true, .monotonic);
            }
        }
    }
};

fn arenas(temporary: std.mem.Allocator, count: usize) std.mem.Allocator.Error![]std.heap.ArenaAllocator {
    const result = try temporary.alloc(std.heap.ArenaAllocator, @min(@max(std.Thread.getCpuCount() catch 1, 1), count));

    for (result) |*arena| arena.* = .init(temporary);

    return result;
}
