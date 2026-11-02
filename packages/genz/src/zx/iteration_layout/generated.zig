const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
pub const Boundary = struct { type_id: ir.TypeId, result: ir.ExprId };

pub const Type = if (@import("genz_options").generated_analysis)
    std.meta.Child(@FieldType(std.meta.Child(@import("generated_function_facts").Output), "layout_types"))

else
    u8;

pub const Property = if (@import("genz_options").generated_analysis)
    @FieldType(std.meta.Child(@import("generated_layout_query").Input), "property")

else
    u8;

pub fn query(value: Type, property: Property) bool {
    const values = comptime queries();

    return values[@backingInt(value)][@backingInt(property)];
}

fn queries() [@typeInfo(Type).@"enum".field_names.len][@typeInfo(Property).@"enum".field_names.len]bool {
    const generated = @import("generated_layout_query");
    var values: [@typeInfo(Type).@"enum".field_names.len][@typeInfo(Property).@"enum".field_names.len]bool = undefined;

    for (std.enums.values(Type)) |value| {
        for (std.enums.values(Property)) |property| {
            const input: std.meta.Child(generated.Input) = .{ .value = value, .property = property };

            values[@backingInt(value)][@backingInt(property)] = generated.executeValue(std.heap.page_allocator, &input) catch unreachable;
        }
    }

    return values;
}

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

pub fn buffers(allocator: std.mem.Allocator, program: *const ir.Program, iteration: ir.Iteration, allowed: []const bool, flags: []const @import("../uniqueness/root.zig").Flags) std.mem.Allocator.Error!bool {
    const generated = @import("generated_iteration_buffers");
    const Input = std.meta.Child(generated.Input);
    const Source = std.meta.Child(@FieldType(Input, "source"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Source, "types")), program.types);
    const roots = [_]u32{ @backingInt(iteration.condition), @backingInt(iteration.body) };

    const source: Source = .{
        .types = &types,
        .expressions = zx.columns.pointer(@FieldType(Source, "expressions"), &program.expressions),
        .function_inputs = zx.columns.slice(@FieldType(Source, "function_inputs"), program.functions.input_types),
        .function_outputs = zx.columns.slice(@FieldType(Source, "function_outputs"), program.functions.output_types),
        .allowed = allowed,
        .roots = &roots,
        .deep = true,
        .boundary = null,
    };

    const input: Input = .{
        .source = &source,
        .flags = std.mem.sliceAsBytes(flags),
        .parameter = @backingInt(iteration.parameter),
        .condition_parameter = @backingInt(iteration.condition_parameter),
        .symbol_count = program.symbols.count(),
        .state_type = @backingInt(program.expression(iteration.initial).type_id),
    };

    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    return generated.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
