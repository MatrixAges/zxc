const std = @import("std");

const zx_type_12 = struct {
    alternate: []const u64,
    first: u64,
    total: u64,
    values: []const u64,
};

const zx_type_13 = struct { []const u64, };
const zx_type_14 = struct { []const u64, u64, };
const zx_type_15 = struct { []const u64, []const u64, []const u64, u64, u64, };
pub const Input = []const u64;
pub const Output = *const zx_type_12;

fn function_0(allocator: ((std).mem).Allocator, in: []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    return block_3: {
        const operand_1 = in;
        var items_2: (std).ArrayList(u64) = .empty;

        for (operand_1) |value_1| {
            (try (items_2).append(allocator, (value_1 + @as(u64, 1))));
        }

        break :block_3 (try (items_2).toOwnedSlice(allocator));
    };
}

fn function_1(allocator: ((std).mem).Allocator, in: []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    return block_3: {
        const operand_1 = in;
        var items_2: (std).ArrayList(u64) = .empty;

        for (operand_1) |value_1| {
            (try (items_2).append(allocator, (value_1 + @as(u64, 1))));
        }

        break :block_3 (try (items_2).toOwnedSlice(allocator));
    };
}

fn function_2(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_2: {
        const operand_1 = in;
        var value_1: u64 = @as(u64, 0);

        for (operand_1) |value_2| {
            value_1 = (value_1 + value_2);
        }

        break :block_2 value_1;
    };
}

fn function_3(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return block_3: {
        const operand_1 = in;
        const operand_2 = @as(u64, 0);

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    };
}

fn function_4(allocator: ((std).mem).Allocator, in: []const u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: u64 = (try function_3(allocator, in));

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const zx_type_12 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    var parallel_allocator_8 = zx_parallel_allocator{ .child = allocator, };
    const parallel_input_10 = in;

    const ParallelWorker_9 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = function_0((self).allocator, (self).input);
        }
    };

    var parallel_worker_11 = ParallelWorker_9{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_10, .result = undefined, };
    const parallel_input_14 = in;

    const ParallelWorker_13 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = function_1((self).allocator, (self).input);
        }
    };

    var parallel_worker_15 = ParallelWorker_13{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_14, .result = undefined, };
    const parallel_input_18 = in;

    const ParallelWorker_17 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror!u64,
        fn run(self: *@This()) void {
            (self).result = function_2((self).allocator, (self).input);
        }
    };

    var parallel_worker_19 = ParallelWorker_17{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_18, .result = undefined, };
    const parallel_input_22 = in;

    const ParallelWorker_21 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror!u64,
        fn run(self: *@This()) void {
            (self).result = function_4((self).allocator, (self).input);
        }
    };

    var parallel_worker_23 = ParallelWorker_21{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_22, .result = undefined, };

    {
        const parallel_thread_12 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_9).run, .{ (&parallel_worker_11), }));

        defer (parallel_thread_12).join();

        const parallel_thread_16 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_13).run, .{ (&parallel_worker_15), }));

        defer (parallel_thread_16).join();

        const parallel_thread_20 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_17).run, .{ (&parallel_worker_19), }));

        defer (parallel_thread_20).join();

        const parallel_thread_24 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_21).run, .{ (&parallel_worker_23), }));

        defer (parallel_thread_24).join();
    }

    const value_1 = (try (parallel_worker_11).result);
    const value_2 = (try (parallel_worker_15).result);
    const value_3 = (try (parallel_worker_19).result);
    const value_4 = (try (parallel_worker_23).result);

    return block_7: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_3;
        const operand_4 = value_4;

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create(zx_type_12));

            (operand_5).* = @as(zx_type_12, zx_type_12{ .values = operand_1, .alternate = operand_2, .total = operand_3, .first = operand_4, });

            break :block_6 @as(*const zx_type_12, operand_5);
        };
    };
}

const zx_parallel_allocator = struct {
    child: std.mem.Allocator,
    mutex: std.Io.Mutex = .init,
    fn allocator(self: *@This()) std.mem.Allocator {
        return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
    }
    fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
        const self: *@This() = @ptrCast(@alignCast(context));

        std.Io.Threaded.mutexLock(&self.mutex);
        defer std.Io.Threaded.mutexUnlock(&self.mutex);

        return self.child.rawAlloc(len, alignment, ret_addr);
    }
    fn resize(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) bool {
        const self: *@This() = @ptrCast(@alignCast(context));

        std.Io.Threaded.mutexLock(&self.mutex);
        defer std.Io.Threaded.mutexUnlock(&self.mutex);

        return self.child.rawResize(memory, alignment, len, ret_addr);
    }
    fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) ?[*]u8 {
        const self: *@This() = @ptrCast(@alignCast(context));

        std.Io.Threaded.mutexLock(&self.mutex);
        defer std.Io.Threaded.mutexUnlock(&self.mutex);

        return self.child.rawRemap(memory, alignment, len, ret_addr);
    }
    fn free(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
        const self: *@This() = @ptrCast(@alignCast(context));

        std.Io.Threaded.mutexLock(&self.mutex);
        defer std.Io.Threaded.mutexUnlock(&self.mutex);
        self.child.rawFree(memory, alignment, ret_addr);
    }
};
