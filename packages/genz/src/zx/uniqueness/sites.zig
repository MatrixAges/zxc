const std = @import("std");
const ir = @import("zx").ir;
const Order = @import("order.zig");
const Slots = @import("slots.zig");
const Summaries = @import("summaries.zig");
const Seed = @import("sites/seed.zig");
const generated_analysis = @import("genz_options").generated_analysis;
const Generated = if (generated_analysis) @import("sites/generated.zig") else void;
const Self = @This();

order: *const Order,
symbols: ir.SymbolTable,
expressions: ir.ExpressionTable,
summaries: *const Summaries,
slot_first: []const u32,
facts: if (generated_analysis) Generated.Facts else void,
seed: if (generated_analysis) void else Seed,
pub fn create(allocator: std.mem.Allocator, workspace: std.mem.Allocator, order: *const Order, slots: Slots, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, summaries: *const Summaries) std.mem.Allocator.Error!Self {
    if (!generated_analysis) {
        const seed = try Seed.create(allocator, order, slots, symbols, expressions, summaries);

        return .{ .order = order, .symbols = symbols, .expressions = expressions, .summaries = summaries, .slot_first = seed.slot_first, .facts = {}, .seed = seed };
    }

    const facts = try Generated.build(allocator, workspace, order, slots, symbols, expressions, summaries);

    return .{ .order = order, .symbols = symbols, .expressions = expressions, .summaries = summaries, .slot_first = facts.plan.slot_first, .facts = facts, .seed = {} };
}

pub fn symbolRoot(symbol: ir.SymbolId) u32 {
    return @backingInt(symbol);
}

pub fn nodeRoot(self: Self, id: ir.ExprId) u32 {
    return @intCast(self.symbols.count() + @backingInt(id));
}

pub fn observed(self: *Self, root: u32, slot: u32) bool {
    if (!generated_analysis) return self.seed.observed(root, slot);

    return self.read(root, slot, true);
}

pub fn linear(self: *Self, root: u32, slot: u32) bool {
    if (!generated_analysis) return self.seed.linear(root, slot);

    return self.read(root, slot, false);
}

fn read(self: *Self, root: u32, slot: u32, comptime observe: bool) bool {
    const index = self.slot_first[root] + slot;

    if (index < self.slot_first[root + 1]) return Generated.read(self.facts.states[index], observe);

    return Generated.query(self.facts.plan, self.order, &self.expressions, self.symbols.count(), self.summaries, root, slot, observe);
}
