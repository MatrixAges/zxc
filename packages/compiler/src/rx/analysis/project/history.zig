//! What one mixed analysis leaves for the next. Modules are linked in dependency order into append-only shared tables,
//! so a later analysis that reaches a module with the tables exactly as the earlier one had them, and whose source and
//! dependencies are unchanged, appends the same rows: it copies them instead of analyzing the module again. The rows
//! keep pointing into the earlier analysis, so its memory, its inputs and every parse result it used must outlive the
//! later one.
//!
//! When every changed ZX source differs only inside its function body, the source graph, signatures and RX
//! constraints cannot differ either, so the later analysis also takes the `Frame` the earlier one derived.
const std = @import("std");
const ir = @import("zx").ir;
const frontend = @import("frontend");
const bytes = @import("zx").bytes;
const columns = @import("history/columns.zig");
const Types = frontend.project.artifact.type_link.Table;
const Source = frontend.project.artifact.source_link;
pub const OriginStorage = @FieldType(@FieldType(Types, "origins"), "items");
pub const OriginTable = @typeInfo(@TypeOf(OriginStorage.view)).@"fn".return_type.?;

/// What an analysis derives from everything but the ZX function bodies.
pub const Frame = struct {
    modules: []const @import("rx").ModuleSource,
    dependencies: @import("source_graph/model.zig").Graph,
    definitions: []@import("../store.zig").Definition,
    loaded: @import("prepare.zig").Loaded,
    signatures: frontend.project.signature_project.Data,
    resolved: []const @import("signatures.zig").Signature,
    types: ir.TypeTable,
};

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
    shape: [32]u8,
    /// The inputs the analysis read: the selected RX modules and every source.
    modules: []const @import("rx").ModuleSource,
    sources: []const frontend.project.Source,
    derived: Frame,
    initial: Checkpoint,
    paths: []const []const u8,
    /// Each module's source digest.
    digests: []const ?[32]u8,
    before: []const Checkpoint,
    after: []const Checkpoint,
    finished: []const ?Source.Loaded,
    types: ir.TypeTable,
    origins: OriginTable,
    functions: ir.FunctionTable,
};

/// An RX module's source digest, listed by path.
pub const Digest = struct { path: []const u8, digest: [32]u8 };

/// Carries one analysis to the next.
pub const History = struct {
    /// Everything the analysis reads besides ZX sources: RX sources, entries, packages and interfaces.
    frame: [32]u8,
    /// The frame without the RX sources' texts: an analysis with the same shape reuses each RX module whose own text,
    /// dependencies and resolved signature are unchanged.
    shape: [32]u8 = @splat(0),
    /// The digests of the RX sources, ordered by path.
    rx_digests: []const Digest = &.{},
    previous: ?Retained = null,
    /// Set by an analysis that succeeds, for the caller to pass on as `previous`.
    next: ?Retained = null,
    reused: usize = 0,
    analyzed: usize = 0,
    /// Set by the caller when `bodiesOnly` holds, so the analysis takes the earlier `Frame`.
    bodies_only: bool = false,
    /// Whether `sources` differ from the earlier analysis's only inside ZX function bodies: the same files, and each
    /// changed one identical up to and including its body's opening brace. Nothing may follow a body, so the rest of
    /// such a file is that body.
    pub fn bodiesOnly(self: *const History, sources: []const frontend.project.Source, cache: *frontend.project.ParseCache) std.mem.Allocator.Error!bool {
        const earlier = if (self.previous) |*value| value else return false;

        if (!std.mem.eql(u8, &earlier.frame, &self.frame) or earlier.sources.len != sources.len) return false;

        for (earlier.sources, sources) |before, after| {
            if (!bytes.equal(before.path, after.path)) return false;
            if (before.source.ptr == after.source.ptr and before.source.len == after.source.len) continue;
            if (bytes.equal(before.source, after.source)) continue;

            const parsed = try cache.getModule(after.source, after.path);
            const body = parsed.bodyStart() orelse return false;
            const shared = std.mem.indexOfDiff(u8, before.source, after.source) orelse return false;

            if (shared <= body) return false;
        }

        return true;
    }
    /// The digest of the RX source at `path`.
    pub fn rxDigest(self: *const History, path: []const u8) ?[32]u8 {
        const index = std.sort.binarySearch(Digest, self.rx_digests, path, order) orelse return null;

        return self.rx_digests[index].digest;
    }
    fn order(path: []const u8, item: Digest) std.math.Order {
        return std.mem.order(u8, path, item.path);
    }
};
