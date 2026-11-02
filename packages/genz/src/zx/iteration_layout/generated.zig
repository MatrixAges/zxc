const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const Boundary = struct { type_id: ir.TypeId, result: ir.ExprId };

pub fn analyze(allocator: std.mem.Allocator, program: *const ir.Program, roots: []const ir.ExprId, allowed: []const bool, deep: bool, boundary: ?Boundary) std.mem.Allocator.Error!bool {
    comptime std.debug.assert(@typeInfo(ir.ExprId).@"enum".tag_type == u32);

    const generated = @import("generated_iteration_layout");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);

    const input: Input = .{
        .types = &types,
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .function_inputs = zx.columns.slice(@FieldType(Input, "function_inputs"), program.functions.input_types),
        .function_outputs = zx.columns.slice(@FieldType(Input, "function_outputs"), program.functions.output_types),
        .allowed = allowed,
        .roots = @as([*]const u32, @ptrCast(roots.ptr))[0..roots.len],
        .deep = deep,
        .boundary = if (boundary) |value| &.{ .type_id = @backingInt(value.type_id), .result = @backingInt(value.result) } else null,
    };

    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    return generated.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
