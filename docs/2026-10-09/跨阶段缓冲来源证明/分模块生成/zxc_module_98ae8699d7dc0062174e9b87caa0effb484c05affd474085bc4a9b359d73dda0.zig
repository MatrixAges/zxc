const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: *const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e = block_11: {
            const operand_7 = in;
            const operand_8 = (try (@import("zxc_module_d31a8bf065812ed51850aab3231db1aa623df6c9c7ef866ff23f62d1041efb91")).callValue(allocator, (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0{ .modules = (zx_abi).value_zx_type_c7b585000df764b60b0f509e4808bd17fe70557f22a2a6335b3cea8878418960_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .identities = ((operand_7).modules).identities, .import_names = ((operand_7).modules).import_names, .specifiers = ((operand_7).modules).specifiers, .type_ids = ((operand_7).modules).type_ids, .type_names = ((operand_7).modules).type_names, .type_namespaces = ((operand_7).modules).type_namespaces, .zx_origin = (operand_7).modules, }, .request = (zx_abi).value_zx_type_ee6b44b7124ff8c93c079be2801c29557cbe5a4367eecbbd619c9166d3f42a77_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701{ .maximum_count = ((operand_7).request).maximum_count, .names = ((operand_7).request).names, .origins = ((operand_7).request).origins, .roots = ((operand_7).request).roots, .scalar_count = ((operand_7).request).scalar_count, .table = ((operand_7).request).table, .zx_origin = (operand_7).request, }, .selected = (operand_7).selected, .state = (operand_7).state, .zx_origin = operand_7, }));

            break :block_11 (if (((operand_8).zx_origin != null)) (operand_8).zx_origin.? else block_10: {
                const operand_9 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

                (operand_9).* = (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .selected = (operand_8).selected, .state = (operand_8).state, };

                break :block_10 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_9);
            });
        };

        return value_2;
    } else {
        return block_6: {
            const operand_2 = (in).state;
            const operand_3 = (in).selected;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

                (operand_4).* = @as((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .state = operand_2, .selected = operand_3, });

                break :block_5 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_4);
            };
        };
    }
}

pub fn callValue(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: bool = block_19: {
        const operand_18 = (in).state;

        break :block_19 (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, operand_18));
    };

    const switch_12 = block_13: {
        break :block_13 value_1;
    };

    if ((switch_12 == true)) {
        const value_2: (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = block_17: {
            break :block_17 (try (@import("zxc_module_d31a8bf065812ed51850aab3231db1aa623df6c9c7ef866ff23f62d1041efb91")).callValue(allocator, in));
        };

        return value_2;
    } else {
        return block_16: {
            const operand_14 = (in).state;
            const operand_15 = (in).selected;

            break :block_16 @as((zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .state = operand_14, .selected = operand_15, });
        };
    }
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: (zx_abi).value_zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744_8d8f82452aeec8ea1d58937abed9d29cb7caf131870fdd8af70346b64aab18b0, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 {
    @setRuntimeSafety(true);

    const value_1: bool = block_27: {
        const operand_26 = (in).state;

        break :block_27 (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, operand_26));
    };

    const switch_20 = block_21: {
        break :block_21 value_1;
    };

    if ((switch_20 == true)) {
        const value_2: (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = @as((zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, block_25: {
            break :block_25 (try (@import("zxc_module_d31a8bf065812ed51850aab3231db1aa623df6c9c7ef866ff23f62d1041efb91")).callBuffered(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), }));
        });

        return value_2;
    } else {
        return block_24: {
            const operand_22 = (in).state;
            const operand_23 = (in).selected;

            break :block_24 @as((zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, (zx_abi).value_zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814{ .state = operand_22, .selected = operand_23, });
        };
    }
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_9fb02bda7d79a02229d005556afd697b0f021557c13b7e6d6ab008fef9c9a744, buffers: struct {
    lane_0: ?struct {
        buffer: *(std).ArrayList(bool),
        started: *bool,
    },
    lane_1: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
    lane_2: ?struct {
        buffer: *(std).ArrayList(u32),
        started: *bool,
    },
    lane_3: ?struct {
        buffer: *(std).ArrayList(u64),
        started: *bool,
    },
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_28 = value_1;

    if ((switch_28 == true)) {
        const value_2: *const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e = (try (@import("zxc_module_d31a8bf065812ed51850aab3231db1aa623df6c9c7ef866ff23f62d1041efb91")).callBufferedPointer(allocator, in, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), }));

        return value_2;
    } else {
        return block_33: {
            const operand_29 = (in).state;
            const operand_30 = (in).selected;

            break :block_33 block_32: {
                const operand_31 = (try (allocator).create((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e));

                (operand_31).* = @as((zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e{ .state = operand_29, .selected = operand_30, });

                break :block_32 @as(*const (zx_abi).zx_type_a572ca2fe044a45408a80b36fc4d5639d2535a0b3a4fe3340d4a87dcb44c715e, operand_31);
            };
        };
    }
}

