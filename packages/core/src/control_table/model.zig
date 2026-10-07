pub const Kind = enum { Evaluate, Constant, Parallel, Destructure, Branch, Switch, StoreSet, Result };

pub const Table = struct {
    pub const validStructure = @import("validate.zig").structure;

    block_count: []const u32 = &.{},
    block_first: []const u32 = &.{},
    branch_conditions: []const u32 = &.{},
    branch_no: []const u32 = &.{},
    branch_yes: []const u32 = &.{},
    case_bodies: []const u32 = &.{},
    case_values: []const ?u32 = &.{},
    constant_symbols: []const u32 = &.{},
    constant_values: []const u32 = &.{},
    destructure_count: []const u32 = &.{},
    destructure_first: []const u32 = &.{},
    destructure_symbols: []const ?u32 = &.{},
    destructure_values: []const u32 = &.{},
    evaluations: []const u32 = &.{},
    parallel_count: []const u32 = &.{},
    parallel_first: []const u32 = &.{},
    parallel_symbols: []const ?u32 = &.{},
    parallel_values: []const u32 = &.{},
    results: []const ?u32 = &.{},
    selection_count: []const u32 = &.{},
    selection_exhaustive: []const bool = &.{},
    selection_first: []const u32 = &.{},
    selection_subjects: []const u32 = &.{},
    setter_slots: []const u32 = &.{},
    setter_values: []const u32 = &.{},
    statement_kinds: []const Kind = &.{},
    statement_payloads: []const u32 = &.{},
};
