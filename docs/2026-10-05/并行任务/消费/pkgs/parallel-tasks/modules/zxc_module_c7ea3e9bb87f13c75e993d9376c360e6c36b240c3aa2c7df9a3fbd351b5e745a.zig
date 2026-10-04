const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_fafd1b91d62c9a6984327f86dea93b220494fa07316cc24250b154611bafd37a) anyerror!bool {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3 = (in).@"0";
    const value_2: u8 = (in).@"1";
    const switch_1 = (value_1).enabled;

    if ((switch_1 == true)) {
        var parallel_allocator_2 = zx_parallel_allocator{ .child = allocator, };

        const parallel_input_4 = block_9: {
            const operand_6 = value_1;

            break :block_9 block_8: {
                const operand_7 = (try (allocator).create((zx_abi).zx_type_e52f9211d8f6044cb4f813c095aa621a601cd429170dd46684f5e602d4e0321f));

                (operand_7).* = @as((zx_abi).zx_type_e52f9211d8f6044cb4f813c095aa621a601cd429170dd46684f5e602d4e0321f, .{ operand_6, });

                break :block_8 @as(*const (zx_abi).zx_type_e52f9211d8f6044cb4f813c095aa621a601cd429170dd46684f5e602d4e0321f, operand_7);
            };
        };

        const ParallelWorker_3 = struct {
            allocator: ((std).mem).Allocator,
            input: *const (zx_abi).zx_type_e52f9211d8f6044cb4f813c095aa621a601cd429170dd46684f5e602d4e0321f,
            result: anyerror!bool,
            fn run(self: *@This()) void {
                (self).result = (@import("zxc_module_98fd8fd6cc800706cf3eedaa54670f0670d77d485f6fdb90c95fc741b06e49be")).call((self).allocator, (self).input);
            }
        };

        var parallel_worker_5 = ParallelWorker_3{ .allocator = (parallel_allocator_2).allocator(), .input = parallel_input_4, .result = undefined, };
        const parallel_input_12 = value_2;

        const ParallelWorker_11 = struct {
            allocator: ((std).mem).Allocator,
            input: u8,
            result: anyerror!u8,
            fn run(self: *@This()) void {
                (self).result = (@import("zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368")).call((self).allocator, (self).input);
            }
        };

        var parallel_worker_13 = ParallelWorker_11{ .allocator = (parallel_allocator_2).allocator(), .input = parallel_input_12, .result = undefined, };

        {
            const parallel_thread_10 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_3).run, .{ (&parallel_worker_5), }));

            defer (parallel_thread_10).join();

            const parallel_thread_14 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_11).run, .{ (&parallel_worker_13), }));

            defer (parallel_thread_14).join();
        }

        const value_3 = (try (parallel_worker_5).result);

        _ = (try (parallel_worker_13).result);

        return value_3;
    } else {
        return true;
    }
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

