const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const seed = @import("topology/seed.zig");

pub const Calls = struct {
    callees: []const []const u32,
    recursive: []const bool,
};

pub const Plan = struct {
    callers: []const []const u64,
    known: []const bool,
};

pub fn collect(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Calls {
    if (!@import("genz_options").generated_analysis) return seed.collect(allocator, program);

    const generated = @import("generated_uniqueness_calls");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .expressions = zx.columns.slice(@FieldType(Input, "expressions"), program.functions.expressions),
        .native_modules = program.functions.native_modules,
        .entry = zx.columns.pointer(@FieldType(Input, "entry"), &program.expressions),
        .type_only = program.type_only,
    };

    const output = generated.executeValue(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("call topology failed: {s}", .{@errorName(err)}),
    };

    return .{
        .callees = output.callees,
        .recursive = output.recursive,
    };
}

pub fn build(allocator: std.mem.Allocator, called: []const []const u32, exported: []const ir.FunctionId) std.mem.Allocator.Error!Plan {
    if (!@import("genz_options").generated_analysis) return seed.build(allocator, called, exported);

    const generated = @import("generated_uniqueness_topology");
    const Input = std.meta.Child(generated.Input);
    const input: Input = .{ .callees = called, .exported = @ptrCast(exported) };

    const output = generated.executeValue(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("reverse topology failed: {s}", .{@errorName(err)}),
    };

    return .{ .callers = output.callers, .known = output.known };
}

pub fn callees(allocator: std.mem.Allocator, expressions: ir.ExpressionTable) std.mem.Allocator.Error![]const u32 {
    if (!@import("genz_options").generated_analysis) return seed.callees(allocator, expressions);

    const generated = @import("generated_uniqueness_callees");
    const Input = std.meta.Child(generated.Input);
    const input = zx.columns.pointer(*const Input, &expressions);

    return generated.executeValue(allocator, input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("call collection failed: {s}", .{@errorName(err)}),
    };
}
