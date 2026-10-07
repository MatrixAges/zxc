const std = @import("std");
const model = @import("model.zig");
const Storage = @import("storage.zig");
const fields = @typeInfo(model.Table).@"struct".field_names;
const Counts = [fields.len]usize;

pub fn block(self: *Storage, allocator: std.mem.Allocator, values: []const model.Statement) Storage.Error!void {
    var counts = std.mem.zeroes(Counts);

    try add(&counts, &.{ "statement_kinds", "statement_payloads" }, values.len);
    try add(&counts, &.{ "block_first", "block_count" }, 1);

    for (values) |value| switch (value) {
        .evaluate => try add(&counts, &.{"evaluations"}, 1),
        .constant => try add(&counts, &.{ "constant_symbols", "constant_values" }, 1),
        .parallel => |items| {
            try add(&counts, &.{ "parallel_first", "parallel_count" }, 1);
            try add(&counts, &.{ "parallel_symbols", "parallel_values" }, items.len);
        },
        .destructure => |item| {
            try add(&counts, &.{ "destructure_values", "destructure_first", "destructure_count" }, 1);
            try add(&counts, &.{"destructure_symbols"}, item.symbols.len);
        },
        .branch => |item| {
            if (item.yes >= self.block_first.items.len or item.no >= self.block_first.items.len) return error.InvalidBlock;

            try add(&counts, &.{ "branch_conditions", "branch_yes", "branch_no" }, 1);
        },
        .selection => |item| {
            for (item.cases) |case| if (case.body >= self.block_first.items.len) return error.InvalidBlock;
            try add(&counts, &.{ "selection_subjects", "selection_first", "selection_count", "selection_exhaustive" }, 1);
            try add(&counts, &.{ "case_values", "case_bodies" }, item.cases.len);
        },
        .store_set => try add(&counts, &.{ "setter_slots", "setter_values" }, 1),
        .result => try add(&counts, &.{"results"}, 1),
    };

    inline for (fields, 0..) |name, index| {
        const existing = @field(self, name).items.len;

        if (existing > std.math.maxInt(u32) or counts[index] > std.math.maxInt(u32) - existing) return error.OutOfMemory;
    }

    inline for (fields, 0..) |name, index| {
        try @field(self, name).ensureUnusedCapacity(allocator, counts[index]);
    }
}

fn add(counts: *Counts, comptime names: []const []const u8, count: usize) std.mem.Allocator.Error!void {
    inline for (names) |name| {
        const index = comptime fieldIndex(name);

        if (count > std.math.maxInt(u32) - counts[index]) return error.OutOfMemory;

        counts[index] += count;
    }
}

fn fieldIndex(comptime name: []const u8) usize {
    inline for (fields, 0..) |candidate, index| {
        if (comptime std.mem.eql(u8, name, candidate)) return index;
    }

    @compileError("Unknown control column");
}
