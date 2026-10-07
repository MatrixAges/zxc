const ir = @import("../ir.zig");
const model = @import("model.zig");
const read = @import("read.zig");

pub const Invocations = struct {
    symbols: []const ?u32,
    values: []const u32,
    len: usize,
    pub fn at(self: Invocations, index: usize) ir.ParallelCall {
        return .{ .symbol = if (self.symbols[index]) |id| @fromBackingInt(id) else null, .value = @fromBackingInt(self.values[index]) };
    }
};

pub const Symbols = struct {
    values: []const ?u32,
    len: usize,
    pub fn at(self: Symbols, index: usize) ?ir.SymbolId {
        return if (self.values[index]) |id| @fromBackingInt(id) else null;
    }
};

pub const Cases = struct {
    control: *const model.Table,
    values: []const ?u32,
    bodies: []const u32,
    len: usize,
    pub fn at(self: Cases, index: usize) struct { value: ?ir.ExprId, body: read.Block } {
        return .{ .value = if (self.values[index]) |id| @fromBackingInt(id) else null, .body = read.block(self.control, @fromBackingInt(self.bodies[index])) };
    }
};
