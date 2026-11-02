const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const abi = @import("function_analysis/abi.zig");
const seed = @import("references/seed.zig");

comptime {
    std.debug.assert(@typeInfo(ir.FunctionId).@"enum".tag_type == u32);
}

pub fn reachable(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    return discover(allocator, workspace, program.functions, &.{&program}, &.{});
}

pub fn discover(allocator: std.mem.Allocator, workspace: std.mem.Allocator, functions: ir.FunctionTable, roots: []const *const ir.Program, members: []const ir.FunctionId) std.mem.Allocator.Error![]const bool {
    if (!@import("genz_options").generated_analysis) {
        const needed = try allocator.alloc(bool, functions.count());

        @memset(needed, false);

        for (roots) |program| seed.markRoot(needed, program.*);
        for (members) |id| needed[@backingInt(id)] = true;

        seed.close(needed, functions);

        return needed;
    }

    const generated = @import("generated_reference_graph");
    const Input = std.meta.Child(generated.Input);
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const Bodies = abi.List(@FieldType(Input, "roots"));
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const bodies = try Bodies.init(temporary, roots.len);

    for (bodies.values, roots) |*body, program| body.* = .{
        .expressions = zx.columns.pointer(@FieldType(Bodies.Value, "expressions"), &program.expressions),
        .contracts = zx.columns.pointer(@FieldType(Bodies.Value, "contracts"), &program.contracts),
    };

    const table = Functions{
        .expressions = zx.columns.slice(@FieldType(Functions, "expressions"), functions.expressions),
        .contracts = zx.columns.slice(@FieldType(Functions, "contracts"), functions.contracts),
    };

    const input = Input{
        .functions = &table,
        .roots = try bodies.finish(temporary),
        .members = @as([*]const u32, @ptrCast(members.ptr))[0..members.len],
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(bool, output);
}

pub fn imports(allocator: std.mem.Allocator, workspace: std.mem.Allocator, expressions: ir.ExpressionTable, contracts: ir.ContractTable, names: []const []const u8, members: []const ir.FunctionId) std.mem.Allocator.Error![]const []const u8 {
    if (!@import("genz_options").generated_analysis) return seed.importsWithMembers(allocator, expressions, contracts, names, members);

    const generated = @import("generated_reference_imports");
    const Input = std.meta.Child(generated.Input);
    const Body = std.meta.Child(@FieldType(Input, "body"));
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();

    const body = Body{
        .expressions = zx.columns.pointer(@FieldType(Body, "expressions"), &expressions),
        .contracts = zx.columns.pointer(@FieldType(Body, "contracts"), &contracts),
    };

    const input = Input{
        .body = &body,
        .names = names,
        .members = @as([*]const u32, @ptrCast(members.ptr))[0..members.len],
    };

    const output = generated.executeIn(temporary, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe([]const u8, output);
}
