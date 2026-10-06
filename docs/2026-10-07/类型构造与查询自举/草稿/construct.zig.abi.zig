pub const zx_type_11 = opaque {};
pub const zx_type_12 = enum { TaskContainer, VoidList, TaskTuple, TaskObject, NativeTask, NestedTask, };
pub const zx_type_16 = struct { *const zx_type_11, u64, };
pub const zx_type_17 = struct { *const zx_type_11, zx_type_12, };
pub const zx_type_18 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_19 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_20 = struct {
    base: *const zx_type_19,
    delta: *const zx_type_19,
};

pub const zx_type_21 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_18,
    label: []const u8,
    second: u32,
};

pub const zx_type_22 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_23 = struct {
    children: []const u32,
    fields: *const zx_type_22,
    first: u32,
    kind: zx_type_18,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_24 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_25 = struct {
    delta: *const zx_type_19,
    id: u32,
};

pub const zx_type_26 = struct {
    children: []const u32,
    count: u64,
    field_names: []const []const u8,
    field_types: []const u32,
    first: u32,
    kind: zx_type_18,
    label: []const u8,
    names: []const []const u8,
    offset: u64,
    second: u32,
};

pub const zx_type_27 = struct {
    left: *const zx_type_26,
    right: *const zx_type_26,
};

pub const zx_type_28 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_26,
    right: *const zx_type_26,
};

pub const zx_type_29 = struct {
    index: u64,
    table: *const zx_type_19,
};

pub const zx_type_30 = struct {
    candidate: *const zx_type_23,
    id: u32,
    tables: *const zx_type_20,
};

pub const zx_type_31 = struct {
    candidate: *const zx_type_23,
    tables: *const zx_type_20,
};

pub const zx_type_32 = struct {
    candidate: *const zx_type_23,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_20,
};

pub const zx_type_33 = opaque {};
pub const zx_type_34 = struct { *const zx_type_33, u64, };
pub const zx_type_35 = struct { *const zx_type_33, u64, bool, };

pub const zx_type_36 = struct {
    flags: *const zx_type_33,
    index: u64,
    native_references: bool,
    table: *const zx_type_19,
};

pub const zx_type_37 = struct {
    children: []const u32,
    count: u64,
    flags: *const zx_type_33,
    found: bool,
    index: u64,
    offset: u64,
};

pub const zx_type_38 = struct {
    flags: *const zx_type_33,
    id: u32,
    native_references: bool,
    table: *const zx_type_19,
};

pub const zx_type_39 = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_19,
    target: zx_type_18,
};

pub const zx_type_40 = struct {
    flags: *const zx_type_33,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_19,
};

pub const zx_type_41 = enum { None, TaskContainer, VoidList, TaskTuple, TaskObject, };

pub const zx_type_42 = struct {
    candidate: *const zx_type_23,
    table: *const zx_type_19,
};

pub const zx_type_43 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    table: *const zx_type_19,
};

pub const zx_type_44 = struct {
    flags: *const zx_type_33,
    writer: *const zx_type_11,
};

pub const zx_type_45 = struct {
    index: u64,
    writer: *const zx_type_11,
};

pub const zx_type_46 = struct { *const zx_type_44, };
pub const zx_type_47 = struct { *const zx_type_44, u64, };

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_19,
    delta: *const zx_type_19,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_18,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_18,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_19,
    id: u32,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_27_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    left: *const zx_type_26,
    right: *const zx_type_26,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    equal: bool,
    index: u64,
    left: *const zx_type_26,
    right: *const zx_type_26,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e = struct {
    candidate: value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    id: u32,
    tables: value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22 = struct {
    candidate: value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    tables: value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = struct {
    candidate: value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_36_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    flags: *const zx_type_33,
    index: u64,
    native_references: bool,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    children: []const u32,
    count: u64,
    flags: *const zx_type_33,
    found: bool,
    index: u64,
    offset: u64,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    flags: *const zx_type_33,
    id: u32,
    native_references: bool,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_39_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_19,
    target: zx_type_18,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    flags: *const zx_type_33,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_40 = null,
};

pub const value_zx_type_42_655f2c15f8b96113ed59dee46636710e0c7433f1f71d56fc2c400bda5a955e85 = struct {
    candidate: value_zx_type_23_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_42 = null,
};

pub const value_zx_type_43_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    children: []const u32,
    found: bool,
    index: u64,
    table: *const zx_type_19,
    zx_origin: ?*const zx_type_43 = null,
};

pub const value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    flags: *const zx_type_33,
    writer: *const zx_type_11,
    zx_origin: ?*const zx_type_44 = null,
};

pub const value_zx_type_45_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    index: u64,
    writer: *const zx_type_11,
    zx_origin: ?*const zx_type_45 = null,
};

pub const value_zx_type_46_ed98ab2d684155f0f16edf3c906e8b7cce9beb0c415885713abde878f5ffabc6 = struct { value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, ?*const zx_type_46, };
pub const value_zx_type_47_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac = struct { value_zx_type_44_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814, u64, ?*const zx_type_47, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_2adc929024dde49a7441ba38589c46d11e7122512ba689014f7851ca810c9c20" = struct {
        pub const Writer = *const zx_type_11;
        pub const Message = zx_type_12;
        pub const kinds = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u8;
        };
        pub const first = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const second = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const labels = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const []const u8;
        };
        pub const children = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const allFieldTypes = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const allFieldNames = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const []const u8;
        };
        pub const names = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const []const u8;
        };
        pub const candidateKind = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u8;
        };
        pub const candidateFirst = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u32;
        };
        pub const candidateSecond = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u32;
        };
        pub const references = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const fieldNames = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const []const u8;
        };
        pub const fieldTypes = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const u32;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const u32;
        };
        pub const memberNames = struct {
            pub const Input = *const zx_type_11;
            pub const Output = []const []const u8;
            pub const InputValue = zx_type_11;
            pub const OutputValue = []const []const u8;
        };
        pub const prepareNames = struct {
            pub const Input = *const zx_type_11;
            pub const Output = void;
            pub const InputValue = zx_type_11;
            pub const OutputValue = void;
        };
        pub const copyName = struct {
            pub const Input = *const zx_type_16;
            pub const Output = void;
            pub const InputValue = zx_type_16;
            pub const OutputValue = void;
        };
        pub const sortNames = struct {
            pub const Input = *const zx_type_11;
            pub const Output = void;
            pub const InputValue = zx_type_11;
            pub const OutputValue = void;
        };
        pub const append = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u64;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u64;
        };
        pub const failType = struct {
            pub const Input = *const zx_type_17;
            pub const Output = void;
            pub const InputValue = zx_type_17;
            pub const OutputValue = void;
        };
        pub const failOwnership = struct {
            pub const Input = *const zx_type_17;
            pub const Output = void;
            pub const InputValue = zx_type_17;
            pub const OutputValue = void;
        };
        pub const failCapability = struct {
            pub const Input = *const zx_type_17;
            pub const Output = void;
            pub const InputValue = zx_type_17;
            pub const OutputValue = void;
        };
    };
    pub const @"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const narrow = struct {
            pub const Input = u64;
            pub const Output = u32;
            pub const InputValue = u64;
            pub const OutputValue = u32;
        };
    };
    pub const @"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc" = struct {
        pub const Flags = *const zx_type_33;
        pub const allocate = struct {
            pub const Input = *const zx_type_34;
            pub const Output = void;
            pub const InputValue = zx_type_34;
            pub const OutputValue = void;
        };
        pub const get = struct {
            pub const Input = *const zx_type_34;
            pub const Output = bool;
            pub const InputValue = zx_type_34;
            pub const OutputValue = bool;
        };
        pub const set = struct {
            pub const Input = *const zx_type_35;
            pub const Output = void;
            pub const InputValue = zx_type_35;
            pub const OutputValue = void;
        };
        pub const release = struct {
            pub const Input = *const zx_type_33;
            pub const Output = void;
            pub const InputValue = zx_type_33;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_2adc929024dde49a7441ba38589c46d11e7122512ba689014f7851ca810c9c20" = struct {
        pub const Writer = zx_type_11;
        pub const Message = zx_type_12;
    };
    pub const @"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393" = struct {
    };
    pub const @"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc" = struct {
        pub const Flags = zx_type_33;
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393";
    pub const @"zig:construction" = (native_by_identity).@"zig:zxc_native_2adc929024dde49a7441ba38589c46d11e7122512ba689014f7851ca810c9c20";
    pub const @"zig:type_flags" = (native_by_identity).@"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393";
    pub const @"zig:construction" = (layouts_by_identity).@"zig:zxc_native_2adc929024dde49a7441ba38589c46d11e7122512ba689014f7851ca810c9c20";
    pub const @"zig:type_flags" = (layouts_by_identity).@"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc";
};
