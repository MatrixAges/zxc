const std = @import("std");
const model = @import("model.zig");
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidBlock};

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

pub fn finish(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!model.Table {
    var result: model.Table = .{};

    errdefer {
        inline for (@typeInfo(model.Table).@"struct".field_names) |name| allocator.free(@field(result, name));
        self.deinit(allocator);
    }

    inline for (@typeInfo(model.Table).@"struct".field_names) |name| {
        @field(result, name) = try @field(self, name).toOwnedSlice(allocator);
    }

    return result;
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    inline for (@typeInfo(model.Table).@"struct".field_names) |name| @field(self, name).deinit(allocator);

    self.* = .{};
}
