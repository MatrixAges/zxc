const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const State = @import("state.zig");
const target = @import("../../call/target.zig");
const Source = frontend.project.artifact.source_link;
const Binding = std.meta.Child(@FieldType(frontend.ResolvedImports, "imports"));

/// A module ready for analysis: its parse and the functions its imports bind, which the shared tables already hold.
pub const Prepared = struct {
    index: usize,
    source: []const u8,
    parsed: *const frontend.project.ParseCache.ModuleResult,
    type_imports: @FieldType(frontend.ResolvedImports, "aliases"),
    imports: []const Binding,
    /// Whether the parse passed its source checks already, which then come before the imports.
    checked: bool,
};

/// A body analyzed against the shared tables as they stood, with the lengths of the tables then.
pub const Analyzed = struct {
    result: frontend.ResolvedResult,
    functions: usize,
    types: usize,
    native_modules: usize,
    initializers: usize,
};

pub const Outcome = union(enum) { analyzed: Analyzed, diagnostic: zx.Diagnostic };

pub fn compile(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, index: usize, setter: ?target.Setter) State.Error!Source.Loaded {
    state.owner = index;
    _ = state.scratch.reset(.retain_capacity);
    const temporary = state.scratch.allocator();
    const prepared = try prepare(state, cache, sources, index, temporary);

    const stores: @FieldType(frontend.Context, "stores") = if (setter) |grant|
        try temporary.dupe(std.meta.Child(@FieldType(frontend.Context, "stores")), &.{.{ .handle = "$store", .path = grant.name, .type_id = grant.type_id, .readable = false }})

    else
        &.{};

    var analyzed = switch (try analyze(state, temporary, prepared, stores)) {
        .analyzed => |value| value,
        .diagnostic => |issue| return diagnostic(state, prepared.source, issue),
    };

    if (setter) |grant| {
        const program = &analyzed.result.value.ir;

        if (!state.signature(index).?.signature.has_store or program.stores.count() != 1) return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "Store setter requires its declared authorized slot");

        const paths = try temporary.dupe([]const u8, program.stores.paths);

        paths[0] = try temporary.dupe(u8, grant.path);
        program.stores.paths = paths;
    }

    return link(state, temporary, analyzed);
}

/// Reads the parse of `index` and binds its imports; the shared tables must hold every module it depends on. With a
/// `checking` allocator the parse is checked first, otherwise `analyze` checks it.
pub fn prepare(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, index: usize, checking: ?std.mem.Allocator) State.Error!Prepared {
    const module = state.graph.modules[index];
    const source = sources[module.source.zx];
    const signature = state.signature(index) orelse return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source module signature is missing");
    const parsed = try cache.getModule(source.source, module.path);

    if (checking) |allocator| if (try parsed.check(allocator)) |issue| return diagnostic(state, source.source, issue);

    const imports = switch (parsed.*) {
        .native => |result| try @import("imports.zig").collect(state, zx.syntax.header.Native{ .program = result.value.parsed.ast }, index, signature),
        .indexed => |*result| if (frontend.project.ParseCache.indexed_enabled) try @import("imports.zig").collect(state, result.header(), index, signature) else unreachable,
    };

    return .{ .index = index, .source = source.source, .parsed = parsed, .type_imports = signature.type_imports, .imports = imports, .checked = checking != null };
}

/// Analyzes a prepared body against the shared tables, which it only reads, so bodies that depend on none of each
/// other may run at once.
pub fn analyze(state: *const State, temporary: std.mem.Allocator, prepared: Prepared, stores: @FieldType(frontend.Context, "stores")) std.mem.Allocator.Error!Outcome {
    if (!prepared.checked) if (try prepared.parsed.check(temporary)) |issue| return .{ .diagnostic = issue };

    const base = state.functions.view();

    const result = try frontend.analyzeResolvedIn(temporary, prepared.parsed, .{
        .types = state.types.items.view(),
        .nominal_types = state.types.origins.items.view(),
        .native_modules = state.native_modules.view(),
        .stores = stores,
    }, .{
        .aliases = prepared.type_imports,
        .imports = prepared.imports,
        .functions = base,
        .verified_functions = state.verifiedFunctions(),
        .store_initializers = state.initializers.items,
    });

    if (result.value == .diagnostic) return .{ .diagnostic = result.value.diagnostic };

    return .{ .analyzed = .{
        .result = result,
        .functions = base.count(),
        .types = state.types.items.count(),
        .native_modules = state.native_modules.count(),
        .initializers = state.initializers.items.len,
    } };
}

/// Whether a body analyzed earlier can still be linked as it is: the tables it read may only have gained types and
/// functions, which the type merge and the function prefix account for.
pub fn current(state: *const State, analyzed: Analyzed) bool {
    return state.native_modules.count() == analyzed.native_modules and state.initializers.items.len == analyzed.initializers;
}

/// Links an analyzed body. The tables may have grown, and moved, since the analysis read them, but the rows it read are
/// unchanged, so the body refers to them where they are now.
pub fn link(state: *State, temporary: std.mem.Allocator, analyzed: Analyzed) State.Error!Source.Loaded {
    var destination = state.destination();
    var program = analyzed.result.value.ir;
    const base = state.functions.view().prefix(analyzed.functions);

    destination.temporary = temporary;
    program.functions = base;
    program.native_modules = state.native_modules.view();

    return state.linked(Source.appendBody(.{
        .program = program,
        .base_functions = base,
        .verified_functions = state.verifiedFunctions(),
        .nominal_types = analyzed.result.nominal_types,
        .store_initializers = analyzed.result.store_initializers,
        .base_types = if (analyzed.types == state.types.items.count() and analyzed.functions == state.functions.count()) null else analyzed.types,
    }, destination) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source module body cannot be linked to its shared compilation context");
    });
}

pub fn diagnostic(state: *State, source: []const u8, issue: zx.Diagnostic) State.Error {
    const location = zx.source.locate(source, issue.span.start);

    state.issue = .{
        .path = state.graph.modules[state.owner].path,
        .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column },
        .code = @tagName(issue.code),
        .message = try state.allocator.dupe(u8, issue.message),
    };

    return error.InvalidSourceGraph;
}
