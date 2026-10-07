const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const ownership = @import("check.zig");

pub fn check(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (try @import("../ir/validate.zig").validate(allocator, program) != null) return false;
    if (!try independent(allocator, program)) return false;

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);

        if (function.external != null or function.stores.count() == 0) continue;

        var child = program;
        child.type_only = false;
        child.input_type = function.input_type;
        child.output_type = function.output_type;
        child.output_ownership = function.output_ownership;
        child.symbols = function.symbols;
        child.expressions = function.expressions;
        child.body = function.body;
        child.contracts = function.contracts;
        child.stores = function.stores;
        child.store_mode = function.store_mode;

        if (!try independent(allocator, child)) return false;
    }

    return true;
}

fn independent(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    var reporter: zx.Reporter = .{};

    const result = ownership.facts(allocator, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return false;
    };

    return result.stores_owned;
}
