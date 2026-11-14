const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Flow = @import("flow_compile.zig");
const Captures = @import("task_captures.zig");
const Layout = @import("task_captures/layout.zig");

pub fn compile(parent: *Flow, branch: @import("project/flow.zig").Task) Flow.Error!usize {
    const node = branch.node;
    const allocator = parent.allocator;
    const environment = parent.bindings.items;
    var arena = std.heap.ArenaAllocator.init(parent.scratch);
    var buffer: [std.heap.page_size_min / 8]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const children = try temporary.alloc(zx.ir.TypeId, environment.len);

    for (environment, children) |binding, *child| child.* = binding.type_id;
    if (!Layout.admits(parent.types, children)) return failure(parent, node, .{ .code = .ownership, .span = .{ .start = 0, .end = 0 }, .message = "tasks cannot be placed in tuples" });

    var reporter: zx.Reporter = .{};

    var types = frontend.types{
        .allocator = allocator,
        .reporter = &reporter,
        .declarations = &.{},
        .items = try parent.takeTypeStorage(),
    };

    const output_type = parent.tasks[branch.id];
    var captures = try Captures.init(temporary, children);

    var nested = Flow{
        .allocator = allocator,
        .scratch = parent.scratch,
        .binding_allocator = temporary,
        .owner = parent.owner,
        .aliases = parent.aliases,
        .types = types.items.view(),
        .type_storage = types.items,
        .native_modules = parent.native_modules,
        .shared_functions = parent.shared_functions,
        .verified_functions = parent.verified_functions,
        .output_type = output_type,
        .loaded = parent.loaded,
        .results = parent.results,
        .tasks = parent.tasks,
        .captures = &captures,
        .next_binding = parent.next_binding,
        .unit_input = parent.unit_input,
    };

    types.items = .{};

    try nested.bindings.appendSlice(temporary, environment);

    Layout.narrow(nested.types, nested.bindings.items, parent.nonnull.items);

    const body = nested.steps(branch.body) catch |err| {
        parent.issue = nested.issue;

        return err;
    };

    parent.next_binding = nested.next_binding;

    for (nested.calls.items) |*call| {
        if (call.getters.len != 0 or !try frontend.isParallelSafe(allocator, call.callee)) return failure(parent, node, .{ .code = .unsupported, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task requires pure computation without Store access or native external calls" });

        call.callee.types = nested.types;
        call.argument.types = nested.types;
    }

    const positions = try captures.positions(temporary, children);
    const selected = try temporary.alloc(frontend.expressions.Binding, positions.len);
    const selected_types = try temporary.alloc(zx.ir.TypeId, positions.len);

    for (positions, selected, selected_types) |position, *capture, *child| {
        capture.* = nested.bindings.items[position];
        child.* = capture.type_id;
    }

    types.items = try nested.takeTypeStorage();

    const layout = try Layout.plan(temporary, children, positions, selected_types);

    const input_type = types.tuple(selected_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    };

    const environment_type = if (layout.narrows) types.tuple(layout.source_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    } else input_type;

    parent.type_storage = types.items;
    parent.types = parent.type_storage.view();

    const native_modules = if (parent.shared_functions != null) parent.native_modules else @import("module_native.zig").merge(allocator, nested.calls.items, parent.types, parent.native_modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, .{ .code = .contract, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task calls contain conflicting native interfaces" });
    };

    const owner = try std.fmt.allocPrint(allocator, "{s}#parallel-task-{d}", .{ parent.owner, branch.id });

    const lowered = @import("program.zig").lower(allocator, .{ .owner = owner, .types = parent.types, .input_type = input_type, .output_type = output_type, .captures = selected, .calls = nested.calls.items, .native_modules = native_modules, .shared_functions = parent.shared_functions, .steps = body }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, .{ .code = if (err == error.IncompleteFlow or err == error.UnreachableFlow) .return_path else .contract, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = if (err == error.IncompleteFlow) "every Parallel Task path must return its output" else "Parallel Task expressions cannot be linked" });
    };

    var program = lowered.program;

    if (!try frontend.isParallelSafe(allocator, program)) return failure(parent, node, .{ .code = .unsupported, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task requires pure computation without Store access or native external calls" });

    program.output_ownership = frontend.analyzeOwnership(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    };

    if (frontend.checks_internal_ir) if (try frontend.validateIrExtending(allocator, program, parent.verified_functions)) |issue| return failure(parent, node, issue);

    const argument = try @import("program/capture.zig").argument(allocator, parent.owner, parent.types, environment_type, input_type, selected, layout, .{ .start = node.location.offset, .end = node.location.offset });

    if (parent.captures) |outer| outer.observeMapped(argument.expressions.references, positions);

    var out: ?[]const u8 = null;
    const binding = parent.results.at(parent.next_binding);

    parent.next_binding += 1;

    if (binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))))) {
        out = binding.name;

        try parent.bindings.append(parent.binding_allocator, .{ .name = binding.name, .type_id = binding.type_id });
    }

    const index = parent.calls.items.len;

    try parent.calls.append(allocator, .{ .callee = program, .argument = argument, .out = out });

    return index;
}

fn failure(parent: *Flow, node: rx.ast.Node, issue: zx.Diagnostic) Flow.Error {
    parent.issue = .{ .location = node.location, .issue = issue };

    return error.InvalidFlow;
}
