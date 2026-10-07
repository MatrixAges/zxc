const std = @import("std");
const zx_type_11 = enum { Invalid, Module, Import, Call, Task, Parallel, Switch, Case, Default, Emit, Return, Gateway, Group, Route, Store, StoreRef, Object, Field, };
const zx_type_12 = enum { String, OptionalString, Unsigned, Protocol, Method, };

const zx_type_13 = struct {
    fallback: u64,
    kind: zx_type_12,
    name: []const u8,
    required: bool,
};

pub const Input = []const u8;
pub const Output = zx_type_11;
pub const consumes_input = false;
pub const requires_io = false;
pub const requires_process = false;
const zx_shape_0 = .{ .kind = .scalar, };
const zx_shape_1 = .{ .kind = .scalar, };
const zx_shape_2 = .{ .kind = .scalar, };
const zx_shape_3 = .{ .kind = .scalar, };
const zx_shape_4 = .{ .kind = .scalar, };
const zx_shape_5 = .{ .kind = .scalar, };
const zx_shape_6 = .{ .kind = .scalar, };
const zx_shape_7 = .{ .kind = .scalar, };
const zx_shape_8 = .{ .kind = .scalar, };
const zx_shape_9 = .{ .kind = .scalar, };
const zx_shape_10 = .{ .kind = .string, };
const zx_shape_11 = .{ .kind = .scalar, };
const zx_shape_12 = .{ .kind = .scalar, };
const zx_shape_13 = .{ .kind = .object, .fields = .{ .fallback = zx_shape_5, .kind = zx_shape_12, .name = zx_shape_10, .required = zx_shape_1, }, };
pub const input_shape = zx_shape_10;
pub const output_shape = zx_shape_11;

pub fn execute(arena: *((std).heap).ArenaAllocator, in: []const u8) error{ }!zx_type_11 {
    @setRuntimeSafety(true);

    _ = arena;

    const switch_1 = in;

    if (block_49: {
        const operand_47 = switch_1;
        const operand_48 = @as([]const u8, "Module");

        break :block_49 ((std).mem).eql(u8, operand_47, operand_48);
    }) {
        return @as(zx_type_11, .Module);
    } else {
        if (block_46: {
            const operand_44 = switch_1;
            const operand_45 = @as([]const u8, "Import");

            break :block_46 ((std).mem).eql(u8, operand_44, operand_45);
        }) {
            return @as(zx_type_11, .Import);
        } else {
            if (block_43: {
                const operand_41 = switch_1;
                const operand_42 = @as([]const u8, "Call");

                break :block_43 ((std).mem).eql(u8, operand_41, operand_42);
            }) {
                return @as(zx_type_11, .Call);
            } else {
                if (block_40: {
                    const operand_38 = switch_1;
                    const operand_39 = @as([]const u8, "Task");

                    break :block_40 ((std).mem).eql(u8, operand_38, operand_39);
                }) {
                    return @as(zx_type_11, .Task);
                } else {
                    if (block_37: {
                        const operand_35 = switch_1;
                        const operand_36 = @as([]const u8, "Parallel");

                        break :block_37 ((std).mem).eql(u8, operand_35, operand_36);
                    }) {
                        return @as(zx_type_11, .Parallel);
                    } else {
                        if (block_34: {
                            const operand_32 = switch_1;
                            const operand_33 = @as([]const u8, "Switch");

                            break :block_34 ((std).mem).eql(u8, operand_32, operand_33);
                        }) {
                            return @as(zx_type_11, .Switch);
                        } else {
                            if (block_31: {
                                const operand_29 = switch_1;
                                const operand_30 = @as([]const u8, "Case");

                                break :block_31 ((std).mem).eql(u8, operand_29, operand_30);
                            }) {
                                return @as(zx_type_11, .Case);
                            } else {
                                if (block_28: {
                                    const operand_26 = switch_1;
                                    const operand_27 = @as([]const u8, "Default");

                                    break :block_28 ((std).mem).eql(u8, operand_26, operand_27);
                                }) {
                                    return @as(zx_type_11, .Default);
                                } else {
                                    if (block_25: {
                                        const operand_23 = switch_1;
                                        const operand_24 = @as([]const u8, "Emit");

                                        break :block_25 ((std).mem).eql(u8, operand_23, operand_24);
                                    }) {
                                        return @as(zx_type_11, .Emit);
                                    } else {
                                        if (block_22: {
                                            const operand_20 = switch_1;
                                            const operand_21 = @as([]const u8, "Return");

                                            break :block_22 ((std).mem).eql(u8, operand_20, operand_21);
                                        }) {
                                            return @as(zx_type_11, .Return);
                                        } else {
                                            if (block_19: {
                                                const operand_17 = switch_1;
                                                const operand_18 = @as([]const u8, "Gateway");

                                                break :block_19 ((std).mem).eql(u8, operand_17, operand_18);
                                            }) {
                                                return @as(zx_type_11, .Gateway);
                                            } else {
                                                if (block_16: {
                                                    const operand_14 = switch_1;
                                                    const operand_15 = @as([]const u8, "Group");

                                                    break :block_16 ((std).mem).eql(u8, operand_14, operand_15);
                                                }) {
                                                    return @as(zx_type_11, .Group);
                                                } else {
                                                    if (block_13: {
                                                        const operand_11 = switch_1;
                                                        const operand_12 = @as([]const u8, "Route");

                                                        break :block_13 ((std).mem).eql(u8, operand_11, operand_12);
                                                    }) {
                                                        return @as(zx_type_11, .Route);
                                                    } else {
                                                        if (block_10: {
                                                            const operand_8 = switch_1;
                                                            const operand_9 = @as([]const u8, "Store");

                                                            break :block_10 ((std).mem).eql(u8, operand_8, operand_9);
                                                        }) {
                                                            return @as(zx_type_11, .Store);
                                                        } else {
                                                            if (block_7: {
                                                                const operand_5 = switch_1;
                                                                const operand_6 = @as([]const u8, "Object");

                                                                break :block_7 ((std).mem).eql(u8, operand_5, operand_6);
                                                            }) {
                                                                return @as(zx_type_11, .Object);
                                                            } else {
                                                                if (block_4: {
                                                                    const operand_2 = switch_1;
                                                                    const operand_3 = @as([]const u8, "Field");

                                                                    break :block_4 ((std).mem).eql(u8, operand_2, operand_3);
                                                                }) {
                                                                    return @as(zx_type_11, .Field);
                                                                } else {
                                                                    return @as(zx_type_11, .Invalid);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

