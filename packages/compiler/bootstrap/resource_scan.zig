const std = @import("std");

const zx_type_11 = struct {
    end: u64,
    quoted: bool,
    start: u64,
    text: []const u8,
};

const zx_type_12 = struct {
    end: u64,
    literal: []const u8,
    start: u64,
};

const zx_type_14 = struct {
    end: u64,
    invalid: bool,
    references: []const *const zx_type_12,
    start: u64,
};

const zx_type_16 = struct {
    end: u64,
    index: u64,
    invalid: bool,
    references: []const *const zx_type_12,
    start: u64,
    tokens: []const *const zx_type_11,
};

const zx_type_17 = struct { []const *const zx_type_12, void, };
const zx_type_18 = struct { []const *const zx_type_11, };
const zx_type_19 = struct { []const *const zx_type_11, *const zx_type_14, };

const value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236 = struct {
    end: u64,
    invalid: bool,
    references: []const *const zx_type_12,
    start: u64,
    zx_origin: ?*const zx_type_14 = null,
};

const value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = struct {
    end: u64,
    index: u64,
    invalid: bool,
    references: []const *const zx_type_12,
    start: u64,
    tokens: []const *const zx_type_11,
    zx_origin: ?*const zx_type_16 = null,
};

const value_25405492ebcb9b2b18cc7ec605fc6a4d2516e12b1a768e6481625bc26424ef63 = struct { []const *const zx_type_12, void, ?*const zx_type_17, };
const value_83a719b0d888f707950364e129fb6e358ff72962d5b02c3e753a6eba1cf77823 = struct { []const *const zx_type_11, ?*const zx_type_18, };
const value_d4e0164c107ce7af314cde42cfde8dba1a1a8d6441887e62c1d65cc536becba0 = struct { []const *const zx_type_11, value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236, ?*const zx_type_19, };

const ZxHeader = struct {
    capacity: usize,
    committed: usize,
};

fn zxReserve(comptime T: type, allocator: ((@import("std")).mem).Allocator, items: []const T, count: usize, comptime frontier: bool) error{ OutOfMemory, }![]T {
    const offset = (comptime ((((@import("std")).mem).Alignment).of(T)).forward(@sizeOf(ZxHeader)));

    if ((frontier and ((items).len != 0))) {
        {
            const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

            if ((((current).committed == (items).len) and (count <= (current).capacity))) {
                (current).committed = count;

                return (@constCast((items).ptr))[0..count];
            }
        }
    }

    const capacity: usize = (if ((count == 0)) 0 else ((@import("std")).math).ceilPowerOfTwoAssert(usize, @max(count, 8)));
    const bytes = (try (allocator).alignedAlloc(u8, (comptime ((((@import("std")).mem).Alignment).of(T)).max((((@import("std")).mem).Alignment).of(ZxHeader))), (offset + (capacity * @sizeOf(T)))));
    const data: [*]T = @ptrCast(@alignCast(((bytes).ptr + offset)));
    const fresh: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, ((bytes).ptr + offset)) - @sizeOf(ZxHeader))));

    (fresh).* = .{ .capacity = capacity, .committed = count, };

    @memcpy((data)[0..(items).len], items);

    return (data)[0..count];
}

fn zxRetract(comptime T: type, items: []const T, length: usize) void {
    const current: *ZxHeader = @ptrCast(@alignCast((@as([*]u8, @ptrCast(@constCast((items).ptr))) - @sizeOf(ZxHeader))));

    (current).committed = length;
}

fn zxRenew(allocator: ((@import("std")).mem).Allocator, target: anytype, comptime path: []const [2][]const u8) error{ OutOfMemory, }!void {
    const V = @TypeOf((target).*);
    const info = @typeInfo(V);

    if ((info == .optional)) {
        if ((target).*) |*inner| {
            (try zxRenew(allocator, inner, path));
        }
    } else {
        if ((info == .pointer)) {
            if ((((info).pointer).size == .slice)) {
                (target).* = (try zxReserve(((info).pointer).child, allocator, (target).*, ((target).*).len, false));
            } else {
                const fresh = (try (allocator).create(((info).pointer).child));
                (fresh).* = ((target).*).*;
                (try zxRenew(allocator, fresh, path));
                (target).* = fresh;
            }
        } else {
            if (@hasField(V, ((path)[0])[1])) {
                @field((target).*, ((path)[0])[1]) = null;
            }

            (try zxRenew(allocator, (&@field((target).*, ((path)[0])[0])), (path)[1..]));
        }
    }
}

pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .string, };
const zx_shape_3 = .{ .kind = .object, .fields = .{ .end = zx_shape_0, .quoted = zx_shape_1, .start = zx_shape_0, .text = zx_shape_2, }, };
const zx_shape_4 = .{ .kind = .list, .child = zx_shape_3, };
const zx_shape_5 = .{ .kind = .object, .fields = .{ .end = zx_shape_0, .literal = zx_shape_2, .start = zx_shape_0, }, };
const zx_shape_6 = .{ .kind = .list, .child = zx_shape_5, };
const zx_shape_7 = .{ .kind = .object, .fields = .{ .end = zx_shape_0, .invalid = zx_shape_1, .references = zx_shape_6, .start = zx_shape_0, }, };
pub const input_shape = zx_shape_4;
pub const output_shape = zx_shape_7;
pub const Input = []const *const zx_type_11;
pub const Output = *const zx_type_14;

pub fn executeIn(allocator: ((std).mem).Allocator, in: []const *const zx_type_11) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const zx_type_14 {
    @setRuntimeSafety(true);

    const value_1: *const zx_type_14 = block_5: {
        const operand_1 = in;
        const operand_2 = (try function_0_value(allocator, operand_1));

        break :block_5 (if (((operand_2).zx_origin != null)) (operand_2).zx_origin.? else block_4: {
            const operand_3 = (try (allocator).create(zx_type_14));

            (operand_3).* = zx_type_14{ .end = (operand_2).end, .invalid = (operand_2).invalid, .references = (operand_2).references, .start = (operand_2).start, };

            break :block_4 @as(*const zx_type_14, operand_3);
        });
    };

    return value_1;
}

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const *const zx_type_11) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!*const zx_type_14 {
    return executeIn((arena).allocator(), in);
}

pub fn executeValue(allocator: ((std).mem).Allocator, in: []const *const zx_type_11) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236 {
    @setRuntimeSafety(true);

    const value_1: value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236 = block_6: {
        break :block_6 (try function_0_value(allocator, in));
    };

    return value_1;
}

fn function_0_value(allocator: ((std).mem).Allocator, in: []const *const zx_type_11) error{ IndexOutOfBounds, OutOfMemory, Overflow, }!value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236 {
    @setRuntimeSafety(true);

    const value_1: []const *const zx_type_12 = block_92: {
        break :block_92 (try (allocator).dupe(*const zx_type_12, (&[_]*const zx_type_12{})));
    };

    const value_19: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_91: {
        const operand_15 = block_14: {
            const operand_7 = in;
            const operand_8 = @as(u64, 0);

            const operand_9 = block_10: {
                break :block_10 value_1;
            };

            const operand_11 = false;
            const operand_12 = @as(u64, 0);
            const operand_13 = @as(u64, 0);

            break :block_14 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .tokens = operand_7, .index = operand_8, .references = operand_9, .invalid = operand_11, .start = operand_12, .end = operand_13, });
        };

        var state_6: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = operand_15;
        var state_changed_16 = false;

        while (((!(state_6).invalid) and ((state_6).index < @as(u64, ((state_6).tokens).len)))) {
            state_6 = block_89: {
                const value_4: u64 = (state_6).index;

                const value_5: zx_type_11 = (block_88: {
                    const operand_86 = (state_6).tokens;

                    const operand_87 = block_85: {
                        break :block_85 value_4;
                    };

                    if ((operand_87 >= (operand_86).len)) {
                        return error.IndexOutOfBounds;
                    }

                    break :block_88 (operand_86)[@intCast(operand_87)];
                }).*;

                const value_6: bool = ((block_77: {
                    break :block_77 value_4;
                } > @as(u64, 0)) and block_84: {
                    const operand_82 = (block_81: {
                        const operand_79 = (state_6).tokens;

                        const operand_80 = (block_78: {
                            break :block_78 value_4;
                        } - @as(u64, 1));

                        if ((operand_80 >= (operand_79).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_81 (operand_79)[@intCast(operand_80)];
                    }).text;

                    const operand_83 = @as([]const u8, ".");

                    break :block_84 ((std).mem).eql(u8, operand_82, operand_83);
                });

                const value_7: bool = (((block_69: {
                    break :block_69 value_4;
                } + @as(u64, 1)) < @as(u64, ((state_6).tokens).len)) and block_76: {
                    const operand_74 = (block_73: {
                        const operand_71 = (state_6).tokens;

                        const operand_72 = (block_70: {
                            break :block_70 value_4;
                        } + @as(u64, 1));

                        if ((operand_72 >= (operand_71).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_73 (operand_71)[@intCast(operand_72)];
                    }).text;

                    const operand_75 = @as([]const u8, "(");

                    break :block_76 ((std).mem).eql(u8, operand_74, operand_75);
                });

                const value_8: u64 = (state_6).index;

                const value_9: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_68: {
                    break :block_68 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (state_6).end, .index = (block_67: {
                        break :block_67 value_8;
                    } + @as(u64, 1)), .invalid = (state_6).invalid, .references = (state_6).references, .start = (state_6).start, .tokens = (state_6).tokens, });
                };
                const value_18: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = (if (((block_20: {
                    const operand_18 = (block_17: {
                        break :block_17 (&value_5);
                    }).text;

                    const operand_19 = @as([]const u8, "templateFile");

                    break :block_20 ((std).mem).eql(u8, operand_18, operand_19);
                } and (!block_21: {
                    break :block_21 value_6;
                })) and block_22: {
                    break :block_22 value_7;
                })) block_66: {
                    const value_10: bool = ((((block_54: {
                        break :block_54 value_4;
                    } + @as(u64, 3)) < @as(u64, ((value_9).tokens).len)) and (block_58: {
                        const operand_56 = (value_9).tokens;

                        const operand_57 = (block_55: {
                            break :block_55 value_4;
                        } + @as(u64, 2));

                        if ((operand_57 >= (operand_56).len)) {
                            return error.IndexOutOfBounds;
                        }

                        break :block_58 (operand_56)[@intCast(operand_57)];
                    }).quoted) and block_65: {
                        const operand_63 = (block_62: {
                            const operand_60 = (value_9).tokens;

                            const operand_61 = (block_59: {
                                break :block_59 value_4;
                            } + @as(u64, 3));

                            if ((operand_61 >= (operand_60).len)) {
                                return error.IndexOutOfBounds;
                            }

                            break :block_62 (operand_60)[@intCast(operand_61)];
                        }).text;

                        const operand_64 = @as([]const u8, ")");

                        break :block_65 ((std).mem).eql(u8, operand_63, operand_64);
                    });
                    const value_17: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = (if ((!block_23: {
                        break :block_23 value_10;
                    })) block_29: {
                        const value_11: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_28: {
                            break :block_28 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (value_9).end, .index = (value_9).index, .invalid = true, .references = (value_9).references, .start = (value_9).start, .tokens = (value_9).tokens, });
                        };
                        const value_12: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_27: {
                            break :block_27 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (value_11).end, .index = (value_11).index, .invalid = (value_11).invalid, .references = (value_11).references, .start = (block_26: {
                                break :block_26 (&value_5);
                            }).start, .tokens = (value_11).tokens, });
                        };
                        const value_13: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_25: {
                            break :block_25 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (block_24: {
                                break :block_24 (&value_5);
                            }).end, .index = (value_12).index, .invalid = (value_12).invalid, .references = (value_12).references, .start = (value_12).start, .tokens = (value_12).tokens, });
                        };

                        break :block_29 value_13;
                    } else block_53: {
                        const value_14: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_52: {
                            break :block_52 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (value_9).end, .index = (value_9).index, .invalid = (value_9).invalid, .references = (block_51: {
                                const operand_32 = (value_9).references;
                                const operand_48 = block_47: {
                                    const operand_33 = (block_34: {
                                        break :block_34 (&value_5);
                                    }).start;
                                    const operand_35 = (block_39: {
                                        const operand_37 = (value_9).tokens;

                                        const operand_38 = (block_36: {
                                            break :block_36 value_4;
                                        } + @as(u64, 3));

                                        if ((operand_38 >= (operand_37).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_39 (operand_37)[@intCast(operand_38)];
                                    }).end;
                                    const operand_40 = (block_44: {
                                        const operand_42 = (value_9).tokens;

                                        const operand_43 = (block_41: {
                                            break :block_41 value_4;
                                        } + @as(u64, 2));

                                        if ((operand_43 >= (operand_42).len)) {
                                            return error.IndexOutOfBounds;
                                        }

                                        break :block_44 (operand_42)[@intCast(operand_43)];
                                    }).text;

                                    break :block_47 block_46: {
                                        const operand_45 = (try (allocator).create(zx_type_12));

                                        (operand_45).* = @as(zx_type_12, zx_type_12{ .start = operand_33, .end = operand_35, .literal = operand_40, });

                                        break :block_46 @as(*const zx_type_12, operand_45);
                                    };
                                };

                                const operand_49 = (try ((std).math).add(usize, (operand_32).len, 1));
                                const operand_50 = (try zxReserve(*const zx_type_12, allocator, operand_32, operand_49, true));
                                (operand_50)[(operand_32).len] = operand_48;

                                break :block_51 @as(value_25405492ebcb9b2b18cc7ec605fc6a4d2516e12b1a768e6481625bc26424ef63, .{ operand_50, {}, null, });
                            }).@"0", .start = (value_9).start, .tokens = (value_9).tokens, });
                        };
                        const value_15: u64 = (value_14).index;

                        const value_16: value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626 = block_31: {
                            break :block_31 @as(value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626, value_de0017ba50c24e7d6ae654008bb7631b7be7cc6503327dea9f78006105568626{ .end = (value_14).end, .index = (block_30: {
                                break :block_30 value_15;
                            } + @as(u64, 3)), .invalid = (value_14).invalid, .references = (value_14).references, .start = (value_14).start, .tokens = (value_14).tokens, });
                        };

                        break :block_53 value_16;
                    });

                    break :block_66 value_17;
                } else value_9);

                break :block_89 value_18;
            };

            state_changed_16 = true;
        }

        break :block_91 (if (state_changed_16) state_6 else operand_15);
    };

    return block_5: {
        const operand_1 = (value_19).references;
        const operand_2 = (value_19).invalid;
        const operand_3 = (value_19).start;
        const operand_4 = (value_19).end;

        break :block_5 @as(value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236, value_2299bb45b12784ac909df304c0b12f67e5509b0e27e6387ec02cc4cbaf9f4236{ .references = operand_1, .invalid = operand_2, .start = operand_3, .end = operand_4, });
    };
}

