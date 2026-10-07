pub const Kind = enum { Evaluate, Constant, Parallel, Destructure, Branch, Switch, StoreSet, Result };

pub const Table = struct {
    statement_kinds: []const Kind = &.{},
    statement_payloads: []const u32 = &.{},
    evaluations: []const u32 = &.{},
    constant_symbols: []const u32 = &.{},
    constant_values: []const u32 = &.{},
    parallel_first: []const u32 = &.{},
    parallel_count: []const u32 = &.{},
    parallel_symbols: []const ?u32 = &.{},
    parallel_values: []const u32 = &.{},
    destructure_values: []const u32 = &.{},
    destructure_first: []const u32 = &.{},
    destructure_count: []const u32 = &.{},
    destructure_symbols: []const ?u32 = &.{},
    branch_conditions: []const u32 = &.{},
    branch_yes: []const u32 = &.{},
    branch_no: []const u32 = &.{},
    selection_subjects: []const u32 = &.{},
    selection_first: []const u32 = &.{},
    selection_count: []const u32 = &.{},
    selection_exhaustive: []const bool = &.{},
    case_values: []const ?u32 = &.{},
    case_bodies: []const u32 = &.{},
    setter_slots: []const u32 = &.{},
    setter_values: []const u32 = &.{},
    results: []const ?u32 = &.{},
    block_first: []const u32 = &.{},
    block_count: []const u32 = &.{},
};

pub const Invocation = struct { symbol: ?u32, value: u32 };
pub const Case = struct { value: ?u32, body: u32 };

pub const Statement = union(enum) {
    evaluate: u32,
    constant: struct { symbol: u32, value: u32 },
    parallel: []const Invocation,
    destructure: struct { symbols: []const ?u32, value: u32 },
    branch: struct { condition: u32, yes: u32, no: u32 },
    selection: struct { subject: u32, cases: []const Case, exhaustive: bool },
    store_set: struct { slot: u32, value: u32 },
    result: ?u32,
};
