const std = @import("std");
const application = @import("application");
const napi = @import("zxc_napi");
const api = napi.api;
const State = if (stateful) @import("zxc_state") else void;

const Context = struct {
    arena: std.heap.ArenaAllocator,
    state: State = undefined,
    busy: bool = false,
    fn deinit(self: *@This()) void {
        if (stateful) self.state.deinit();

        self.arena.deinit();
        std.heap.page_allocator.destroy(self);
    }
};

comptime {
    if (application.requires_io or application.requires_process) @compileError("Node addons require an explicit host implementation for I/O and process capabilities");
}

export fn node_api_module_get_api_version_v1() i32 {
    return 6;
}

export fn napi_register_module_v1(env: api.Env, exports: api.Value) api.Value {
    return register(env, exports) catch |err| napi.fail(env, err);
}

fn register(env: api.Env, exports: api.Value) !api.Value {
    const context = try std.heap.page_allocator.create(Context);

    context.* = .{ .arena = std.heap.ArenaAllocator.init(std.heap.page_allocator) };

    if (stateful) context.state = .{ .arena = &context.arena };

    var attached = false;

    errdefer if (!attached) context.deinit();

    if (stateful) try context.state.initialize();

    var function: api.Value = null;

    try napi.check(api.napi_create_function(env, "execute", 7, callback, context, &function));
    try napi.check(api.napi_add_finalizer(env, function, context, finalize, null, null));

    attached = true;
    const property = api.Property{ .utf8name = "execute", .value = function };

    try napi.check(api.napi_define_properties(env, exports, 1, @ptrCast(&property)));

    return exports;
}

fn finalize(_: api.Env, data: ?*anyopaque, _: ?*anyopaque) callconv(.c) void {
    const context: *Context = @ptrCast(@alignCast(data.?));

    context.deinit();
}

fn callback(env: api.Env, info: api.Info) callconv(.c) api.Value {
    return execute(env, info) catch |err| napi.fail(env, err);
}

fn execute(env: api.Env, info: api.Info) !api.Value {
    var arguments: [2]api.Value = undefined;
    var count: usize = arguments.len;
    var data: ?*anyopaque = null;

    try napi.check(api.napi_get_cb_info(env, info, &count, &arguments, null, &data));

    const expected: usize = if (application.Input == void) 0 else 1;

    if (count != expected) return error.InvalidArgumentCount;

    const context: *Context = @ptrCast(@alignCast(data.?));

    if (context.busy) return error.ReentrantInvocation;

    context.busy = true;
    defer context.busy = false;

    if (stateful) {
        var request = context.state.request();

        defer request.deinit();

        const input = try napi.read(application.Input, application.input_shape, request.arena.allocator(), env, if (expected == 0) null else arguments[0]);
        const output = if (application.requires_io or application.requires_process) unreachable else try request.execute(input);

        return napi.write(application.output_shape, env, output);
    }

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const input = try napi.read(application.Input, application.input_shape, arena.allocator(), env, if (expected == 0) null else arguments[0]);
    const output = if (application.requires_io or application.requires_process) unreachable else try application.execute(&arena, input);

    return napi.write(application.output_shape, env, output);
}
