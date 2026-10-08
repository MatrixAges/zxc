const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!*const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_1: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (try (@import("zxc_module_a567bbfeda74dddb9d1146dda0f5bc591830d9b83af9b96917db338781dcabc6")).call(allocator, block_12: {
        const operand_7 = (in).signatures;
        const operand_8 = (in).imports;
        const operand_9 = (in).plan;

        break :block_12 block_11: {
            const operand_10 = (try (allocator).create((zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27));

            (operand_10).* = @as((zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27{ .signatures = operand_7, .imports = operand_8, .plan = operand_9, });

            break :block_11 @as(*const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, operand_10);
        };
    }));

    const value_2: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (value_1).state));
    const switch_1 = value_2;

    if ((switch_1 == true)) {
        const value_3: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (try (@import("zxc_module_0e9f921cb6324a92e3f9635663c6570a06e794332d309788e479d037eec7638f")).call(allocator, block_6: {
            const operand_2 = in;
            const operand_3 = value_1;

            break :block_6 block_5: {
                const operand_4 = (try (allocator).create((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a));

                (operand_4).* = @as((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a{ .imports = (operand_2).imports, .modules = (operand_2).modules, .plan = operand_3, .request = (operand_2).request, .signatures = (operand_2).signatures, });

                break :block_5 @as(*const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, operand_4);
            };
        }));

        return value_3;
    } else {
        return value_1;
    }
}

pub fn callValue(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a) error{ IndexOutOfBounds, IntegerOverflow, OutOfMemory, Overflow, }!(zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 {
    @setRuntimeSafety(true);

    const value_1: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = block_24: {
        const operand_23 = block_22: {
            const operand_19 = (in).signatures;
            const operand_20 = (in).imports;
            const operand_21 = (in).plan;

            break :block_22 (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27{ .signatures = operand_19, .imports = operand_20, .plan = operand_21, };
        };

        break :block_24 (try (@import("zxc_module_a567bbfeda74dddb9d1146dda0f5bc591830d9b83af9b96917db338781dcabc6")).callValue(allocator, (&operand_23)));
    };

    const value_2: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, ((&value_1)).state));
    const switch_13 = value_2;

    if ((switch_13 == true)) {
        const value_3: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = block_18: {
            const operand_17 = block_16: {
                const operand_14 = in;
                const operand_15 = (&value_1);

                break :block_16 (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a{ .imports = (operand_14).imports, .modules = (operand_14).modules, .plan = operand_15, .request = (operand_14).request, .signatures = (operand_14).signatures, };
            };

            break :block_18 (try (@import("zxc_module_0e9f921cb6324a92e3f9635663c6570a06e794332d309788e479d037eec7638f")).callValue(allocator, (&operand_17)));
        };

        return ((&value_3)).*;
    } else {
        return ((&value_1)).*;
    }
}

pub fn callBuffered(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, buffers: struct {
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

    const value_1: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = block_36: {
        const operand_35 = block_34: {
            const operand_31 = (in).signatures;
            const operand_32 = (in).imports;
            const operand_33 = (in).plan;

            break :block_34 (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27{ .signatures = operand_31, .imports = operand_32, .plan = operand_33, };
        };

        break :block_36 (try (@import("zxc_module_a567bbfeda74dddb9d1146dda0f5bc591830d9b83af9b96917db338781dcabc6")).callBuffered(allocator, (&operand_35), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
    };

    const value_2: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, ((&value_1)).state));
    const switch_25 = value_2;

    if ((switch_25 == true)) {
        const value_3: (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = block_30: {
            const operand_29 = block_28: {
                const operand_26 = in;
                const operand_27 = (&value_1);

                break :block_28 (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a{ .imports = (operand_26).imports, .modules = (operand_26).modules, .plan = operand_27, .request = (operand_26).request, .signatures = (operand_26).signatures, };
            };

            break :block_30 (try (@import("zxc_module_0e9f921cb6324a92e3f9635663c6570a06e794332d309788e479d037eec7638f")).callBuffered(allocator, (&operand_29), .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));
        };

        return ((&value_3)).*;
    } else {
        return ((&value_1)).*;
    }
}

pub fn callBufferedPointer(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, buffers: struct {
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

    const value_1: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (try (@import("zxc_module_a567bbfeda74dddb9d1146dda0f5bc591830d9b83af9b96917db338781dcabc6")).callBufferedPointer(allocator, block_48: {
        const operand_43 = (in).signatures;
        const operand_44 = (in).imports;
        const operand_45 = (in).plan;

        break :block_48 block_47: {
            const operand_46 = (try (allocator).create((zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27));

            (operand_46).* = @as((zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27{ .signatures = operand_43, .imports = operand_44, .plan = operand_45, });

            break :block_47 @as(*const (zx_abi).zx_type_f7bedf744a627f5f9e313295f2ae142f3d74922830a401e1c8ab1dc3a8731a27, operand_46);
        };
    }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));

    const value_2: bool = (try (@import("zxc_module_16f592fe63ff1516122d166503322e06bff675c61ca2c8620efb5b0598c95ed3")).call(allocator, (value_1).state));
    const switch_37 = value_2;

    if ((switch_37 == true)) {
        const value_3: *const (zx_abi).zx_type_433fb1d9b3ae2012049834ee84c483c25d8afb0dbe0cfeb86f9d99861f5c4533 = (try (@import("zxc_module_0e9f921cb6324a92e3f9635663c6570a06e794332d309788e479d037eec7638f")).callBufferedPointer(allocator, block_42: {
            const operand_38 = in;
            const operand_39 = value_1;

            break :block_42 block_41: {
                const operand_40 = (try (allocator).create((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a));

                (operand_40).* = @as((zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a{ .imports = (operand_38).imports, .modules = (operand_38).modules, .plan = operand_39, .request = (operand_38).request, .signatures = (operand_38).signatures, });

                break :block_41 @as(*const (zx_abi).zx_type_f85c49c3df47ec79f40b512f5e7cc7435ce38275dcc79f6f08de78a2e040ff9a, operand_40);
            };
        }, .{ .lane_0 = (if (((buffers).lane_0 != null)) .{ .buffer = (&(((buffers).lane_0.?).buffer).*), .started = (&(((buffers).lane_0.?).started).*), } else null), .lane_1 = (if (((buffers).lane_1 != null)) .{ .buffer = (&(((buffers).lane_1.?).buffer).*), .started = (&(((buffers).lane_1.?).started).*), } else null), .lane_2 = (if (((buffers).lane_2 != null)) .{ .buffer = (&(((buffers).lane_2.?).buffer).*), .started = (&(((buffers).lane_2.?).started).*), } else null), .lane_3 = (if (((buffers).lane_3 != null)) .{ .buffer = (&(((buffers).lane_3.?).buffer).*), .started = (&(((buffers).lane_3.?).started).*), } else null), .lane_4 = (if (((buffers).lane_4 != null)) .{ .buffer = (&(((buffers).lane_4.?).buffer).*), .started = (&(((buffers).lane_4.?).started).*), } else null), .lane_5 = (if (((buffers).lane_5 != null)) .{ .buffer = (&(((buffers).lane_5.?).buffer).*), .started = (&(((buffers).lane_5.?).started).*), } else null), .lane_6 = (if (((buffers).lane_6 != null)) .{ .buffer = (&(((buffers).lane_6.?).buffer).*), .started = (&(((buffers).lane_6.?).started).*), } else null), }));

        return value_3;
    } else {
        return value_1;
    }
}

