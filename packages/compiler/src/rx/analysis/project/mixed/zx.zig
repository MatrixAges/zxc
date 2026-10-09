const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const State = @import("state.zig");
const target = @import("../../call/target.zig");
const Source = frontend.project.artifact.source_link;

pub fn compile(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, index: usize, setter: ?target.Setter) State.Error!Source.Loaded {
    state.owner = index;
    _ = state.scratch.reset(.retain_capacity);
    const temporary = state.scratch.allocator();
    const module = state.graph.modules[index];
    const source = sources[module.source.zx];
    const signature = state.signature(index) orelse return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source module signature is missing");
    const parsed = try cache.getModule(source.source, module.path);

    if (try parsed.check(temporary)) |issue| return diagnostic(state, source.source, issue);

    const imports = switch (parsed.*) {
        .native => |result| try @import("imports.zig").collect(state, zx.syntax.header.Native{ .program = result.value.parsed.ast }, index, signature),
        .indexed => |*result| if (frontend.project.ParseCache.indexed_enabled) try @import("imports.zig").collect(state, result.header(), index, signature) else unreachable,
    };

    const base = state.functions.view();

    const stores: @FieldType(frontend.Context, "stores") = if (setter) |grant|
        try temporary.dupe(std.meta.Child(@FieldType(frontend.Context, "stores")), &.{.{ .handle = "$store", .path = grant.name, .type_id = grant.type_id, .readable = false }})

    else
        &.{};

    const result = try frontend.analyzeResolvedIn(temporary, parsed, .{
        .types = state.types.items.view(),
        .nominal_types = state.types.origins.items.view(),
        .native_modules = state.native_modules.view(),
        .stores = stores,
    }, .{
        .aliases = signature.type_imports,
        .imports = imports,
        .functions = base,
        .store_initializers = state.initializers.items,
    });

    if (result.value == .diagnostic) return diagnostic(state, source.source, result.value.diagnostic);

    var program = result.value.ir;

    if (setter) |grant| {
        if (!signature.signature.has_store or program.stores.count() != 1) return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "Store setter requires its declared authorized slot");

        const paths = try temporary.dupe([]const u8, program.stores.paths);

        paths[0] = try temporary.dupe(u8, grant.path);
        program.stores.paths = paths;
    }

    var destination = state.destination();

    destination.temporary = temporary;

    return Source.appendBody(.{
        .program = program,
        .base_functions = base,
        .nominal_types = result.nominal_types,
        .store_initializers = result.store_initializers,
    }, destination) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source module body cannot be linked to its shared compilation context");
    };
}

fn diagnostic(state: *State, source: []const u8, issue: zx.Diagnostic) State.Error {
    const location = zx.source.locate(source, issue.span.start);

    state.issue = .{
        .path = state.graph.modules[state.owner].path,
        .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column },
        .code = @tagName(issue.code),
        .message = try state.allocator.dupe(u8, issue.message),
    };

    return error.InvalidSourceGraph;
}
