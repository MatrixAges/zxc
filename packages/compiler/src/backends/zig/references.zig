const std = @import("std");
const ir = @import("zx").ir;

pub fn reachable(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const needed = try allocator.alloc(bool, program.functions.len);

    @memset(needed, false);
    mark(needed, program.expressions, program.contracts);

    var index = program.functions.len;

    while (index != 0) {
        index -= 1;

        if (!needed[index]) continue;

        const function = program.functions[index];

        mark(needed, function.expressions, function.contracts);
    }

    return needed;
}

fn mark(needed: []bool, expressions: []const ir.Expression, contracts: []const ir.Contract) void {
    for (expressions) |expression| if (expression.value == .call) {
        needed[@intFromEnum(expression.value.call.function)] = true;
    };

    for (contracts) |contract| mark(needed, contract.expressions, &.{});
}

pub fn imports(allocator: std.mem.Allocator, expressions: []const ir.Expression, contracts: []const ir.Contract, function_names: []const []const u8) std.mem.Allocator.Error![]const []const u8 {
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
