const std = @import("std");
const ir = @import("zx").ir;

pub fn reachable(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const needed = try allocator.alloc(bool, program.functions.count());

    @memset(needed, false);
    markRoot(needed, program);
    close(needed, program.functions);

    return needed;
}

/// Marks the functions `program`'s own body calls.
pub fn markRoot(needed: []bool, program: ir.Program) void {
    mark(needed, program.expressions, program.contracts);
}

/// Extends `needed` to every function a needed function calls; callees precede their callers.
pub fn close(needed: []bool, functions: ir.FunctionTable) void {
    var index = functions.count();

    while (index != 0) {
        index -= 1;

        if (!needed[index]) continue;

        const function = functions.at(index);

        mark(needed, function.expressions, function.contracts);
    }
}

fn mark(needed: []bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable) void {
    for (0..expressions.count()) |expression_index| {
        if (expressions.callee(expression_index)) |function| needed[@backingInt(function)] = true;
    }

    for (contracts.expressions) |expressions_table| mark(needed, expressions_table.*, .{});
}

/// The names of the functions a body calls, each once, in name order.
pub fn imports(allocator: std.mem.Allocator, expressions: ir.ExpressionTable, contracts: ir.ContractTable, function_names: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    var seen: @import("zx").bytes.Map(void) = .empty;
    var output: std.ArrayList([]const u8) = .empty;

    try called(allocator, &seen, &output, expressions, contracts, function_names);

    std.mem.sort([]const u8, output.items, {}, lessThan);

    return output.toOwnedSlice(allocator);
}

fn called(allocator: std.mem.Allocator, seen: *@import("zx").bytes.Map(void), output: *std.ArrayList([]const u8), expressions: ir.ExpressionTable, contracts: ir.ContractTable, function_names: []const []const u8) std.mem.Allocator.Error!void {
    for (0..expressions.count()) |expression_index| {
        const function = expressions.callee(expression_index) orelse continue;
        const name = function_names[@backingInt(function)];

        if (!(try seen.getOrPut(allocator, name)).found_existing) try output.append(allocator, name);
    }

    for (contracts.expressions) |expressions_table| try called(allocator, seen, output, expressions_table.*, .{}, function_names);
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
