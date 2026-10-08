const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27) error{ OutOfMemory, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((((in).plan).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return (in).plan;
    }

    const value_1: u64 = @as(u64, (((in).signatures).inputs).len);
    const value_2: u64 = @as(u64, (((in).imports).ids).len);

    if (((((@as(u64, (((in).signatures).outputs).len) != value_1) or (@as(u64, (((in).signatures).native_modules).len) != value_1)) or (@as(u64, (((in).imports).inputs).len) != value_2)) or (@as(u64, (((in).imports).outputs).len) != value_2))) {
        return block_10: {
            const operand_1 = (in).plan;

            const operand_2 = block_7: {
                const operand_3 = ((in).plan).state;
                const operand_4 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_7 block_6: {
                    const operand_5 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_5).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_3).count, .mapping = (operand_3).mapping, .order = (operand_3).order, .origins = (operand_3).origins, .status = operand_4, });

                    break :block_6 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_5);
                };
            };

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_8).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_1).functions, .natives = (operand_1).natives, .state = operand_2, });

                break :block_9 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_8);
            };
        };
    }

    return (in).plan;
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27) error{ OutOfMemory, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((((in).plan).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return ((in).plan).*;
    }

    const value_1: u64 = @as(u64, (((in).signatures).inputs).len);
    const value_2: u64 = @as(u64, (((in).imports).ids).len);

    if (((((@as(u64, (((in).signatures).outputs).len) != value_1) or (@as(u64, (((in).signatures).native_modules).len) != value_1)) or (@as(u64, (((in).imports).inputs).len) != value_2)) or (@as(u64, (((in).imports).outputs).len) != value_2))) {
        return block_18: {
            const operand_11 = (in).plan;

            const operand_12 = block_17: {
                const operand_13 = ((in).plan).state;
                const operand_14 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_17 block_16: {
                    const operand_15 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_15).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_13).count, .mapping = (operand_13).mapping, .order = (operand_13).order, .origins = (operand_13).origins, .status = operand_14, });

                    break :block_16 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_15);
                };
            };

            break :block_18 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_11).functions, .natives = (operand_11).natives, .state = operand_12, };
        };
    }

    return ((in).plan).*;
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    _ = buffers;

    if (((((in).plan).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return ((in).plan).*;
    }

    const value_1: u64 = @as(u64, (((in).signatures).inputs).len);
    const value_2: u64 = @as(u64, (((in).imports).ids).len);

    if (((((@as(u64, (((in).signatures).outputs).len) != value_1) or (@as(u64, (((in).signatures).native_modules).len) != value_1)) or (@as(u64, (((in).imports).inputs).len) != value_2)) or (@as(u64, (((in).imports).outputs).len) != value_2))) {
        return block_26: {
            const operand_19 = (in).plan;

            const operand_20 = block_25: {
                const operand_21 = ((in).plan).state;
                const operand_22 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_25 block_24: {
                    const operand_23 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_23).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_21).count, .mapping = (operand_21).mapping, .order = (operand_21).order, .origins = (operand_21).origins, .status = operand_22, });

                    break :block_24 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_23);
                };
            };

            break :block_26 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_19).functions, .natives = (operand_19).natives, .state = operand_20, };
        };
    }

    return ((in).plan).*;
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_4: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_5: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_6: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ OutOfMemory, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    _ = buffers;

    if (((((in).plan).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return (in).plan;
    }

    const value_1: u64 = @as(u64, (((in).signatures).inputs).len);
    const value_2: u64 = @as(u64, (((in).imports).ids).len);

    if (((((@as(u64, (((in).signatures).outputs).len) != value_1) or (@as(u64, (((in).signatures).native_modules).len) != value_1)) or (@as(u64, (((in).imports).inputs).len) != value_2)) or (@as(u64, (((in).imports).outputs).len) != value_2))) {
        return block_36: {
            const operand_27 = (in).plan;

            const operand_28 = block_33: {
                const operand_29 = ((in).plan).state;
                const operand_30 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_33 block_32: {
                    const operand_31 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_31).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_29).count, .mapping = (operand_29).mapping, .order = (operand_29).order, .origins = (operand_29).origins, .status = operand_30, });

                    break :block_32 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_31);
                };
            };

            break :block_36 block_35: {
                const operand_34 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_34).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_27).functions, .natives = (operand_27).natives, .state = operand_28, });

                break :block_35 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_34);
            };
        };
    }

    return (in).plan;
}

