//! What one mixed analysis leaves for the next. Modules are linked in dependency order into append-only shared tables,
//! so a later analysis that reaches a module with the tables exactly as the earlier one had them, and whose source and
//! dependencies are unchanged, appends the same rows: it copies them instead of analyzing the module again. The rows
//! keep pointing into the earlier analysis, so its memory, its inputs and every parse result it used must outlive the
//! later one.
const std = @import("std");
const ir = @import("zx").ir;
const frontend = @import("frontend");
const columns = @import("history/columns.zig");
const Types = frontend.project.artifact.type_link.Table;
const Source = frontend.project.artifact.source_link;
pub const OriginStorage = @FieldType(@FieldType(Types, "origins"), "items");
pub const OriginTable = @typeInfo(@TypeOf(OriginStorage.view)).@"fn".return_type.?;

/// The shared tables' extent at one point of an analysis.
pub const Checkpoint = struct {
    types: columns.Lengths(ir.TypeStorage),
    origins: columns.Lengths(OriginStorage),
    functions: usize,
    native_modules: usize,
    initializers: usize,
    libraries: usize,

    pub fn eql(self: Checkpoint, other: Checkpoint) bool {
        return std.meta.eql(self, other);
    }
};

/// One finished analysis: its tables and, for each source graph module, where its rows start and end.
pub const Retained = struct {
    frame: [32]u8,
    initial: Checkpoint,
    paths: []const []const u8,
    /// Each ZX module's source digest; RX sources are covered by `frame`.
    digests: []const ?[32]u8,
    before: []const Checkpoint,
    after: []const Checkpoint,
    finished: []const ?Source.Loaded,
    types: ir.TypeTable,
    origins: OriginTable,
    functions: ir.FunctionTable,
};

/// Carries one analysis to the next.
pub const History = struct {
    /// Everything the analysis reads besides ZX sources: RX sources, entries, packages and interfaces.
    frame: [32]u8,
    previous: ?Retained = null,
    /// Set by an analysis that succeeds, for the caller to pass on as `previous`.
    next: ?Retained = null,
    reused: usize = 0,
    analyzed: usize = 0,
};
