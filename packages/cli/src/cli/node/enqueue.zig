const std = @import("std");
const application = @import("application");
const napi = @import("zxc_napi");
const api = napi.api;
const Context = @import("context.zig");
const Task = @import("task.zig");
const stateful = @import("root").stateful;

pub fn callback(env: api.Env, info: api.Info) callconv(.c) api.Value {
    return enqueue(env, info) catch |err| napi.fail(env, err);
}

fn enqueue(env: api.Env, info: api.Info) !api.Value {
    var arguments: [4]api.Value = undefined;
    var count: usize = arguments.len;
    var data: ?*anyopaque = null;

    try napi.check(api.napi_get_cb_info(env, info, &count, &arguments, null, &data));

    const input_count: usize = if (application.Input == void) 0 else 1;

    if (count != input_count + 2) return error.InvalidArgumentCount;

    const context: *Context = @ptrCast(@alignCast(data.?));

    if (context.closing) return error.EnvironmentClosing;
    if (context.busy) return error.ReentrantInvocation;

    context.busy = true;
    defer context.busy = false;

    for (arguments[input_count..count]) |callback_value| {
        var kind: api.Kind = undefined;

        try napi.check(api.napi_typeof(env, callback_value, &kind));
        if (kind != .function) return error.ExpectedFunction;
    }

    var undefined_value: api.Value = null;

    try napi.check(api.napi_get_undefined(env, &undefined_value));

    const task = try std.heap.page_allocator.create(Task);
    task.* = .{ .context = context, .arena = std.heap.ArenaAllocator.init(std.heap.page_allocator) };

    context.retain();
    errdefer task.destroy();

    task.input = try napi.read(application.Input, application.input_shape, task.arena.allocator(), env, if (input_count == 0) null else arguments[0]);

    try napi.check(api.napi_create_reference(env, arguments[input_count], 1, &task.resolve));
    try napi.check(api.napi_create_reference(env, arguments[input_count + 1], 1, &task.reject));

    var name: api.Value = null;

    try napi.check(api.napi_create_string_utf8(env, "zxc.execute", 11, &name));
    try napi.check(api.napi_create_async_work(env, null, name, Task.execute, Task.complete, task, &task.work));

    if (stateful and context.running) {
        if (context.tail) |tail| tail.next = task else context.head = task;

        context.tail = task;
    } else {
        try task.start();
        if (stateful) context.running = true;
    }

    return undefined_value;
}
