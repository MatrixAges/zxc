const std = @import("std");
const application = @import("application");
const State = if (stateful) @import("zxc_state") else void;

const Request = if (stateful) State.Request else struct {
    arena: std.heap.ArenaAllocator,
    fn deinit(self: *@This()) void {
        self.arena.deinit();
    }
};

var state_arena = std.heap.ArenaAllocator.init(std.heap.wasm_allocator);
var state: State = undefined;
var initialized = false;
var request: ?Request = null;
var input_storage: []u8 = &.{};
var input: []u8 = &.{};
var result: []const u8 = &.{};
var ready = false;
var executing = false;

comptime {
    if (application.requires_io or application.requires_process) @compileError("freestanding WASM does not provide I/O or process capabilities; use wasm32-wasi for a command application");
}

export fn zxc_alloc(length: u32) u32 {
    if (executing) return 0;

    zxc_reset();

    const classes = @typeInfo(@FieldType(std.heap.BrkAllocator, "big_frees")).array.len;
    const largest_block = (@as(u64, 1) << (classes - 1)) * std.heap.page_size_max;
    const overhead = std.heap.page_size_max + 2 * @sizeOf(usize) - 1;

    if (@as(u64, length) + overhead > largest_block) {
        result = "OutOfMemory";

        return 0;
    }

    prepare() catch |err| {
        result = @errorName(err);

        return 0;
    };

    input_storage = std.heap.wasm_allocator.alloc(u8, @max(length, 1)) catch |err| {
        result = @errorName(err);

        return 0;
    };

    input = input_storage[0..length];
    ready = true;

    return @intFromPtr(input.ptr);
}

export fn zxc_execute() u32 {
    if (executing) return 2;

    if (!ready) {
        result = "InputNotPrepared";

        return 1;
    }

    ready = false;
    executing = true;

    defer executing = false;

    run() catch |err| {
        result = @errorName(err);

        return 1;
    };

    return 0;
}

export fn zxc_result_ptr() u32 {
    return @intFromPtr(result.ptr);
}

export fn zxc_result_len() u32 {
    return @intCast(result.len);
}

export fn zxc_reset() void {
    if (executing) return;
    if (request) |*value| value.deinit();

    std.heap.wasm_allocator.free(input_storage);

    request = null;
    input_storage = &.{};
    input = &.{};
    result = &.{};
    ready = false;
    scalar_ready = false;
}

export fn zxc_deinit() void {
    if (executing) return;

    zxc_reset();

    if (stateful and initialized) state.deinit();

    state_arena.deinit();

    state_arena = std.heap.ArenaAllocator.init(std.heap.wasm_allocator);
    initialized = false;
}

fn prepare() !void {
    if (stateful) {
        if (!initialized) {
            state = .{ .arena = &state_arena };

            state.initialize() catch |err| {
                state.deinit();

                _ = state_arena.reset(.free_all);

                return err;
            };

            initialized = true;
        }

        request = state.request();
    } else request = .{ .arena = std.heap.ArenaAllocator.init(std.heap.wasm_allocator) };
}

fn run() !void {
    const current = &request.?;
    const allocator = current.arena.allocator();

    const value: application.Input = if (application.Input == void) value: {
        if (input.len != 0) return error.ExpectedNoInput;

        break :value {};
    } else try std.json.parseFromSliceLeaky(application.Input, allocator, input, .{ .allocate = .alloc_always });

    const output = if (application.requires_io or application.requires_process) unreachable else if (stateful) try current.execute(value) else try application.execute(&current.arena, value);

    result = if (!@import("result.zig").emit) "" else if (application.Output == void) "null" else try std.json.Stringify.valueAlloc(allocator, output, .{});
}
