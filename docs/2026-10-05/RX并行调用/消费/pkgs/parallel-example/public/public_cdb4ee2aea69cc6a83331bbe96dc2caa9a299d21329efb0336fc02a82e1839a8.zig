const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = []const u64;
pub const Output = *const (zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u64) anyerror!*const (zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    var parallel_allocator_8 = zx_parallel_allocator{ .child = allocator, };
    const parallel_input_10 = in;

    const ParallelWorker_9 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_d14f1b051d1952c73264cdd97d41ec7d50341f56038e9929e77b4131be84b8a3")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_11 = ParallelWorker_9{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_10, .result = undefined, };
    const parallel_input_14 = in;

    const ParallelWorker_13 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror![]const u64,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_d14f1b051d1952c73264cdd97d41ec7d50341f56038e9929e77b4131be84b8a3")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_15 = ParallelWorker_13{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_14, .result = undefined, };
    const parallel_input_18 = in;

    const ParallelWorker_17 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror!u64,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_e381993432177f7f22c4905764c34bdbc43085aca217467508bc9545f8a1b110")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_19 = ParallelWorker_17{ .allocator = (parallel_allocator_8).allocator(), .input = parallel_input_18, .result = undefined, };
    const parallel_input_22 = in;

    const ParallelWorker_21 = struct {
        allocator: ((std).mem).Allocator,
        input: []const u64,
        result: anyerror!u64,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_5737f73f4ad01acc945eb09d814361f281713eefd9bed2b04673ab69c44e0027")).call((self).allocator, (self).input);
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
            const operand_5 = (try (allocator).create((zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8));

            (operand_5).* = @as((zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8, (zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8{ .values = operand_1, .alternate = operand_2, .total = operand_3, .first = operand_4, });

            break :block_6 @as(*const (zx_abi).zx_type_3af2fba9493215f49f765ed4c76e5fcd91c8d573c976df7361ed8498359fcdf8, operand_5);
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
