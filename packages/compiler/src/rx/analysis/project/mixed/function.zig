const zx = @import("zx");
const ir = zx.ir;
const State = @import("state.zig");

pub fn view(state: *State, id: ir.FunctionId, functions: ir.FunctionTable) State.Error!ir.Program {
    if (@backingInt(id) >= state.functions.count()) return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "resolved function is outside the shared function table");

    const function = state.functions.at(@backingInt(id));

    var program = ir.Program{
        .file_name = function.file_name,
        .types = state.types.items.view(),
        .input_type = function.input_type,
        .output_type = function.output_type,
        .output_ownership = function.output_ownership,
        .symbols = function.symbols,
        .expressions = function.expressions,
        .body = function.body,
        .contracts = function.contracts,
        .stores = function.stores,
        .store_mode = function.store_mode,
        .functions = functions,
        .native_modules = state.native_modules.view(),
    };

    if (function.external != null) {
        const span = zx.Span{ .start = 0, .end = 0 };
        const is_void = @backingInt(function.input_type) == @backingInt(ir.Scalar.void);

        program.symbols = try ir.SymbolTable.fromValues(state.allocator, &.{.{ .name = "$in", .type_id = function.input_type, .span = span }});

        program.expressions = try ir.ExpressionTable.fromValues(state.allocator, &.{
            .{ .type_id = function.input_type, .span = span, .value = if (is_void) .unit else .{ .reference = @fromBackingInt(0) } },
            .{ .type_id = function.output_type, .span = span, .value = .{ .call = .{ .function = id, .argument = @fromBackingInt(0) } } },
        });

        program.body = try ir.ControlBody.fromValues(state.allocator, &.{.{ .result = @fromBackingInt(1) }});
    }

    return program;
}
