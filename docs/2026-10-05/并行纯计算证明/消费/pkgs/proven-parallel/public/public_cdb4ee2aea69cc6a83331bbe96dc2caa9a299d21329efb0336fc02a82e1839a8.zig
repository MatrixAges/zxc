const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;
pub const Output = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!*const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    var parallel_allocator_6 = zx_parallel_allocator{ .child = allocator, };
    const parallel_input_8 = (in).value;

    const ParallelWorker_7 = struct {
        allocator: ((std).mem).Allocator,
        input: u8,
        result: anyerror!u8,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_a9730b37f60f138c8007ec0d9ce38cad36c3b4bd34e6e29d2c38fe2a602b285f")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_9 = ParallelWorker_7{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_8, .result = undefined, };
    const parallel_input_12 = (in).enabled;

    const ParallelWorker_11 = struct {
        allocator: ((std).mem).Allocator,
        input: bool,
        result: anyerror!bool,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_1563386adb966ab59f9e688e56b93cff0194d7cab4897f7f26a69d1879a2c57d")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_13 = ParallelWorker_11{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_12, .result = undefined, };
    const parallel_input_16 = (in).value;

    const ParallelWorker_15 = struct {
        allocator: ((std).mem).Allocator,
        input: u8,
        result: anyerror!u8,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_56344588f2c34e943d538b86cfa8ebbd9a9c25fb7bf7f8dc3c9ee908e1d23229")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_17 = ParallelWorker_15{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_16, .result = undefined, };

    {
        const parallel_thread_10 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_7).run, .{ (&parallel_worker_9), }));

        defer (parallel_thread_10).join();

        const parallel_thread_14 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_11).run, .{ (&parallel_worker_13), }));

        defer (parallel_thread_14).join();

        const parallel_thread_18 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_15).run, .{ (&parallel_worker_17), }));

        defer (parallel_thread_18).join();
    }

    const value_1 = (try (parallel_worker_9).result);
    const value_2 = (try (parallel_worker_13).result);

    _ = (try (parallel_worker_17).result);

    return block_5: {
        const operand_1 = value_1;
        const operand_2 = value_2;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create((zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3));

            (operand_3).* = @as((zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3, (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3{ .value = operand_1, .enabled = operand_2, });

            break :block_4 @as(*const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3, operand_3);
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

