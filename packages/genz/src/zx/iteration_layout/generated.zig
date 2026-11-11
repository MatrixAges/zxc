const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
pub const Boundary = struct { type_id: ir.TypeId, result: ir.ExprId };
const Layout = std.meta.Child(@import("generated_iteration_layout").Input);
const Types = std.meta.Child(@FieldType(Layout, "types"));

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

            values[@backingInt(value)][@backingInt(property)] = zx.columns.invoke(generated.executeValue, std.heap.page_allocator, &input) catch unreachable;
        }
    }

    return values;
}

pub fn analyze(allocator: std.mem.Allocator, program: *const ir.Program, roots: []const ir.ExprId, allowed: []const bool, deep: bool, boundary: ?Boundary) std.mem.Allocator.Error!bool {
    const generated = @import("generated_iteration_layout");
    const types = ir.TypeTable.borrow(Types, program.types);
    var input = source(program, &types, roots, allowed, deep);

    input.boundary = if (boundary) |value| &.{ .type_id = @backingInt(value.type_id), .result = @backingInt(value.result) } else null;

    return run(generated, allocator, &input);
}

pub fn forwarded(allocator: std.mem.Allocator, program: *const ir.Program, iteration: ir.Iteration, pure: []const bool, values: []const bool) std.mem.Allocator.Error!?ir.ExprId {
    const generated = @import("generated_iteration_forwarding");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(Types, program.types);
    const layout = source(program, &types, &.{iteration.condition}, pure, false);

    const input: Input = .{
        .source = &layout,
        .body = @backingInt(iteration.body),
        .parameter = @backingInt(iteration.parameter),
        .value_functions = values,
    };

    const selected = try run(generated, allocator, &input);

    return if (selected) |id| @fromBackingInt(id) else null;
}

pub fn abi(allocator: std.mem.Allocator, program: *const ir.Program, iteration: ir.Iteration, type_id: ir.TypeId, safe: []const bool) std.mem.Allocator.Error!bool {
    const generated = @import("generated_iteration_abi");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(Types, program.types);
    const layout = source(program, &types, &.{ iteration.condition, iteration.body }, safe, true);
    const input: Input = .{ .source = &layout, .type_id = @backingInt(type_id) };

    return run(generated, allocator, &input);
}

fn source(program: *const ir.Program, types: *const Types, roots: []const ir.ExprId, allowed: []const bool, deep: bool) Layout {
    comptime std.debug.assert(@typeInfo(ir.ExprId).@"enum".tag_type == u32);

    return .{
        .types = types,
        .expressions = zx.columns.pointer(@FieldType(Layout, "expressions"), &program.expressions),
        .function_inputs = zx.columns.slice(@FieldType(Layout, "function_inputs"), program.functions.input_types),
        .function_outputs = zx.columns.slice(@FieldType(Layout, "function_outputs"), program.functions.output_types),
        .allowed = allowed,
        .roots = @as([*]const u32, @ptrCast(roots.ptr))[0..roots.len],
        .deep = deep,
        .boundary = null,
    };
}

pub fn buffers(allocator: std.mem.Allocator, program: *const ir.Program, iteration: ir.Iteration, allowed: []const bool, flags: []const @import("../uniqueness/root.zig").Flags) std.mem.Allocator.Error!bool {
    const generated = @import("generated_iteration_buffers");
    const Input = std.meta.Child(generated.Input);
    const types = ir.TypeTable.borrow(Types, program.types);
    const layout = source(program, &types, &.{ iteration.condition, iteration.body }, allowed, true);

    const input: Input = .{
        .source = &layout,
        .flags = std.mem.sliceAsBytes(flags),
        .parameter = @backingInt(iteration.parameter),
        .condition_parameter = @backingInt(iteration.condition_parameter),
        .symbol_count = program.symbols.count(),
        .state_type = @backingInt(program.expression(iteration.initial).type_id),
    };

    return run(generated, allocator, &input);
}

fn run(comptime generated: type, allocator: std.mem.Allocator, input: generated.Input) std.mem.Allocator.Error!@typeInfo(@typeInfo(@TypeOf(generated.executeValue)).@"fn".return_type.?).error_union.payload {
    var scratch = std.heap.ArenaAllocator.init(allocator);

    defer scratch.deinit();

    return generated.executeValue(scratch.allocator(), input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };
}
