const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const expression = @import("expression.zig");
pub const target = @import("call/target.zig");

pub const Options = struct {
    target: target.Options,
    bindings: []const frontend.expressions.Binding = &.{},
};

pub const Invocation = struct {
    callee: zx.ir.Program,
    argument: zx.ir.Program,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
};

pub const Value = union(enum) { invocation: Invocation, diagnostic: target.Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn link(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try linkIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn linkIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Value {
    const config = options.target;
    const type_count = if (config.project.context.types.len == 0) std.enums.values(zx.ir.Scalar).len else config.project.context.types.len;

    for (options.bindings) |binding| {
        if (@intFromEnum(binding.type_id) >= type_count) {
            const failed = try target.failure(allocator, .{ .path = config.owner, .location = config.call.location, .code = "contract", .message = "call bindings must reference the supplied type table" });

            return .{ .diagnostic = failed.diagnostic };
        }
    }

    const loaded = try target.load(allocator, config);

    if (loaded.value == .diagnostic) return .{ .diagnostic = loaded.value.diagnostic };

    var callee = loaded.value.function.program;
    const compiled = try expression.compile(allocator, config.owner, target.attribute(config.call, "in"), .{ .types = callee.types, .bindings = options.bindings, .expected = callee.input_type });

    if (compiled.value == .diagnostic) {
        const issue = compiled.value.diagnostic;
        const failed = try target.failure(allocator, .{ .path = config.owner, .location = issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });

        return .{ .diagnostic = failed.diagnostic };
    }

    var argument = compiled.value.ir;

    callee.types = argument.types;
    argument.native_modules = callee.native_modules;

    return .{ .invocation = .{ .callee = callee, .argument = argument, .nominal_types = loaded.value.function.nominal_types } };
}
