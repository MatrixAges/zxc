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

    if (function.external != null) try @import("frontend").writeExternalEntry(state.allocator, &program, id);

    return program;
}
