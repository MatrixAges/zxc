const std = @import("std");
const zx_abi = @import("zxc_abi");
pub const Input = u64;
pub const Output = u64;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();
    var parallel_allocator_1 = zx_parallel_allocator{ .child = allocator, };
    const parallel_input_3 = in;

    const ParallelWorker_2 = struct {
        allocator: ((std).mem).Allocator,
        input: u64,
        result: anyerror!void,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_ac984aacbf37983902a12ea9fe0e907c01ff1f765dbd25de108fb16e8daf092f")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_4 = ParallelWorker_2{ .allocator = (parallel_allocator_1).allocator(), .input = parallel_input_3, .result = undefined, };
    const parallel_input_7 = in;

    const ParallelWorker_6 = struct {
        allocator: ((std).mem).Allocator,
        input: u64,
        result: anyerror!u64,
        fn run(self: *@This()) void {
            (self).result = (@import("zxc_module_8fd6cc39ecb7ae24aabe4ec49ce4ae3b78d78c4ee92593a73d66b89e48d34507")).call((self).allocator, (self).input);
        }
    };

    var parallel_worker_8 = ParallelWorker_6{ .allocator = (parallel_allocator_1).allocator(), .input = parallel_input_7, .result = undefined, };

    {
        const parallel_thread_5 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_2).run, .{ (&parallel_worker_4), }));

        defer (parallel_thread_5).join();

        const parallel_thread_9 = (try ((std).Thread).spawn(.{ }, (ParallelWorker_6).run, .{ (&parallel_worker_8), }));

        defer (parallel_thread_9).join();
    }

    _ = (try (parallel_worker_4).result);

    const value_1 = (try (parallel_worker_8).result);

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
