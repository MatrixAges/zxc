const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Flow = @import("flow_compile.zig");

pub fn compile(parent: *Flow, branch: @import("project/flow.zig").Task) Flow.Error!usize {
    const node = branch.node;
    const allocator = parent.allocator;
    const captures = try allocator.dupe(frontend.expressions.Binding, parent.bindings.items);
    const environment = parent.bindings.items;
    const children = try allocator.alloc(zx.ir.TypeId, captures.len);

    for (captures, children) |*capture, *child| {
        child.* = capture.type_id;

        const target_type = parent.types.at(@backingInt(capture.type_id));

        if (parent.isNonNull(capture.name) and target_type == .optional) capture.type_id = target_type.optional;
    }

    var reporter: zx.Reporter = .{};
    var types = frontend.types{ .allocator = allocator, .reporter = &reporter, .declarations = &.{} };

    try types.items.appendDelta(allocator, parent.types);

    const environment_type = types.tuple(children) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    };

    var output_type: ?zx.ir.TypeId = null;

    for (parent.tasks) |task| {
        if (task.id == branch.id) output_type = task.output_type;
    }

    std.debug.assert(output_type != null);

    var nested = Flow{ .allocator = allocator, .owner = parent.owner, .types = types.items.view(), .native_modules = parent.native_modules, .output_type = output_type.?, .loaded = parent.loaded, .results = parent.results, .tasks = parent.tasks, .next_binding = parent.next_binding, .unit_input = parent.unit_input };

    try nested.bindings.appendSlice(allocator, captures);

    const body = nested.steps(branch.body) catch |err| {
        parent.issue = nested.issue;

        return err;
    };

    parent.next_binding = nested.next_binding;
    parent.types = nested.types;

    for (nested.calls.items) |*call| {
        if (call.getters.len != 0 or !try frontend.isParallelSafe(allocator, call.callee)) return failure(parent, node, .{ .code = .unsupported, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task requires pure computation without Store access or native external calls" });

        call.callee.types = nested.types;
        call.argument.types = nested.types;
    }

    const selected = try @import("task_captures.zig").select(allocator, captures, nested.calls.items, body);
    const selected_types = try allocator.alloc(zx.ir.TypeId, selected.len);

    for (selected, selected_types) |capture, *child| child.* = capture.type_id;

    types.items = .{};

    try types.items.appendDelta(allocator, nested.types);

    const input_type = types.tuple(selected_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    };

    parent.types = types.items.view();

    const native_modules = @import("module_native.zig").merge(allocator, nested.calls.items, parent.types, parent.native_modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, .{ .code = .contract, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task calls contain conflicting native interfaces" });
    };

    const owner = try std.fmt.allocPrint(allocator, "{s}#parallel-task-{d}", .{ parent.owner, branch.id });

    const lowered = @import("program.zig").lower(allocator, .{ .owner = owner, .types = parent.types, .input_type = input_type, .output_type = output_type.?, .captures = selected, .calls = nested.calls.items, .native_modules = native_modules, .steps = body }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, .{ .code = if (err == error.IncompleteFlow or err == error.UnreachableFlow) .return_path else .contract, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = if (err == error.IncompleteFlow) "every Parallel Task path must return its output" else "Parallel Task expressions cannot be linked" });
    };

    var program = lowered.program;

    if (!try frontend.isParallelSafe(allocator, program)) return failure(parent, node, .{ .code = .unsupported, .span = .{ .start = node.location.offset, .end = node.location.offset }, .message = "Parallel Task requires pure computation without Store access or native external calls" });

    program.output_ownership = frontend.analyzeOwnership(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(parent, node, reporter.diagnostic.?);
    };

    if (try frontend.validateIr(allocator, program)) |issue| return failure(parent, node, issue);

    const argument = try @import("program/capture.zig").argument(allocator, parent.owner, parent.types, environment_type, environment, input_type, selected, .{ .start = node.location.offset, .end = node.location.offset });
    var out: ?[]const u8 = null;
    const binding = parent.results[parent.next_binding];

    parent.next_binding += 1;

    if (binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))))) {
        out = binding.name;

        try parent.bindings.append(allocator, .{ .name = binding.name, .type_id = binding.type_id });
    }

    const index = parent.calls.items.len;

    try parent.calls.append(allocator, .{ .callee = program, .argument = argument, .out = out });

    return index;
}

fn failure(parent: *Flow, node: rx.ast.Node, issue: zx.Diagnostic) Flow.Error {
    parent.issue = .{ .location = node.location, .issue = issue };

    return error.InvalidFlow;
}
