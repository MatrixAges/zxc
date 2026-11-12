const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const Input = struct {
    file_name: []const u8,
    offset: usize,
    id: ir.FunctionId,
    types: ir.TypeTable,
    functions: ir.FunctionTable,
    native_modules: ir.NativeModuleTable,
};

pub fn build(allocator: std.mem.Allocator, input: Input) std.mem.Allocator.Error!ir.Program {
    const function = input.functions.at(@backingInt(input.id));
    const stores = try allocator.alloc(u32, function.stores.count());

    for (stores, 0..) |*slot, index| slot.* = @intCast(index);

    const span = zx.Span{ .start = input.offset, .end = input.offset };
    const is_void = function.input_type == @as(ir.TypeId, @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))));
    const symbols = try ir.SymbolTable.fromValues(allocator, &.{.{ .name = "$in", .type_id = function.input_type, .span = span }});

    const expressions = try ir.ExpressionTable.fromValues(allocator, &.{
        .{ .type_id = function.input_type, .span = span, .value = if (is_void) .unit else .{ .reference = @fromBackingInt(@intCast(0)) } },
        .{ .type_id = function.output_type, .span = span, .value = .{ .call = .{ .function = input.id, .argument = @fromBackingInt(@intCast(0)), .stores = stores } } },
    });

    return .{
        .file_name = input.file_name,
        .types = input.types,
        .stores = function.stores,
        .store_mode = function.store_mode,
        .input_type = function.input_type,
        .output_type = function.output_type,
        .output_ownership = function.output_ownership,
        .symbols = symbols,
        .expressions = expressions,
        .body = try ir.ControlBody.fromValues(allocator, &.{.{ .result = @fromBackingInt(@intCast(1)) }}),
        .functions = input.functions,
        .native_modules = input.native_modules,
    };
}

pub fn reject(function: ?ir.FunctionId, functions: *const ir.FunctionStorage, setter: bool) ?struct { code: []const u8, message: []const u8 } {
    return switch (@import("compiled_admission.zig").check(function, functions, setter)) {
        .Executable => null,
        .MissingFunction => .{ .code = "module", .message = "Call.module requires an executable public module" },
        .Setter => .{ .code = "capability", .message = "Call.module cannot grant a setter; Store authorization belongs inside the published RX module" },
        .Transaction => .{ .code = "capability", .message = "compiled Store transactions require an explicit authorized RX module" },
    };
}
