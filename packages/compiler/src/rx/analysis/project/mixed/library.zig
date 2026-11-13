const frontend = @import("frontend");
const rx = @import("rx");
const State = @import("state.zig");
const compiled = frontend.project.compiled;

pub fn load(state: *State, target: compiled.Target, location: rx.ast.Location) State.Error!compiled.Export {
    const exported = compiled.imports.load(state.allocator, &state.options, target, .{
        .types = &state.types.items,
        .origins = &state.types.origins,
        .functions = &state.functions,
        .native_modules = &state.native_modules,
    }, &state.libraries, &state.initializers) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return state.fail(location, compiled.imports.message(err));
    };

    return exported.*;
}
