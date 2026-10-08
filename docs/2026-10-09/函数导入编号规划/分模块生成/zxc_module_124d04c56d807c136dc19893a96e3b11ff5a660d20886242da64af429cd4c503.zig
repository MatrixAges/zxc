const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).signatures).inputs).len))) {
        return block_91: {
            const operand_82 = (in).plan;

            const operand_83 = block_88: {
                const operand_84 = ((in).plan).state;
                const operand_85 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_88 block_87: {
                    const operand_86 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_86).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_84).count, .mapping = (operand_84).mapping, .order = (operand_84).order, .origins = (operand_84).origins, .status = operand_85, });

                    break :block_87 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_86);
                };
            };

            break :block_91 block_90: {
                const operand_89 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_89).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_82).functions, .natives = (operand_82).natives, .state = operand_83, });

                break :block_90 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_89);
            };
        };
    }

    if ((block_81: {
        const operand_79 = (((in).plan).functions).mapping;
        const operand_80 = (in).index;

        if ((operand_80 >= (operand_79).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_81 (operand_79)[@intCast(operand_80)];
    } != @as(u64, 0))) {
        return (in).plan;
    }

    const value_1: ?u32 = block_78: {
        const operand_76 = ((in).signatures).native_modules;
        const operand_77 = (in).index;

        if ((operand_77 >= (operand_76).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_78 (operand_76)[@intCast(operand_77)];
    };

    const value_2: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (if ((value_1 == null)) block_63: {
        const operand_59 = ((in).plan).state;
        const operand_60 = ((in).plan).natives;

        break :block_63 block_62: {
            const operand_61 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_61).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_59, .natives = operand_60, });

            break :block_62 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_61);
        };
    } else block_75: {
        const operand_72 = (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callValue(allocator, block_71: {
            const operand_64 = (in).request;
            const operand_65 = ((in).plan).state;
            const operand_66 = (in).modules;
            const operand_67 = ((in).plan).natives;
            const operand_68 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, value_1.?));

            break :block_71 block_70: {
                const operand_69 = (try (allocator).create((zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67));

                (operand_69).* = @as((zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .request = operand_64, .state = operand_65, .modules = operand_66, .natives = operand_67, .index = operand_68, });

                break :block_70 @as(*const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, operand_69);
            };
        }));

        break :block_75 block_74: {
            const operand_73 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_73).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_72);

            break :block_74 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_73);
        };
    });

    if ((((value_2).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_58: {
            const operand_53 = (value_2).state;
            const operand_54 = (value_2).natives;
            const operand_55 = ((in).plan).functions;

            break :block_58 block_57: {
                const operand_56 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_56).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_53, .natives = operand_54, .functions = operand_55, });

                break :block_57 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_56);
            };
        };
    }

    const value_3: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_52: {
        const operand_50 = ((in).signatures).inputs;
        const operand_51 = (in).index;

        if ((operand_51 >= (operand_50).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_52 (operand_50)[@intCast(operand_51)];
    }));

    if ((value_3 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_49: {
            const operand_39 = block_44: {
                const operand_40 = (value_2).state;
                const operand_41 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_44 block_43: {
                    const operand_42 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_42).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_40).count, .mapping = (operand_40).mapping, .order = (operand_40).order, .origins = (operand_40).origins, .status = operand_41, });

                    break :block_43 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_42);
                };
            };

            const operand_45 = (value_2).natives;
            const operand_46 = ((in).plan).functions;

            break :block_49 block_48: {
                const operand_47 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_47).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_39, .natives = operand_45, .functions = operand_46, });

                break :block_48 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_47);
            };
        };
    }

    const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).call(allocator, block_38: {
        const operand_33 = (in).request;
        const operand_34 = (value_2).state;
        const operand_35 = value_3;

        break :block_38 block_37: {
            const operand_36 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_36).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_33, .state = operand_34, .index = operand_35, });

            break :block_37 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_36);
        };
    }));

    if (((value_4).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_32: {
            const operand_27 = value_4;
            const operand_28 = (value_2).natives;
            const operand_29 = ((in).plan).functions;

            break :block_32 block_31: {
                const operand_30 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_30).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_27, .natives = operand_28, .functions = operand_29, });

                break :block_31 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_30);
            };
        };
    }

    const value_5: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_26: {
        const operand_24 = ((in).signatures).outputs;
        const operand_25 = (in).index;

        if ((operand_25 >= (operand_24).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_26 (operand_24)[@intCast(operand_25)];
    }));

    if ((value_5 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_23: {
            const operand_13 = block_18: {
                const operand_14 = value_4;
                const operand_15 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_18 block_17: {
                    const operand_16 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_16).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_14).count, .mapping = (operand_14).mapping, .order = (operand_14).order, .origins = (operand_14).origins, .status = operand_15, });

                    break :block_17 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_16);
                };
            };

            const operand_19 = (value_2).natives;
            const operand_20 = ((in).plan).functions;

            break :block_23 block_22: {
                const operand_21 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_21).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_13, .natives = operand_19, .functions = operand_20, });

                break :block_22 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_21);
            };
        };
    }

    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).call(allocator, block_12: {
        const operand_7 = (in).request;
        const operand_8 = value_4;
        const operand_9 = value_5;

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_10).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_7, .state = operand_8, .index = operand_9, });

            break :block_11 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_10);
        };
    }));

    return block_6: {
        const operand_1 = value_6;
        const operand_2 = (value_2).natives;
        const operand_3 = ((in).plan).functions;

        break :block_6 block_5: {
            const operand_4 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

            (operand_4).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_1, .natives = operand_2, .functions = operand_3, });

            break :block_5 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_4);
        };
    };
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).signatures).inputs).len))) {
        return block_164: {
            const operand_157 = (in).plan;

            const operand_158 = block_163: {
                const operand_159 = ((in).plan).state;
                const operand_160 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_163 block_162: {
                    const operand_161 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_161).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_159).count, .mapping = (operand_159).mapping, .order = (operand_159).order, .origins = (operand_159).origins, .status = operand_160, });

                    break :block_162 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_161);
                };
            };

            break :block_164 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_157).functions, .natives = (operand_157).natives, .state = operand_158, };
        };
    }

    if ((block_156: {
        const operand_154 = (((in).plan).functions).mapping;
        const operand_155 = (in).index;

        if ((operand_155 >= (operand_154).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_156 (operand_154)[@intCast(operand_155)];
    } != @as(u64, 0))) {
        return ((in).plan).*;
    }

    const value_1: ?u32 = block_153: {
        const operand_151 = ((in).signatures).native_modules;
        const operand_152 = (in).index;

        if ((operand_152 >= (operand_151).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_153 (operand_151)[@intCast(operand_152)];
    };

    const value_2: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (if ((value_1 == null)) block_142: {
        const operand_140 = ((in).plan).state;
        const operand_141 = ((in).plan).natives;

        break :block_142 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_140, .natives = operand_141, };
    } else block_150: {
        const operand_149 = block_148: {
            const operand_143 = (in).request;
            const operand_144 = ((in).plan).state;
            const operand_145 = (in).modules;
            const operand_146 = ((in).plan).natives;
            const operand_147 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, value_1.?));

            break :block_148 (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .request = operand_143, .state = operand_144, .modules = operand_145, .natives = operand_146, .index = operand_147, };
        };

        break :block_150 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callValue(allocator, (&operand_149)));
    });

    if (((((&value_2)).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_139: {
            const operand_136 = ((&value_2)).state;
            const operand_137 = ((&value_2)).natives;
            const operand_138 = ((in).plan).functions;

            break :block_139 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_136, .natives = operand_137, .functions = operand_138, };
        };
    }

    const value_3: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_135: {
        const operand_133 = ((in).signatures).inputs;
        const operand_134 = (in).index;

        if ((operand_134 >= (operand_133).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_135 (operand_133)[@intCast(operand_134)];
    }));

    if ((value_3 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_132: {
            const operand_124 = block_129: {
                const operand_125 = ((&value_2)).state;
                const operand_126 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_129 block_128: {
                    const operand_127 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_127).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_125).count, .mapping = (operand_125).mapping, .order = (operand_125).order, .origins = (operand_125).origins, .status = operand_126, });

                    break :block_128 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_127);
                };
            };

            const operand_130 = ((&value_2)).natives;
            const operand_131 = ((in).plan).functions;

            break :block_132 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_124, .natives = operand_130, .functions = operand_131, };
        };
    }

    const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).call(allocator, block_123: {
        const operand_118 = (in).request;
        const operand_119 = ((&value_2)).state;
        const operand_120 = value_3;

        break :block_123 block_122: {
            const operand_121 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_121).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_118, .state = operand_119, .index = operand_120, });

            break :block_122 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_121);
        };
    }));

    if (((value_4).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_117: {
            const operand_114 = value_4;
            const operand_115 = ((&value_2)).natives;
            const operand_116 = ((in).plan).functions;

            break :block_117 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_114, .natives = operand_115, .functions = operand_116, };
        };
    }

    const value_5: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_113: {
        const operand_111 = ((in).signatures).outputs;
        const operand_112 = (in).index;

        if ((operand_112 >= (operand_111).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_113 (operand_111)[@intCast(operand_112)];
    }));

    if ((value_5 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_110: {
            const operand_102 = block_107: {
                const operand_103 = value_4;
                const operand_104 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_107 block_106: {
                    const operand_105 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_105).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_103).count, .mapping = (operand_103).mapping, .order = (operand_103).order, .origins = (operand_103).origins, .status = operand_104, });

                    break :block_106 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_105);
                };
            };

            const operand_108 = ((&value_2)).natives;
            const operand_109 = ((in).plan).functions;

            break :block_110 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_102, .natives = operand_108, .functions = operand_109, };
        };
    }

    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).call(allocator, block_101: {
        const operand_96 = (in).request;
        const operand_97 = value_4;
        const operand_98 = value_5;

        break :block_101 block_100: {
            const operand_99 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_99).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_96, .state = operand_97, .index = operand_98, });

            break :block_100 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_99);
        };
    }));

    return block_95: {
        const operand_92 = value_6;
        const operand_93 = ((&value_2)).natives;
        const operand_94 = ((in).plan).functions;

        break :block_95 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_92, .natives = operand_93, .functions = operand_94, };
    };
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).signatures).inputs).len))) {
        return block_241: {
            const operand_234 = (in).plan;

            const operand_235 = block_240: {
                const operand_236 = ((in).plan).state;
                const operand_237 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_240 block_239: {
                    const operand_238 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_238).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_236).count, .mapping = (operand_236).mapping, .order = (operand_236).order, .origins = (operand_236).origins, .status = operand_237, });

                    break :block_239 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_238);
                };
            };

            break :block_241 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_234).functions, .natives = (operand_234).natives, .state = operand_235, };
        };
    }

    if ((block_233: {
        const operand_231 = (((in).plan).functions).mapping;
        const operand_232 = (in).index;

        if ((operand_232 >= (operand_231).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_233 (operand_231)[@intCast(operand_232)];
    } != @as(u64, 0))) {
        return ((in).plan).*;
    }

    const value_1: ?u32 = block_230: {
        const operand_228 = ((in).signatures).native_modules;
        const operand_229 = (in).index;

        if ((operand_229 >= (operand_228).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_230 (operand_228)[@intCast(operand_229)];
    };

    const value_2: (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (if ((value_1 == null)) block_219: {
        const operand_217 = ((in).plan).state;
        const operand_218 = ((in).plan).natives;

        break :block_219 (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_217, .natives = operand_218, };
    } else block_227: {
        const operand_226 = block_225: {
            const operand_220 = (in).request;
            const operand_221 = ((in).plan).state;
            const operand_222 = (in).modules;
            const operand_223 = ((in).plan).natives;
            const operand_224 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, value_1.?));

            break :block_225 (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .request = operand_220, .state = operand_221, .modules = operand_222, .natives = operand_223, .index = operand_224, };
        };

        break :block_227 (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBuffered(allocator, (&operand_226), .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_3 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_4 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
    });

    if (((((&value_2)).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_216: {
            const operand_213 = ((&value_2)).state;
            const operand_214 = ((&value_2)).natives;
            const operand_215 = ((in).plan).functions;

            break :block_216 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_213, .natives = operand_214, .functions = operand_215, };
        };
    }

    const value_3: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_212: {
        const operand_210 = ((in).signatures).inputs;
        const operand_211 = (in).index;

        if ((operand_211 >= (operand_210).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_212 (operand_210)[@intCast(operand_211)];
    }));

    if ((value_3 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_209: {
            const operand_201 = block_206: {
                const operand_202 = ((&value_2)).state;
                const operand_203 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_206 block_205: {
                    const operand_204 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_204).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_202).count, .mapping = (operand_202).mapping, .order = (operand_202).order, .origins = (operand_202).origins, .status = operand_203, });

                    break :block_205 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_204);
                };
            };

            const operand_207 = ((&value_2)).natives;
            const operand_208 = ((in).plan).functions;

            break :block_209 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_201, .natives = operand_207, .functions = operand_208, };
        };
    }

    const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_200: {
        const operand_199 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

        (operand_199).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_198: {
            const operand_197 = block_196: {
                const operand_193 = (in).request;
                const operand_194 = ((&value_2)).state;
                const operand_195 = value_3;

                break :block_196 (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_193, .state = operand_194, .index = operand_195, };
            };

            break :block_198 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_197), .{ .lane_0 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_1 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_2 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
        });

        break :block_200 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_199);
    };

    if (((value_4).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_192: {
            const operand_189 = value_4;
            const operand_190 = ((&value_2)).natives;
            const operand_191 = ((in).plan).functions;

            break :block_192 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_189, .natives = operand_190, .functions = operand_191, };
        };
    }

    const value_5: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_188: {
        const operand_186 = ((in).signatures).outputs;
        const operand_187 = (in).index;

        if ((operand_187 >= (operand_186).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_188 (operand_186)[@intCast(operand_187)];
    }));

    if ((value_5 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_185: {
            const operand_177 = block_182: {
                const operand_178 = value_4;
                const operand_179 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_182 block_181: {
                    const operand_180 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_180).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_178).count, .mapping = (operand_178).mapping, .order = (operand_178).order, .origins = (operand_178).origins, .status = operand_179, });

                    break :block_181 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_180);
                };
            };

            const operand_183 = ((&value_2)).natives;
            const operand_184 = ((in).plan).functions;

            break :block_185 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_177, .natives = operand_183, .functions = operand_184, };
        };
    }

    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = block_176: {
        const operand_175 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

        (operand_175).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, block_174: {
            const operand_173 = block_172: {
                const operand_169 = (in).request;
                const operand_170 = value_4;
                const operand_171 = value_5;

                break :block_172 (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_169, .state = operand_170, .index = operand_171, };
            };

            break :block_174 (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBuffered(allocator, (&operand_173), .{ .lane_0 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_1 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_2 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
        });

        break :block_176 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_175);
    };

    return block_168: {
        const operand_165 = value_6;
        const operand_166 = ((&value_2)).natives;
        const operand_167 = ((in).plan).functions;

        break :block_168 (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_165, .natives = operand_166, .functions = operand_167, };
    };
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_3c7c55850a8fcc78ec204594ef91d44f44ab65c7a9f2ee98157e35440c9bd517, buffers: struct {
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
}) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    if (((in).index >= @as(u64, (((in).signatures).inputs).len))) {
        return block_328: {
            const operand_319 = (in).plan;

            const operand_320 = block_325: {
                const operand_321 = ((in).plan).state;
                const operand_322 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_325 block_324: {
                    const operand_323 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_323).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_321).count, .mapping = (operand_321).mapping, .order = (operand_321).order, .origins = (operand_321).origins, .status = operand_322, });

                    break :block_324 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_323);
                };
            };

            break :block_328 block_327: {
                const operand_326 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_326).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .functions = (operand_319).functions, .natives = (operand_319).natives, .state = operand_320, });

                break :block_327 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_326);
            };
        };
    }

    if ((block_318: {
        const operand_316 = (((in).plan).functions).mapping;
        const operand_317 = (in).index;

        if ((operand_317 >= (operand_316).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_318 (operand_316)[@intCast(operand_317)];
    } != @as(u64, 0))) {
        return (in).plan;
    }

    const value_1: ?u32 = block_315: {
        const operand_313 = ((in).signatures).native_modules;
        const operand_314 = (in).index;

        if ((operand_314 >= (operand_313).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_315 (operand_313)[@intCast(operand_314)];
    };

    const value_2: *const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef = (if ((value_1 == null)) block_304: {
        const operand_300 = ((in).plan).state;
        const operand_301 = ((in).plan).natives;

        break :block_304 block_303: {
            const operand_302 = (try (allocator).create((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef));

            (operand_302).* = @as((zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef{ .state = operand_300, .natives = operand_301, });

            break :block_303 @as(*const (zx_abi).zx_type_577aa2577f39a210473e43eee2398d8862aa2f11a109da5f39aa8c1ad3acd8ef, operand_302);
        };
    } else (try (@import("zxc_module_27fe50cbd5fd039508237e702a30616536e43d029a076a18c935dbd19e7b7674")).callBufferedPointer(allocator, block_312: {
        const operand_305 = (in).request;
        const operand_306 = ((in).plan).state;
        const operand_307 = (in).modules;
        const operand_308 = ((in).plan).natives;
        const operand_309 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, value_1.?));

        break :block_312 block_311: {
            const operand_310 = (try (allocator).create((zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67));

            (operand_310).* = @as((zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67{ .request = operand_305, .state = operand_306, .modules = operand_307, .natives = operand_308, .index = operand_309, });

            break :block_311 @as(*const (zx_abi).zx_type_3bb059791f0cf91e0e6bd70029ec3c2a3df7cdc7ae587af6b89e40ca0dafcf67, operand_310);
        };
    }, .{ .lane_0 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_1 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_2 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_3 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_4 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), })));

    if ((((value_2).state).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_299: {
            const operand_294 = (value_2).state;
            const operand_295 = (value_2).natives;
            const operand_296 = ((in).plan).functions;

            break :block_299 block_298: {
                const operand_297 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_297).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_294, .natives = operand_295, .functions = operand_296, });

                break :block_298 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_297);
            };
        };
    }

    const value_3: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_293: {
        const operand_291 = ((in).signatures).inputs;
        const operand_292 = (in).index;

        if ((operand_292 >= (operand_291).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_293 (operand_291)[@intCast(operand_292)];
    }));

    if ((value_3 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_290: {
            const operand_280 = block_285: {
                const operand_281 = (value_2).state;
                const operand_282 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_285 block_284: {
                    const operand_283 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_283).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_281).count, .mapping = (operand_281).mapping, .order = (operand_281).order, .origins = (operand_281).origins, .status = operand_282, });

                    break :block_284 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_283);
                };
            };

            const operand_286 = (value_2).natives;
            const operand_287 = ((in).plan).functions;

            break :block_290 block_289: {
                const operand_288 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_288).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_280, .natives = operand_286, .functions = operand_287, });

                break :block_289 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_288);
            };
        };
    }

    const value_4: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBufferedPointer(allocator, block_279: {
        const operand_274 = (in).request;
        const operand_275 = (value_2).state;
        const operand_276 = value_3;

        break :block_279 block_278: {
            const operand_277 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_277).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_274, .state = operand_275, .index = operand_276, });

            break :block_278 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_277);
        };
    }, .{ .lane_0 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_1 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_2 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));

    if (((value_4).status != @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Ready))) {
        return block_273: {
            const operand_268 = value_4;
            const operand_269 = (value_2).natives;
            const operand_270 = ((in).plan).functions;

            break :block_273 block_272: {
                const operand_271 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_271).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_268, .natives = operand_269, .functions = operand_270, });

                break :block_272 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_271);
            };
        };
    }

    const value_5: u64 = (try (@import("zxc_module_2633a2737b7fbccf817d5738771e612c0a3b8016ce00630357de5441822a9f1a")).call(allocator, block_267: {
        const operand_265 = ((in).signatures).outputs;
        const operand_266 = (in).index;

        if ((operand_266 >= (operand_265).len)) {
            return error.IndexOutOfBounds;
        }

        break :block_267 (operand_265)[@intCast(operand_266)];
    }));

    if ((value_5 >= @as(u64, ((((in).request).table).kinds).len))) {
        return block_264: {
            const operand_254 = block_259: {
                const operand_255 = value_4;
                const operand_256 = @as((zx_abi).zx_type_71f95c0663b05ef1d7de55546e2ce6328327c57e5e7d163fa26d1122c635ba12, .Invalid);

                break :block_259 block_258: {
                    const operand_257 = (try (allocator).create((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108));

                    (operand_257).* = @as((zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108{ .count = (operand_255).count, .mapping = (operand_255).mapping, .order = (operand_255).order, .origins = (operand_255).origins, .status = operand_256, });

                    break :block_258 @as(*const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108, operand_257);
                };
            };

            const operand_260 = (value_2).natives;
            const operand_261 = ((in).plan).functions;

            break :block_264 block_263: {
                const operand_262 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

                (operand_262).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_254, .natives = operand_260, .functions = operand_261, });

                break :block_263 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_262);
            };
        };
    }

    const value_6: *const (zx_abi).zx_type_9a666141fb2bb56700a8d1a2cdf13d6a0b5d56520b671362061d50783cbdc108 = (try (@import("zxc_module_08715dd74fa836ca4d6b4e1e946393126ca48a11b1b91d192762fef520cb2ead")).callBufferedPointer(allocator, block_253: {
        const operand_248 = (in).request;
        const operand_249 = value_4;
        const operand_250 = value_5;

        break :block_253 block_252: {
            const operand_251 = (try (allocator).create((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3));

            (operand_251).* = @as((zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3{ .request = operand_248, .state = operand_249, .index = operand_250, });

            break :block_252 @as(*const (zx_abi).zx_type_7c9792534068df0ff84187e3ea81641ecd435d2a956c2e193ad75604def305c3, operand_251);
        };
    }, .{ .lane_0 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_1 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_2 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));

    return block_247: {
        const operand_242 = value_6;
        const operand_243 = (value_2).natives;
        const operand_244 = ((in).plan).functions;

        break :block_247 block_246: {
            const operand_245 = (try (allocator).create((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533));

            (operand_245).* = @as((zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533{ .state = operand_242, .natives = operand_243, .functions = operand_244, });

            break :block_246 @as(*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533, operand_245);
        };
    };
}

