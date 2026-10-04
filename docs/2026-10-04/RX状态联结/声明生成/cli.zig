const std = @import("std");

const zx_type_12 = struct {
    history: []const u64,
    value: u64,
};

const zx_type_13 = struct {
    increment: u64,
    state: *const zx_type_12,
};

const zx_type_14 = struct {
    current: u64,
    first: u64,
    second: u64,
};

const zx_type_15 = struct {
    u64,
    *const zx_type_12,
};

const zx_type_16 = struct {
    u64,
    u64,
};

const zx_type_17 = struct {
    u64,
};

const zx_type_18 = struct {
    u64,
    u64,
    u64,
    *const zx_type_12,
};

const zx_type_19 = struct {
    u64,
    u64,
    u64,
    u64,
};

pub const Input = u64;
pub const Output = *const zx_type_14;

pub const zx_pending_0 = struct {
    store_0: ?*const zx_type_12,
};

fn function_0(allocator: ((std).mem).Allocator, in: *const zx_type_13, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending_0 = zx_pending_0{
        .store_0 = null,
    };

    const value_1: *const zx_type_12 = block_6: {
        const operand_2 = (in).state;
        const operand_3 = (((in).state).value + (in).increment);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_12));

            (operand_4).* = @as(zx_type_12, zx_type_12{
                .history = (operand_2).history,
                .value = operand_3,
            });

            break :block_5 @as(*const zx_type_12, operand_4);
        };
    };

    (pending).store_0 = value_1;
    const output_1 = (value_1).value;

    (try (context).commit(pending));

    return output_1;
}

pub const zx_pending_1 = struct {
    store_0: ?*const zx_type_12,
};

fn function_1(allocator: ((std).mem).Allocator, in: u64, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: *const zx_type_12 = ((context).store_0).*;

    const value_2: u64 = (try function_0(allocator, block_5: {
        const operand_1 = in;
        const operand_2 = value_1;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));

            (operand_3).* = @as(zx_type_13, zx_type_13{
                .increment = operand_1,
                .state = operand_2,
            });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    }, store_context_7: {
        const StoreContext_6 = struct {
            parent: @TypeOf(context),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending_1{
                    .store_0 = (changes).store_0,
                }));
            }
        };

        break :store_context_7 StoreContext_6{
            .parent = context,
        };
    }));

    return value_2;
}

pub const zx_pending_2 = struct {
    store_0: ?*const zx_type_12,
};

fn function_2(allocator: ((std).mem).Allocator, in: *const zx_type_13, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    var pending: zx_pending_2 = zx_pending_2{
        .store_0 = null,
    };

    const value_1: *const zx_type_12 = block_6: {
        const operand_2 = (in).state;
        const operand_3 = (((in).state).value + (in).increment);

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_12));

            (operand_4).* = @as(zx_type_12, zx_type_12{
                .history = (operand_2).history,
                .value = operand_3,
            });

            break :block_5 @as(*const zx_type_12, operand_4);
        };
    };

    (pending).store_0 = value_1;
    const output_1 = (value_1).value;

    (try (context).commit(pending));

    return output_1;
}

pub const zx_pending_3 = struct {
    store_0: ?*const zx_type_12,
};

fn function_3(allocator: ((std).mem).Allocator, in: u64, context: anytype) anyerror!u64 {
    @setRuntimeSafety(true);

    const value_1: *const zx_type_12 = ((context).store_0).*;

    const value_2: u64 = (try function_2(allocator, block_5: {
        const operand_1 = in;
        const operand_2 = value_1;

        break :block_5 block_4: {
            const operand_3 = (try (allocator).create(zx_type_13));

            (operand_3).* = @as(zx_type_13, zx_type_13{
                .increment = operand_1,
                .state = operand_2,
            });

            break :block_4 @as(*const zx_type_13, operand_3);
        };
    }, store_context_7: {
        const StoreContext_6 = struct {
            parent: @TypeOf(context),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending_3{
                    .store_0 = (changes).store_0,
                }));
            }
        };

        break :store_context_7 StoreContext_6{
            .parent = context,
        };
    }));

    return value_2;
}

fn function_4(allocator: ((std).mem).Allocator, in: u64) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return in;
}

pub const zx_pending = struct {
    store_0: ?*const zx_type_12,
};

pub fn execute(arena: *((std).heap).ArenaAllocator, in: u64, context: anytype) anyerror!*const zx_type_14 {
    @setRuntimeSafety(true);

    const allocator = (arena).allocator();

    const value_1: u64 = (try function_1(allocator, in, store_context_10: {
        const StoreContext_9 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{
                    .store_0 = (changes).store_0,
                }));
            }
        };

        break :store_context_10 StoreContext_9{
            .parent = context,
            .store_0 = (context).store_0,
        };
    }));

    const value_2: u64 = (try function_3(allocator, in, store_context_8: {
        const StoreContext_7 = struct {
            parent: @TypeOf(context),
            store_0: @TypeOf((context).store_0),
            pub fn commit(self: @This(), changes: anytype) anyerror!void {
                return (try ((self).parent).commit(zx_pending{
                    .store_0 = (changes).store_0,
                }));
            }
        };

        break :store_context_8 StoreContext_7{
            .parent = context,
            .store_0 = (context).store_0,
        };
    }));

    const value_3: *const zx_type_12 = ((context).store_0).*;
    const value_4: u64 = (try function_4(allocator, (value_3).value));

    return block_6: {
        const operand_1 = value_1;
        const operand_2 = value_2;
        const operand_3 = value_4;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create(zx_type_14));

            (operand_4).* = @as(zx_type_14, zx_type_14{
                .first = operand_1,
                .second = operand_2,
                .current = operand_3,
            });

            break :block_5 @as(*const zx_type_14, operand_4);
        };
    };
}
