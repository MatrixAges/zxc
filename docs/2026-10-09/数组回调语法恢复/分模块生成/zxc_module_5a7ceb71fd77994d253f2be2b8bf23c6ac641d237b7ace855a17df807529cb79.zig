const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_10: {
            const operand_7 = (try (@import("zxc_module_6fa31c8c95f1f9540db9a673966087dc824cf4634ef9f81a54b79c8b0aa30592")).callValue(allocator, in));

            break :block_10 block_9: {
                const operand_8 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_8).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_7);

                break :block_9 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_8);
            };
        };

        return value_2;
    } else {
        return block_6: {
            const operand_2 = (in).state;
            const operand_3 = (in).natives;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_4).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_2, .natives = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_4);
            };
        };
    }
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_11 = value_1;

    if ((switch_11 == true)) {
        const value_2: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_15: {
            break :block_15 (try (@import("zxc_module_6fa31c8c95f1f9540db9a673966087dc824cf4634ef9f81a54b79c8b0aa30592")).callValue(allocator, in));
        };

        return ((&value_2)).*;
    } else {
        return block_14: {
            const operand_12 = (in).state;
            const operand_13 = (in).natives;

            break :block_14 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_12, .natives = operand_13, };
        };
    }
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_16 = value_1;

    if ((switch_16 == true)) {
        const value_2: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_20: {
            break :block_20 (try (@import("zxc_module_6fa31c8c95f1f9540db9a673966087dc824cf4634ef9f81a54b79c8b0aa30592")).callBuffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
        };

        return ((&value_2)).*;
    } else {
        return block_19: {
            const operand_17 = (in).state;
            const operand_18 = (in).natives;

            break :block_19 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_17, .natives = operand_18, };
        };
    }
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_21 = value_1;

    if ((switch_21 == true)) {
        const value_2: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (try (@import("zxc_module_6fa31c8c95f1f9540db9a673966087dc824cf4634ef9f81a54b79c8b0aa30592")).callBufferedPointer(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));

        return value_2;
    } else {
        return block_26: {
            const operand_22 = (in).state;
            const operand_23 = (in).natives;

            break :block_26 block_25: {
                const operand_24 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_24).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_22, .natives = operand_23, });

                break :block_25 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_24);
            };
        };
    }
}

