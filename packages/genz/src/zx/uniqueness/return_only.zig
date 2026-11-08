const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn create(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    if (!@import("genz_options").generated_analysis) return seed(allocator, program);

    const generated = @import("generated_uniqueness_return_only");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    var input: Input = undefined;

    inline for (@typeInfo(Input).@"struct".field_names) |name| {
        @field(input, name) = zx.columns.slice(@FieldType(Input, name), @field(program.functions, name));
    }

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(bool, output);
}

fn seed(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const result = try allocator.alloc(bool, program.functions.count());
    const calls = @import("../entry_flags/seed.zig");

    for (result, 0..) |*value, index| {
        const function = program.functions.at(index);

        value.* = function.external == null and function.stores.count() == 0 and
            std.mem.indexOfScalar(std.meta.Child(@FieldType(ir.ControlTable, "statement_kinds")), function.body.control.statement_kinds, .Parallel) == null and
            calls.calls(function.expressions, function.contracts, result[0..index]);
    }

    return result;
}
