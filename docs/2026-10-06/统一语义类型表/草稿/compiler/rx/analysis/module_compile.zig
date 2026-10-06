const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const expression = @import("expression.zig");
const target = @import("call/target.zig");

pub const Options = struct {
    owner: []const u8,
    module: rx.ast.Node,
    calls: []const Module.Loaded,
    steps: []const @import("project/flow.zig").Step,
    bindings: []const Module.Binding,
    tasks: []const @import("flow_compile.zig").TaskType = &.{},
    types: zx.ir.TypeTable,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
};

pub fn compile(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Value {
    var flow = @import("flow_compile.zig"){
        .allocator = allocator,
        .owner = options.owner,
        .types = options.types,
        .output_type = options.output_type,
        .loaded = options.calls,
        .results = options.bindings,
        .tasks = options.tasks,
        .unit_input = options.input_type == @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void))),
    };

    if (options.input_type != @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)))) try flow.bindings.append(allocator, .{ .name = "$in", .type_id = options.input_type });

    const steps = flow.steps(options.steps) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return diagnostic(allocator, options.owner, flow.issue.?);
    };

    const types = flow.types;
    const calls = flow.calls;
    var result: ?zx.ir.Program = if (steps.len != 0 and steps[steps.len - 1] == .result) steps[steps.len - 1].result else null;

    const native_modules = @import("module_native.zig").merge(allocator, calls.items, types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const failed = try target.failure(allocator, .{ .path = options.owner, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "contract", .message = "RX calls contain conflicting native interfaces" });

        return .{ .diagnostic = failed.diagnostic };
    };

    for (calls.items) |*call| {
        call.callee.types = types;
        call.argument.types = types;
        call.argument.native_modules = native_modules;

        if (try frontend.validateIr(allocator, call.callee)) |issue| return invalid(allocator, options, issue);
    }

    if (result) |*program| {
        program.types = types;
        program.native_modules = native_modules;
    }

    const lowered = @import("program.zig").lower(allocator, .{ .owner = options.owner, .types = types, .input_type = options.input_type, .output_type = options.output_type, .calls = calls.items, .native_modules = native_modules, .steps = steps }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        if (err == error.UnreachableFlow or err == error.IncompleteFlow) return invalid(allocator, options, .{ .code = .return_path, .span = .{ .start = 0, .end = 0 }, .message = if (err == error.UnreachableFlow) "steps after a terminating Return or Switch are unreachable" else "every RX path must return Output" });

        return invalid(allocator, options, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "RX expression environment cannot be linked to the module program" });
    };

    var program = lowered.program;
    var reporter: zx.Reporter = .{};

    program.output_ownership = frontend.analyzeOwnership(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return invalid(allocator, options, reporter.diagnostic.?);
    };

    if (try frontend.validateIr(allocator, program)) |issue| return invalid(allocator, options, issue);

    return .{ .contract = .{ .program = program, .store_initializers = lowered.store_initializers, .types = types, .nominal_types = options.nominal_types, .input_type = options.input_type, .output_type = options.output_type, .calls = calls.items, .result = result, .native_modules = native_modules } };
}

fn diagnostic(allocator: std.mem.Allocator, owner: []const u8, issue: expression.Diagnostic) std.mem.Allocator.Error!Module.Value {
    const failed = try target.failure(allocator, .{ .path = owner, .location = issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });

    return .{ .diagnostic = failed.diagnostic };
}

fn invalid(allocator: std.mem.Allocator, options: Options, issue: zx.Diagnostic) std.mem.Allocator.Error!Module.Value {
    const failed = try target.failure(allocator, .{ .path = options.owner, .location = Module.locate(options.module, issue.span.start) orelse options.module.location, .code = @tagName(issue.code), .message = issue.message });

    return .{ .diagnostic = failed.diagnostic };
}
