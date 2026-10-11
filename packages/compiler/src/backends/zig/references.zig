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
        const expression = expressions.at(expression_index);

        if (expression.value == .call) {
            needed[@backingInt(expression.value.call.function)] = true;
        }
    }

    for (contracts.expressions) |expressions_table| mark(needed, expressions_table.*, .{});
}

pub fn imports(allocator: std.mem.Allocator, expressions: ir.ExpressionTable, contracts: ir.ContractTable, function_names: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
    const used = try allocator.alloc(bool, function_names.len);

    @memset(used, false);
    mark(used, expressions, contracts);

    var seen: std.StringHashMapUnmanaged(void) = .empty;
    var output: std.ArrayList([]const u8) = .empty;

    for (used, function_names) |required, name| {
        if (!required) continue;

        const entry = try seen.getOrPut(allocator, name);

        if (!entry.found_existing) try output.append(allocator, name);
    }

    std.mem.sort([]const u8, output.items, {}, lessThan);

    return output.toOwnedSlice(allocator);
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
