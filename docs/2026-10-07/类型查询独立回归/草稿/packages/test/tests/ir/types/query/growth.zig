const std = @import("std");
const f = @import("fixture.zig");
pub const Shape = enum { chain_native, chain_list, chain_plain, wide_native, wide_list, wide_plain, dag_mixed, dag_plain, task_list_native };
pub const Result = struct { storage: f.ir.TypeStorage, root: f.ir.TypeId, native: bool, list: bool };

pub fn build(memory: std.mem.Allocator, shape: Shape, size: usize) !Result {
    var storage = try f.base(memory);
    var root = f.scalar(.u64);
    var native_result = false;
    var list_result = false;

    switch (shape) {
        .chain_native, .chain_list, .chain_plain, .task_list_native => {
            if (shape == .chain_native or shape == .task_list_native) {
                root = try f.add(memory, &storage, .{ .native_reference = "Node" });
                native_result = true;
            } else if (shape == .chain_list) {
                root = try f.add(memory, &storage, .{ .list = root });
                list_result = true;
            }

            for (0..size) |_| root = try f.add(memory, &storage, .{ .optional = root });

            if (shape == .chain_plain) {
                _ = try f.add(memory, &storage, .{ .native_reference = "LaterNode" });
                _ = try f.add(memory, &storage, .{ .list = f.scalar(.u64) });
            } else if (shape == .task_list_native) {
                const values = try f.add(memory, &storage, .{ .list = root });
                const errors = try f.add(memory, &storage, .{ .error_set = &.{"Failure"} });
                root = try f.add(memory, &storage, .{ .task = .{ .result = values, .errors = errors } });
            }
        },
        .wide_native, .wide_list, .wide_plain => {
            const node = try f.add(memory, &storage, .{ .native_reference = "Node" });
            const numbers = try f.add(memory, &storage, .{ .list = f.scalar(.u64) });
            const children = try memory.alloc(f.ir.TypeId, size);

            @memset(children, f.scalar(.u64));

            if (size != 0 and shape != .wide_plain) {
                children[size - 1] = if (shape == .wide_native) node else numbers;
                native_result = shape == .wide_native;
                list_result = shape == .wide_list;
            }

            root = try f.add(memory, &storage, .{ .tuple = children });
        },
        .dag_mixed, .dag_plain => {
            const node = try f.add(memory, &storage, .{ .native_reference = "Node" });
            const numbers = try f.add(memory, &storage, .{ .list = f.scalar(.u64) });
            const first = if (shape == .dag_mixed) node else f.scalar(.u64);
            const last = if (shape == .dag_mixed) numbers else f.scalar(.bool);

            root = try f.add(memory, &storage, .{ .tuple = &.{ first, last } });

            for (0..size) |_| root = try f.add(memory, &storage, .{ .tuple = &.{ root, root, last } });

            native_result = shape == .dag_mixed;
            list_result = shape == .dag_mixed;
        },
    }

    try f.valid(storage.view());

    return .{ .storage = storage, .root = root, .native = native_result, .list = list_result };
}
