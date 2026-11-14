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
const columns = @import("history/columns.zig");
const admission = @import("history/admission.zig");
const Types = frontend.project.artifact.type_link.Table;
const Source = frontend.project.artifact.source_link;
pub const OriginStorage = @FieldType(@FieldType(Types, "origins"), "items");
pub const OriginTable = @typeInfo(@TypeOf(OriginStorage.view)).@"fn".return_type.?;

/// What an analysis derives from everything but the ZX function bodies.
pub const Frame = struct {
    stores: []const @import("rx").ModuleSource = &.{},
    modules: []const @import("rx").ModuleSource,
    dependencies: @import("source_graph/model.zig").Graph,
    export_roots: []const usize,
    definitions: []@import("../store.zig").Definition,
    loaded: @import("prepare.zig").Loaded,
    signatures: frontend.project.signature_project.Data,
    signature_entries: []const []const u8,
    signature_indices: []const ?usize,
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
    /// Set when the analysis takes the earlier signatures, which then outlive it.
    signatures_reused: bool = false,
    pub fn exceedsBudget(capacity: usize) bool {
        if (comptime @import("rx_options").generated_graph) {
            var empty = std.heap.FixedBufferAllocator.init(&.{});

            return @import("generated_rx_history_budget").executeValue(empty.allocator(), capacity) catch unreachable;
        }

        const seed_retained_limit = 3 << 30;

        return capacity > seed_retained_limit;
    }

    pub fn borrowsPrevious(self: *const History) bool {
        if (comptime @import("rx_options").generated_graph) {
            var empty = std.heap.FixedBufferAllocator.init(&.{});

            return @import("generated_rx_history_borrows").executeValue(empty.allocator(), &.{
                .modules = self.reused,
                .frame = self.bodies_only,
                .signatures = self.signatures_reused,
            }) catch unreachable;
        }

        return self.reused != 0 or self.bodies_only or self.signatures_reused;
    }

    /// Whether `sources` differ from the earlier analysis's only inside ZX function bodies: the same files, and each
    /// changed one identical up to and including its body's opening brace. Nothing may follow a body, so the rest of
    /// such a file is that body.
    pub fn bodiesOnly(self: *const History, sources: []const frontend.project.Source, cache: *frontend.project.ParseCache) std.mem.Allocator.Error!bool {
        const earlier = if (self.previous) |*value| value else return false;

        if (!admission.sameInputs(&earlier.frame, &self.frame, earlier.sources.len, sources.len)) return false;

        const modules = earlier.derived.dependencies.modules[0..sources.len];

        for (earlier.sources, sources, modules) |*before, *after, *module| switch (admission.source(before, after)) {
            .DifferentPath => return false,
            .Unchanged => {},
            .Edited => {
                const parsed = try cache.getModule(after.source, module.path);
                const body = parsed.bodyStart() orelse return false;

                if (!admission.sameHeader(before.source, after.source, body)) return false;
            },
        };

        return true;
    }

    /// The earlier analysis's signatures when they hold again: the same shape, the same ZX sources, and `entries`, the
    /// modules signed, in the same order. An edit to RX sources alone keeps them.
    pub fn signatures(self: *const History, sources: []const frontend.project.Source, entries: []const []const u8) ?frontend.project.signature_project.Data {
        const earlier = if (self.previous) |*value| value else return null;

        if (!admission.signed(&earlier.shape, &self.shape, earlier.sources.len, sources.len, earlier.derived.signature_entries, entries)) return null;

        for (earlier.sources, sources) |*before, *after| if (admission.source(before, after) != .Unchanged) return null;

        return earlier.derived.signatures;
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
