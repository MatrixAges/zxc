const std = @import("std");
const application = @import("application");
const napi = @import("zxc_napi");
const api = napi.api;
const Context = @import("context.zig");
const stateful = @import("root").stateful;
const Request = if (stateful) @import("zxc_state").Request else void;
const Self = @This();

context: *Context,
arena: std.heap.ArenaAllocator,
input: application.Input = undefined,
output: anyerror!application.Output = error.WorkNotExecuted,
request: ?Request = null,
work: api.Work = null,
resolve: api.Ref = null,
reject: api.Ref = null,
next: ?*Self = null,
pub fn destroy(self: *Self) void {
    const context = self.context;
    const env = context.env;

    if (self.work != null) _ = api.napi_delete_async_work(env, self.work);
    if (self.resolve != null) _ = api.napi_delete_reference(env, self.resolve);
    if (self.reject != null) _ = api.napi_delete_reference(env, self.reject);
    if (stateful) if (self.request) |*request| request.deinit();

    self.arena.deinit();
    std.heap.page_allocator.destroy(self);
    context.release();
}

pub fn start(self: *Self) !void {
    try napi.check(api.napi_queue_async_work(self.context.env, self.work));
}

pub fn execute(_: api.Env, data: ?*anyopaque) callconv(.c) void {
    const self: *Self = @ptrCast(@alignCast(data.?));

    if (stateful) {
        self.request = self.context.state.request();
        self.request.?.arena = self.arena;
        self.arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        self.output = self.request.?.execute(self.input);
    } else self.output = application.execute(&self.arena, self.input);
}

pub fn complete(env: api.Env, status: api.Status, data: ?*anyopaque) callconv(.c) void {
    const self: *Self = @ptrCast(@alignCast(data.?));
    const context = self.context;

    context.retain();
    defer context.release();

    context.busy = true;
    defer context.busy = false;

    if (status != .ok) self.output = error.AsyncWorkCancelled;

    settle(self, env) catch context.close();
    self.destroy();

    if (stateful) while (context.head) |next| {
        context.head = next.next;

        if (context.head == null) context.tail = null;

        next.start() catch |err| {
            next.output = err;

            settle(next, env) catch context.close();
            next.destroy();

            continue;
        };

        return;
    };

    context.running = false;
}

fn settle(self: *Self, env: api.Env) !void {
    if (self.context.closing) return;

    const result = if (self.output) |output| napi.write(application.output_shape, env, output) else |err| err;
    var value: api.Value = null;
    var reference = self.resolve;

    if (result) |output| {
        value = output;
    } else |err| {
        reference = self.reject;

        var pending = false;

        try napi.check(api.napi_is_exception_pending(env, &pending));

        if (pending) {
            try napi.check(api.napi_get_and_clear_last_exception(env, &value));
        } else {
            var message: api.Value = null;
            const name = @errorName(err);

            try napi.check(api.napi_create_string_utf8(env, name.ptr, name.len, &message));
            try napi.check(api.napi_create_error(env, null, message, &value));
        }
    }

    var callback: api.Value = null;
    var receiver: api.Value = null;
    var ignored: api.Value = null;

    try napi.check(api.napi_get_reference_value(env, reference, &callback));
    try napi.check(api.napi_get_undefined(env, &receiver));
    try napi.check(api.napi_call_function(env, receiver, callback, 1, &.{value}, &ignored));
}
