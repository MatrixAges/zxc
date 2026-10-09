const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const State = @import("state.zig");
const compiled = frontend.project.compiled;

pub fn load(state: *State, target: compiled.Target, location: rx.ast.Location) State.Error!compiled.Export {
    var selected: ?usize = null;

    for (state.options.compiled_libraries, 0..) |library, index| {
        if (!std.mem.eql(u8, library.instance, target.instance)) continue;

        const path = try std.fs.path.resolve(state.allocator, &.{ state.options.root_dir, library.artifact });

        if (selected != null or !std.mem.eql(u8, path, target.artifact)) return state.fail(location, "compiled package instance has conflicting artifacts");

        selected = index;
    }

    const index = selected orelse return state.fail(location, "compiled library is missing from the input set");

    const exports = state.libraries.get(index) orelse block: {
        const loaded = compiled.loadInto(state.allocator, state.options.compiled_libraries[index], .{
            .types = &state.types.items,
            .origins = &state.types.origins,
            .functions = &state.functions,
            .native_modules = &state.native_modules,
        }) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return state.fail(location, "compiled library has invalid IR or conflicting identities");
        };

        try state.initializers.appendSlice(state.allocator, loaded.store_initializers);
        try state.libraries.put(state.allocator, index, loaded.exports);

        break :block loaded.exports;
    };

    for (exports) |exported| {
        if (std.mem.eql(u8, exported.name, target.name)) return exported;
    }

    return state.fail(location, "compiled library does not export this public module");
}
