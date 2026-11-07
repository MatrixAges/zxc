const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4) error{
    OutOfMemory,
}!(zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 {
    @setRuntimeSafety(true);

    return block_7: {
        const value_4: (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4 = block_6: {
            const operand_1 = in;
            const operand_2 = true;

            const operand_4 = block_3: {
                break :block_3 @as((zx_abi).value_f6cdf400d07a19f4fca1c983f529e0f79a3de8e2312ad4e71b1ed0a06e7cc388, .{
                    null,
                });
            };
            var sort_context_5: struct {
                allocator: @TypeOf(allocator),
                environment: @TypeOf(operand_4),
                failure: @TypeOf(@as(?error{
                    OutOfMemory,
                }, null)),
            } = .{
                .allocator = allocator,
                .environment = operand_4,
                .failure = @as(?error{
                    OutOfMemory,
                }, null),
            };

            break :block_6 (zx_abi).value_e893759507c197f46a9d38b5d1018fd18f1808dd522dcfdea1620c9bbf63b4a4{
                .items = (try (zx_sort_worker_0).sort((&sort_context_5), (operand_1).items, operand_2)),
                .storage = (if ((operand_2 and (@backingInt((operand_1).storage) >= 2))) .exclusive else .owned),
            };
        };

        break :block_7 value_4;
    };
}

const zx_sort_worker_0 = struct {
    fn compare(context: anytype, left_element: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, right_element: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0) error{
        OutOfMemory,
    }!i64 {
        _ = context;

        const left = left_element;
        const right = right_element;

        return (if (((block_1: {
            break :block_1 left;
        }).bytes > (block_2: {
            break :block_2 right;
        }).bytes)) @as(i64, (-1)) else (if (((block_3: {
            break :block_3 left;
        }).bytes < (block_4: {
            break :block_4 right;
        }).bytes)) @as(i64, 1) else (if (((block_5: {
            break :block_5 left;
        }).index < (block_6: {
            break :block_6 right;
        }).index)) @as(i64, (-1)) else (if (((block_7: {
            break :block_7 left;
        }).index == (block_8: {
            break :block_8 right;
        }).index)) @as(i64, 0) else @as(i64, 1)))));
    }

    fn Ordering(comptime Context: type) type {
        return struct {
            fn less(context: Context, left: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, right: *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0) bool {
                if (((context).failure != null)) {
                    return false;
                }

                return ((compare(context, left, right) catch |err| {
                    (context).failure = err;

                    return false;
                }) < 0);
            }
        };
    }

    fn sort(context: anytype, source: []const *const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, reuse: bool) error{
        OutOfMemory,
    }![]*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0 {
        const items = (if (reuse) @constCast(source) else (try ((context).allocator).dupe(*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, source)));

        errdefer (if (reuse) {} else ((context).allocator).free(items));
        ((std).mem).sortUnstable(*const (zx_abi).zx_type_64d6f82e564c940220772aae0ebcd0c763c8e6f3985e8e1d0c003fcdb5ea06d0, items, context, (Ordering(@TypeOf(context))).less);

        if ((context).failure) |err| {
            return err;
        }

        return items;
    }
};
