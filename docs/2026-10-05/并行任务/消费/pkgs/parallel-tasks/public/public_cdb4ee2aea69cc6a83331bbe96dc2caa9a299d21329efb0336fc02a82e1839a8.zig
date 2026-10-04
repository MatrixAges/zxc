const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;
pub const Output = *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3) anyerror!*const (zx_abi).zx_type_c9f6beeea24de1cb7a75f9d727d6f49a42b14a1c2ea2634c622a629610d8f5e3 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    const value_1: u8 = (try (@import("zxc_module_ac2b7a2e2a745a02e5ee495a6da7e0c20f5b6e5f3c34875d810effc57f4b9368")).call(allocator, (in).value));
    var parallel_allocator_6 = zx_parallel_allocator{ .child = allocator, };

    const parallel_input_8 = block_13: {
        const operand_10 = value_1;

        break :block_13 block_12: {
            const operand_11 = (try (allocator).create((zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8));

            (operand_11).* = @as((zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8, .{ operand_10, });

            break :block_12 @as(*const (zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8, operand_11);
        };
    };

    const ParallelWorker_7 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8,
        result: anyerror!u8,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_b2907635802a7ac81857196cd21fe76fc814161fb19277aba5649dad0dd1eefd")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_9 = ParallelWorker_7{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_8, .result = undefined, };

    const parallel_input_16 = block_22: {
        const operand_18 = in;
        const operand_19 = value_1;

        break :block_22 block_21: {
            const operand_20 = (try (allocator).create((zx_abi).zx_type_fafd1b91d62c9a6984327f86dea93b220494fa07316cc24250b154611bafd37a));

            (operand_20).* = @as((zx_abi).zx_type_fafd1b91d62c9a6984327f86dea93b220494fa07316cc24250b154611bafd37a, .{ operand_18, operand_19, });

            break :block_21 @as(*const (zx_abi).zx_type_fafd1b91d62c9a6984327f86dea93b220494fa07316cc24250b154611bafd37a, operand_20);
        };
    };

    const ParallelWorker_15 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_fafd1b91d62c9a6984327f86dea93b220494fa07316cc24250b154611bafd37a,
        result: anyerror!bool,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_c7ea3e9bb87f13c75e993d9376c360e6c36b240c3aa2c7df9a3fbd351b5e745a")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_17 = ParallelWorker_15{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_16, .result = undefined, };

    const parallel_input_25 = block_30: {
        const operand_27 = value_1;

        break :block_30 block_29: {
            const operand_28 = (try (allocator).create((zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8));

            (operand_28).* = @as((zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8, .{ operand_27, });

            break :block_29 @as(*const (zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8, operand_28);
        };
    };

    const ParallelWorker_24 = struct {
        allocator: ((std).mem).Allocator,
        input: *const (zx_abi).zx_type_475d412f942139d332044c8c7992ca382c94f947f10f80d6a5acdb98ef718af8,
        result: anyerror!void,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_b0a0bea1333245418751008e17fc4addc5b41760c7973359c2505b71631d1595")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_26 = ParallelWorker_24{ .allocator = (parallel_allocator_6).allocator(), .input = parallel_input_25, .result = undefined, };

    {
        const parallel_thread_14 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_7).run, .{ (&parallel_worker_9), }));

        defer (parallel_thread_14).join();

        const parallel_thread_23 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_15).run, .{ (&parallel_worker_17), }));

        defer (parallel_thread_23).join();

        const parallel_thread_31 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_24).run, .{ (&parallel_worker_26), }));

        defer (parallel_thread_31).join();
    }

    const value_2 = (try (parallel_worker_9).result);
    const value_3 = (try (parallel_worker_17).result);

    _ = (try (parallel_worker_26).result);

    return block_5: {
        const operand_1 = value_2;
        const operand_2 = value_3;

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

