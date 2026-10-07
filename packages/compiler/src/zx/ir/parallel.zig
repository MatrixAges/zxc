const std = @import("std");
const ir = @import("zx").ir;
const options = @import("parser_options");
const borrow = @import("canonical/borrow.zig");
const input = @import("canonical/functions/input.zig");

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    values: []const bool,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    if (comptime !options.generated_parser) {
        const values = try @import("seed_parallel.zig").functions(arena.allocator(), program);

        return .{ .arena = arena, .values = values };
    }

    const generated = @import("generated_ir_functions");
    const Input = std.meta.Child(generated.Input);
    const view = input.view(Input, program.functions);

    const values = generated.execute(&arena, &view) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .arena = arena, .values = values };
}

pub fn programPure(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (comptime !options.generated_parser) return @import("seed_parallel.zig").programPure(allocator, program);

    const generated = @import("generated_ir_program_pure");
    const Input = std.meta.Child(generated.Input);
    const Functions = std.meta.Child(@FieldType(Input, "functions"));
    const functions_view = input.view(Functions, program.functions);

    const view: Input = .{
        .functions = &functions_view,
        .stores = borrow.pointer(@FieldType(Input, "stores"), &program.stores),
        .expressions = borrow.pointer(@FieldType(Input, "expressions"), &program.expressions),
    };

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return generated.execute(&arena, &view) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return false,
    };
}
