const std = @import("std");
const model = @import("model.zig");
const Self = @This();
const ir = @import("../ir.zig");

statement_kinds: std.ArrayList(model.Kind) = .empty,
statement_payloads: std.ArrayList(u32) = .empty,
evaluations: std.ArrayList(u32) = .empty,
constant_symbols: std.ArrayList(u32) = .empty,
constant_values: std.ArrayList(u32) = .empty,
parallel_first: std.ArrayList(u32) = .empty,
parallel_count: std.ArrayList(u32) = .empty,
parallel_symbols: std.ArrayList(?u32) = .empty,
parallel_values: std.ArrayList(u32) = .empty,
destructure_values: std.ArrayList(u32) = .empty,
destructure_first: std.ArrayList(u32) = .empty,
destructure_count: std.ArrayList(u32) = .empty,
destructure_symbols: std.ArrayList(?u32) = .empty,
branch_conditions: std.ArrayList(u32) = .empty,
branch_yes: std.ArrayList(u32) = .empty,
branch_no: std.ArrayList(u32) = .empty,
selection_subjects: std.ArrayList(u32) = .empty,
selection_first: std.ArrayList(u32) = .empty,
selection_count: std.ArrayList(u32) = .empty,
selection_exhaustive: std.ArrayList(bool) = .empty,
case_values: std.ArrayList(?u32) = .empty,
case_bodies: std.ArrayList(u32) = .empty,
setter_slots: std.ArrayList(u32) = .empty,
setter_values: std.ArrayList(u32) = .empty,
results: std.ArrayList(?u32) = .empty,
block_first: std.ArrayList(u32) = .empty,
block_count: std.ArrayList(u32) = .empty,
pub const appendBlock = @import("append.zig").block;

pub fn view(self: *const Self) model.Table {
    var result: model.Table = .{};

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| {
        @field(result, name) = @field(self, name).items;
    }

    return result;
}

pub fn finish(self: *Self, allocator: std.mem.Allocator, root: ?ir.BlockId) std.mem.Allocator.Error!@import("root.zig") {
    errdefer self.deinit(allocator);

    if (root == null) {
        std.debug.assert(self.block_first.items.len == 0);
        self.deinit(allocator);

        return .{};
    }

    const table = try allocator.create(model.Table);

    table.* = .{};

    errdefer {
        inline for (@typeInfo(model.Table).@"struct".field_names) |name| allocator.free(@field(table, name));
        allocator.destroy(table);
    }

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| {
        @field(table, name) = try @field(self, name).toOwnedSlice(allocator);
    }

    return .{ .control = table, .root = root };
}

pub fn returns(self: *const Self, root: ir.BlockId) bool {
    const table = self.view();

    return ir.terminates(@import("read.zig").block(&table, root));
}

pub fn terminates(self: *const Self, values: []const ir.Statement) bool {
    if (values.len == 0) return false;

    return switch (values[values.len - 1]) {
        .result => true,
        .branch => |branch| self.returns(branch.yes) and self.returns(branch.no),
        .switch_stmt => |selection| blk: {
            if (!selection.exhaustive) break :blk false;

            for (selection.cases) |case| if (!self.returns(case.body)) {
                break :blk false;
            };

            break :blk true;
        },
        else => false,
    };
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(model.Table).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
