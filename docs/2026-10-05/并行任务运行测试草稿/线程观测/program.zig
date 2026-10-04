const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const u64;
pub const Output = *const (zx_abi).zx_type_13;

fn function_0(allocator: ((std).mem).Allocator, in: []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_8: {
        break :block_8 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const tuple_1 = block_7: {
        const operand_2 = value_1;
        const operand_3 = in;
        const operand_4 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_2).len, (operand_3).len))));

        @memcpy((operand_4)[0..(operand_2).len], operand_2);
        @memcpy((operand_4)[(operand_2).len..], operand_3);

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_5).* = @as((zx_abi).zx_type_12, .{ operand_4, {}, });

            break :block_6 @as(*const (zx_abi).zx_type_12, operand_5);
        };
    };

    const value_2 = (tuple_1).@"0";

    return value_2;
}

fn function_1(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = (in).@"0";
    const value_2: []const u64 = (try function_0(allocator, value_1));

    return value_2;
}

fn function_2(allocator: ((std).mem).Allocator, in: []const u64) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = block_8: {
        break :block_8 (try (allocator).dupe(u64, (&[_]u64{})));
    };

    const tuple_1 = block_7: {
        const operand_2 = value_1;
        const operand_3 = in;
        const operand_4 = (try (allocator).alloc(u64, (try ((std).math).add(usize, (operand_2).len, (operand_3).len))));

        @memcpy((operand_4)[0..(operand_2).len], operand_2);
        @memcpy((operand_4)[(operand_2).len..], operand_3);

        break :block_7 block_6: {
            const operand_5 = (try (allocator).create((zx_abi).zx_type_12));

            (operand_5).* = @as((zx_abi).zx_type_12, .{ operand_4, {}, });

            break :block_6 @as(*const (zx_abi).zx_type_12, operand_5);
        };
    };

    const value_2 = (tuple_1).@"0";

    return value_2;
}

fn function_3(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) anyerror![]const u64 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = (in).@"0";
    const value_2: []const u64 = (try function_2(allocator, value_1));

    return value_2;
}

fn function_4(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_14) anyerror!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const value_1: []const u64 = (in).@"0";
    var parallel_allocator_6 = zx_parallel_allocator{ .child = allocator, };

    const parallel_input_8 = block_13: {
        const operand_10 = value_1;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_11).* = @as((zx_abi).zx_type_14, .{ operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_14, operand_11);
        };
    };

    const ParallelWorker_7 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_14,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = function_1((self).allocator, (self).input);
        }
    };

    var parallel_worker_9 = ParallelWorker_7{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_8, .result = undefined, };

    const parallel_input_16 = block_21: {
        const operand_18 = value_1;

        break :block_21 block_20: {
            const operand_19 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_19).* = @as((zx_abi).zx_type_14, .{ operand_18, });

            break :block_20 @as(*const (zx_abi).zx_type_14, operand_19);
        };
    };

    const ParallelWorker_15 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_14,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = function_3((self).allocator, (self).input);
        }
    };

    var parallel_worker_17 = ParallelWorker_15{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_16, .result = undefined, };

    {
        const parallel_thread_14 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_7).run, .{ (&parallel_worker_9), }));

        defer (parallel_thread_14).join();

        const parallel_thread_22 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_15).run, .{ (&parallel_worker_17), }));

        defer (parallel_thread_22).join();
    }

    const value_2 = (try (parallel_worker_9).result);
    const value_3 = (try (parallel_worker_17).result);

    return block_5: {
        const operand_1 = value_2;
        const operand_2 = value_3;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_13));

            (operand_3).* = @as((zx_abi).zx_type_13, (zx_abi).zx_type_13{ .left = operand_1, .right = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_13, operand_3);
        };
    };
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const (zx_abi).zx_type_13 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    var parallel_allocator_1 = zx_parallel_allocator{ .child = allocator, };

    const parallel_input_3 = block_8: {
        const operand_5 = in;

        break :block_8 block_7: {
            const operand_6 = (try (allocator).create((zx_abi).zx_type_14));

            (operand_6).* = @as((zx_abi).zx_type_14, .{ operand_5, });

            break :block_7 @as(*const (zx_abi).zx_type_14, operand_6);
        };
    };

    const ParallelWorker_2 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_14,
        result: anyerror!*const (zx_abi).zx_type_13,
        fn run(self: *@This()) void {
            (self).result = function_4((self).allocator, (self).input);
        }
    };

    var parallel_worker_4 = ParallelWorker_2{ .allocator = (parallel_allocator_1).allocator(), .input = parallel_input_3, .result = undefined, };

    {
        const parallel_thread_9 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_2).run, .{ (&parallel_worker_4), }));

        defer (parallel_thread_9).join();
    }

    const value_1 = (try (parallel_worker_4).result);

    return value_1;
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
