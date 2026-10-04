const std = @import("std");

const zx_type_11 = struct {
    increment: u64,
    index: u64,
};

const zx_type_12 = struct {
    value: u64,
};

const zx_type_14 = struct {
    count: u64,
    items: []const u64,
};

pub const Input = *const zx_type_11;
pub const Pending = *const zx_type_12;
pub const State = *const zx_type_14;
pub const Output = u64;

pub const zx_pending_0 = struct {
    store_0: ?*const zx_type_14,
};

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_11, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending_0 = zx_pending_0{ .store_0 = null, };

    (pending).store_0 = block_9: {
        const operand_5 = ((pending).store_0 orelse ((context).store_0).*);
        const operand_6 = ((((pending).store_0 orelse ((context).store_0).*)).count + (in).increment);

        break :block_9 block_8: {
            const operand_7 = (try (allocator).create(zx_type_14));

            (operand_7).* = @as(zx_type_14, zx_type_14{ .count = operand_6, .items = (operand_5).items, });

            break :block_8 @as(*const zx_type_14, operand_7);
        };
    };

    const output_4 = (block_3: {
        const operand_1 = (((pending).store_0 orelse ((context).store_0).*)).items;
        const operand_2 = (in).index;

        if ((operand_2 >= (operand_1).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_3 (operand_1)[@intCast(operand_2)];
    } + (((pending).store_0 orelse ((context).store_0).*)).count);

    (try (context).commit(pending));

    return output_4;
}

pub const zx_pending_1 = struct {
    store_0: ?*const zx_type_14,
};

fn function_1(allocator: ((std).mem).Allocator, in: *const zx_type_11, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = (try function_0(allocator, in, store_context_2: {
        const StoreContext_1 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending_1{ .store_0 = (changes).store_0, }));
            }
        };

        break :store_context_2 StoreContext_1{ .parent = context, .store_0 = (context).store_0, };
    }));

    return (((context).store_0).*).count;
}

pub const zx_pending = struct {
    store_0: ?*const zx_type_14,
    store_1: ?*const zx_type_14,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: *const zx_type_11, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    _ = (try function_1(allocator, in, store_context_4: {
        const StoreContext_3 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_1),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = null, .store_1 = (changes).store_0, }));
            }
        };

        break :store_context_4 StoreContext_3{ .parent = context, .store_0 = (context).store_1, };
    }));

    _ = (try function_1(allocator, in, store_context_2: {
        const StoreContext_1 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_1),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{ .store_0 = null, .store_1 = (changes).store_0, }));
            }
        };

        break :store_context_2 StoreContext_1{ .parent = context, .store_0 = (context).store_1, };
    }));

    return (((context).store_1).*).count;
}

