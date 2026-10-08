const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_1 = value_1;

    if ((switch_1 == true)) {
        const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_fbe88c89ad89cfe1f181ef3d48fee57a762495e7ff9d579d0d7185d5a631fbd7")).call(allocator, block_20: {
            const operand_15 = (in).request;
            const operand_16 = (in).state;
            const operand_17 = (in).type_imports;

            break :block_20 block_19: {
                const operand_18 = (try (allocator).create((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e));

                (operand_18).* = @as((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e{ .request = operand_15, .state = operand_16, .ids = operand_17, });

                break :block_19 @as(*const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, operand_18);
            };
        }));

        const value_3: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (try (@import("zxc_module_5a7ceb71fd77994d253f2be2b8bf23c6ac641d237b7ace855a17df807529cb79")).call(allocator, block_14: {
            const operand_7 = (in).request;
            const operand_8 = value_2;
            const operand_9 = (in).modules;
            const operand_10 = (in).natives;
            const operand_11 = (in).dependencies;

            break :block_14 block_13: {
                const operand_12 = (try (allocator).create((zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a));

                (operand_12).* = @as((zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a{ .request = operand_7, .state = operand_8, .modules = operand_9, .natives = operand_10, .dependencies = operand_11, });

                break :block_13 @as(*const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, operand_12);
            };
        }));

        return value_3;
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

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef {
    @setRuntimeSafety(true);

    const value_1: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (in).state));
    const switch_21 = value_1;

    if ((switch_21 == true)) {
        const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_fbe88c89ad89cfe1f181ef3d48fee57a762495e7ff9d579d0d7185d5a631fbd7")).call(allocator, block_38: {
            const operand_33 = (in).request;
            const operand_34 = (in).state;
            const operand_35 = (in).type_imports;

            break :block_38 block_37: {
                const operand_36 = (try (allocator).create((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e));

                (operand_36).* = @as((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e{ .request = operand_33, .state = operand_34, .ids = operand_35, });

                break :block_37 @as(*const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, operand_36);
            };
        }));

        const value_3: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_32: {
            const operand_31 = block_30: {
                const operand_25 = (in).request;
                const operand_26 = value_2;
                const operand_27 = (in).modules;
                const operand_28 = (in).natives;
                const operand_29 = (in).dependencies;

                break :block_30 (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a{ .request = operand_25, .state = operand_26, .modules = operand_27, .natives = operand_28, .dependencies = operand_29, };
            };

            break :block_32 (try (@import("zxc_module_5a7ceb71fd77994d253f2be2b8bf23c6ac641d237b7ace855a17df807529cb79")).callValue(allocator, (&operand_31)));
        };

        return ((&value_3)).*;
    } else {
        return block_24: {
            const operand_22 = (in).state;
            const operand_23 = (in).natives;

            break :block_24 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_22, .natives = operand_23, };
        };
    }
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, buffers: struct {
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
    const switch_39 = value_1;

    if ((switch_39 == true)) {
        const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_58: {
            const operand_57 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

            (operand_57).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_56: {
                const operand_55 = block_54: {
                    const operand_51 = (in).request;
                    const operand_52 = (in).state;
                    const operand_53 = (in).type_imports;

                    break :block_54 (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e{ .request = operand_51, .state = operand_52, .ids = operand_53, };
                };

                break :block_56 (try (@import("zxc_module_fbe88c89ad89cfe1f181ef3d48fee57a762495e7ff9d579d0d7185d5a631fbd7")).callBuffered(allocator, (&operand_55), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
            });

            break :block_58 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_57);
        };

        const value_3: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = block_50: {
            const operand_49 = block_48: {
                const operand_43 = (in).request;
                const operand_44 = value_2;
                const operand_45 = (in).modules;
                const operand_46 = (in).natives;
                const operand_47 = (in).dependencies;

                break :block_48 (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a{ .request = operand_43, .state = operand_44, .modules = operand_45, .natives = operand_46, .dependencies = operand_47, };
            };

            break :block_50 (try (@import("zxc_module_5a7ceb71fd77994d253f2be2b8bf23c6ac641d237b7ace855a17df807529cb79")).callBuffered(allocator, (&operand_49), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));
        };

        return ((&value_3)).*;
    } else {
        return block_42: {
            const operand_40 = (in).state;
            const operand_41 = (in).natives;

            break :block_42 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_40, .natives = operand_41, };
        };
    }
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_4befdba7467ae86e5249931559aacaddd1da16e18d991491ed7b2b489641ccc7, buffers: struct {
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
    const switch_59 = value_1;

    if ((switch_59 == true)) {
        const value_2: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_fbe88c89ad89cfe1f181ef3d48fee57a762495e7ff9d579d0d7185d5a631fbd7")).callBufferedPointer(allocator, block_78: {
            const operand_73 = (in).request;
            const operand_74 = (in).state;
            const operand_75 = (in).type_imports;

            break :block_78 block_77: {
                const operand_76 = (try (allocator).create((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e));

                (operand_76).* = @as((zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e{ .request = operand_73, .state = operand_74, .ids = operand_75, });

                break :block_77 @as(*const (zx_abi).zx_type_8305d25d7eac5f7229488e16e548d21adad006bfd879abd5ce1ba154d58fa62e, operand_76);
            };
        }, .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));

        const value_3: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (try (@import("zxc_module_5a7ceb71fd77994d253f2be2b8bf23c6ac641d237b7ace855a17df807529cb79")).callBufferedPointer(allocator, block_72: {
            const operand_65 = (in).request;
            const operand_66 = value_2;
            const operand_67 = (in).modules;
            const operand_68 = (in).natives;
            const operand_69 = (in).dependencies;

            break :block_72 block_71: {
                const operand_70 = (try (allocator).create((zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a));

                (operand_70).* = @as((zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a{ .request = operand_65, .state = operand_66, .modules = operand_67, .natives = operand_68, .dependencies = operand_69, });

                break :block_71 @as(*const (zx_abi).zx_type_880996cec8a2edfcee96ab9f9717988720df299102d10e376d96ba290a43f38a, operand_70);
            };
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), }));

        return value_3;
    } else {
        return block_64: {
            const operand_60 = (in).state;
            const operand_61 = (in).natives;

            break :block_64 block_63: {
                const operand_62 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

                (operand_62).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_60, .natives = operand_61, });

                break :block_63 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_62);
            };
        };
    }
}

