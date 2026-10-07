const ir = @import("../ir.zig");

pub const ParallelBranches = struct {
    tasks: []const u32,
    fields: []const ?u32,
    len: usize,
    pub fn at(self: ParallelBranches, index: usize) ir.ParallelBranch {
        return .{ .task = @fromBackingInt(self.tasks[index]), .field = self.fields[index] };
    }
};

pub const Bindings = struct {
    symbols: []const ?u32,
    values: []const u32,
    borrows: []const bool,
    len: usize,
    pub fn at(self: Bindings, index: usize) ir.ScopeBinding {
        return .{ .symbol = if (self.symbols[index]) |id| @fromBackingInt(id) else null, .value = @fromBackingInt(self.values[index]), .borrow = self.borrows[index] };
    }
};

pub const MatchArms = struct {
    conditions: []const u32,
    results: []const u32,
    len: usize,
    pub fn at(self: MatchArms, index: usize) ir.MatchArm {
        return .{ .condition = @fromBackingInt(self.conditions[index]), .result = @fromBackingInt(self.results[index]) };
    }
};

pub const ObjectFields = struct {
    indices: []const u32,
    values: []const u32,
    len: usize,
    pub fn at(self: ObjectFields, index: usize) ir.ObjectField {
        return .{ .index = self.indices[index], .value = @fromBackingInt(self.values[index]) };
    }
};
