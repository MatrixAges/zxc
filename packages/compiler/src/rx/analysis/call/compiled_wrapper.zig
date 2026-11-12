const std = @import("std");
const zx = @import("zx");
const frontend = @import("frontend");
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

    var program: ir.Program = .{
        .file_name = input.file_name,
        .types = input.types,
        .stores = function.stores,
        .store_mode = function.store_mode,
        .input_type = function.input_type,
        .output_type = function.output_type,
        .output_ownership = function.output_ownership,
        .symbols = .{},
        .expressions = .{},
        .body = .{},
        .functions = input.functions,
        .native_modules = input.native_modules,
    };

    try frontend.writeForwardEntry(allocator, &program, .{
        .id = input.id,
        .parameter = .{
            .name = "$in",
            .type_id = function.input_type,
            .span = .{ .start = input.offset, .end = input.offset },
        },
        .unit = @backingInt(function.input_type) == @backingInt(ir.Scalar.void),
        .store_types = function.stores.types,
    });

    return program;
}

pub fn reject(function: ?ir.FunctionId, functions: *const ir.FunctionStorage, setter: bool) ?struct { code: []const u8, message: []const u8 } {
    return switch (@import("compiled_admission.zig").check(function, functions, setter)) {
        .Executable => null,
        .MissingFunction => .{ .code = "module", .message = "Call.module requires an executable public module" },
        .Setter => .{ .code = "capability", .message = "Call.module cannot grant a setter; Store authorization belongs inside the published RX module" },
        .Transaction => .{ .code = "capability", .message = "compiled Store transactions require an explicit authorized RX module" },
    };
}
