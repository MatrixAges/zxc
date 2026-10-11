const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const flow = @import("../buffer_call/analysis/flow.zig");
const lanes = @import("../function_analysis/summaries.zig");
const generated = @import("generated_iteration_discover");
const Analysis = @import("analysis.zig");
const Input = std.meta.Child(generated.Input);
const Unit = std.meta.Child(@typeInfo(@FieldType(Input, "units")).pointer.child);

/// Runs the generated version analysis of one iteration of the program entry unit.
pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, path: []const usize, calls: ?Analysis.Calls) std.mem.Allocator.Error!?Analysis.Result {
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const units = try @import("../function_analysis/units.zig").build(Unit, temporary, &program);
    const pointers = try temporary.alloc(*const Unit, units.len);

    for (units, pointers) |*unit, *pointer| pointer.* = unit;

    const selected = try temporary.alloc(u32, path.len);

    for (path, selected) |part, *value| value.* = @intCast(part);

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);
    const options = calls orelse Analysis.Calls{ .selected = &.{}, .summaries = &.{}, .readers = &.{} };

    const input = Input{
        .types = &types,
        .units = zx.columns.slice(@FieldType(Input, "units"), @as([]const *const Unit, pointers)),
        .summaries = try lanes.summaries(@FieldType(Input, "summaries"), temporary, options.summaries),
        .readers = options.readers,
        .unit = units.len - 1,
        .iteration = locate(program, iteration),
        .path = selected,
        .calls = calls != null,
        .selected = try lanes.calls(@FieldType(Input, "selected"), temporary, options.selected),
        .discover = options.discover,
    };

    const output = generated.execute(&scratch, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.found) return null;

    const updates = try allocator.alloc(ir.ExprId, output.updates.len);
    const inferred = try allocator.alloc(flow.Call, output.calls.len);

    for (output.updates, updates) |value, *id| id.* = @fromBackingInt(value);
    for (output.calls, inferred) |call, *target| target.* = .{ .expression = @fromBackingInt(@import("../function_analysis/abi.zig").unwrap(call).expression), .lane = @intCast(@import("../function_analysis/abi.zig").unwrap(call).lane) };

    return .{ .updates = updates, .calls = inferred };
}

fn locate(program: ir.Program, iteration: ir.Iteration) u64 {
    for (0..program.expressions.count()) |index| {
        const value = program.expressions.at(index).value;

        if (value == .iteration and value.iteration.body == iteration.body and value.iteration.initial == iteration.initial) return index;
    }

    unreachable;
}
