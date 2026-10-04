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
    returned: ?rx.ast.Attribute,
    bindings: []const Module.Binding,
    types: []const zx.ir.Type,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
};

pub fn compile(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Value {
    var types = options.types;
    var bindings: std.ArrayList(frontend.expressions.Binding) = .empty;
    var calls: std.ArrayList(Module.Call) = .empty;
    var next_binding: usize = 0;

    if (options.input_type != @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)))) try bindings.append(allocator, .{ .name = "$in", .type_id = options.input_type });

    for (options.calls) |loaded| {
        const compiled = try expression.compile(allocator, options.owner, target.attribute(loaded.node, "in"), .{ .types = types, .bindings = bindings.items, .expected = loaded.function.program.input_type });

        if (compiled.value == .diagnostic) return diagnostic(allocator, options.owner, compiled.value.diagnostic);

        var out: ?[]const u8 = null;

        for (loaded.node.attributes) |attribute| {
            if (!std.mem.eql(u8, attribute.name, "out")) continue;

            const binding = options.bindings[next_binding];

            try bindings.append(allocator, .{ .name = binding.name, .type_id = binding.type_id });

            out = binding.name;
            next_binding += 1;
        }

        types = compiled.value.ir.types;

        try calls.append(allocator, .{ .callee = loaded.function.program, .argument = compiled.value.ir, .out = out });
    }

    var result: ?zx.ir.Program = null;

    if (options.returned) |attribute| {
        const compiled = try expression.compile(allocator, options.owner, attribute, .{ .types = types, .bindings = bindings.items, .expected = options.output_type });

        if (compiled.value == .diagnostic) return diagnostic(allocator, options.owner, compiled.value.diagnostic);

        result = compiled.value.ir;
        types = compiled.value.ir.types;
    }

    const native_modules = @import("module_native.zig").merge(allocator, calls.items, types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        const failed = try target.failure(allocator, .{ .path = options.owner, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "contract", .message = "RX calls contain conflicting native interfaces" });

        return .{ .diagnostic = failed.diagnostic };
    };

    for (calls.items) |*call| {
        call.callee.types = types;
        call.argument.types = types;
        call.argument.native_modules = native_modules;

        for ([_]zx.ir.Program{ call.callee, call.argument }) |program| {
            if (try frontend.validateIr(allocator, program)) |issue| return invalid(allocator, options, issue);
        }
    }

    if (result) |*program| {
        program.types = types;
        program.native_modules = native_modules;

        if (try frontend.validateIr(allocator, program.*)) |issue| return invalid(allocator, options, issue);
    }

    var program = @import("program.zig").lower(allocator, .{ .owner = options.owner, .types = types, .input_type = options.input_type, .output_type = options.output_type, .calls = calls.items, .result = result, .native_modules = native_modules }) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return invalid(allocator, options, .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "RX expression environment cannot be linked to the module program" });
    };

    var reporter: zx.Reporter = .{};

    program.output_ownership = frontend.analyzeOwnership(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return invalid(allocator, options, reporter.diagnostic.?);
    };

    if (try frontend.validateIr(allocator, program)) |issue| return invalid(allocator, options, issue);

    return .{ .contract = .{ .program = program, .types = types, .nominal_types = options.nominal_types, .input_type = options.input_type, .output_type = options.output_type, .calls = calls.items, .result = result, .native_modules = native_modules } };
}

fn diagnostic(allocator: std.mem.Allocator, owner: []const u8, issue: expression.Diagnostic) std.mem.Allocator.Error!Module.Value {
    const failed = try target.failure(allocator, .{ .path = owner, .location = issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });

    return .{ .diagnostic = failed.diagnostic };
}

fn invalid(allocator: std.mem.Allocator, options: Options, issue: zx.Diagnostic) std.mem.Allocator.Error!Module.Value {
    const failed = try target.failure(allocator, .{ .path = options.owner, .location = Module.locate(options.module, issue.span.start) orelse options.module.location, .code = @tagName(issue.code), .message = issue.message });

    return .{ .diagnostic = failed.diagnostic };
}
