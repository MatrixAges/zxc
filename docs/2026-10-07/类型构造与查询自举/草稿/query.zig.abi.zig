pub const zx_type_11 = opaque {};
pub const zx_type_12 = struct { *const zx_type_11, u64, };
pub const zx_type_13 = struct { *const zx_type_11, u64, bool, };
pub const zx_type_14 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_18 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_19 = struct {
    base: *const zx_type_18,
    delta: *const zx_type_18,
};

pub const zx_type_20 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_14,
    label: []const u8,
    second: u32,
};

pub const zx_type_21 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_22 = struct {
    children: []const u32,
    fields: *const zx_type_21,
    first: u32,
    kind: zx_type_14,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_23 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_24 = struct {
    delta: *const zx_type_18,
    id: u32,
};

pub const zx_type_25 = struct {
    flags: *const zx_type_11,
    index: u64,
    native_references: bool,
    table: *const zx_type_18,
};

pub const zx_type_26 = struct {
    children: []const u32,
    count: u64,
    flags: *const zx_type_11,
    found: bool,
    index: u64,
    offset: u64,
};

pub const zx_type_27 = struct {
    flags: *const zx_type_11,
    id: u32,
    native_references: bool,
    table: *const zx_type_18,
};

pub const zx_type_28 = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_18,
    target: zx_type_14,
};

pub const zx_type_29 = struct {
    flags: *const zx_type_11,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_18,
};

pub const zx_type_30 = struct { *const zx_type_27, };
pub const zx_type_31 = struct { *const zx_type_27, bool, };

pub const value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_18,
    delta: *const zx_type_18,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_14,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_14,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_18,
    id: u32,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    flags: *const zx_type_11,
    index: u64,
    native_references: bool,
    table: *const zx_type_18,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    children: []const u32,
    count: u64,
    flags: *const zx_type_11,
    found: bool,
    index: u64,
    offset: u64,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    flags: *const zx_type_11,
    id: u32,
    native_references: bool,
    table: *const zx_type_18,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    found: bool,
    index: u64,
    limit: u64,
    table: *const zx_type_18,
    target: zx_type_14,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    flags: *const zx_type_11,
    index: u64,
    limit: u64,
    native_references: bool,
    table: *const zx_type_18,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_009b209c29dfed37d6f0ddf10651eb819801430299ea03fd6bf9a11471606d6e = struct { value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, ?*const zx_type_30, };
pub const value_zx_type_31_9068dcb27588fc549cd15008d3bd15e507480c6631115fd15614e1d02077b29f = struct { value_zx_type_27_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, bool, ?*const zx_type_31, };

pub const native_by_identity = struct {
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
        pub const Flags = *const zx_type_11;
        pub const allocate = struct {
            pub const Input = *const zx_type_12;
            pub const Output = void;
            pub const InputValue = zx_type_12;
            pub const OutputValue = void;
        };
        pub const get = struct {
            pub const Input = *const zx_type_12;
            pub const Output = bool;
            pub const InputValue = zx_type_12;
            pub const OutputValue = bool;
        };
        pub const set = struct {
            pub const Input = *const zx_type_13;
            pub const Output = void;
            pub const InputValue = zx_type_13;
            pub const OutputValue = void;
        };
        pub const release = struct {
            pub const Input = *const zx_type_11;
            pub const Output = void;
            pub const InputValue = zx_type_11;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393" = struct {
    };
    pub const @"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc" = struct {
        pub const Flags = zx_type_11;
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393";
    pub const @"zig:type_flags" = (native_by_identity).@"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_702f5f4b3b53876f4b39755d01426e061a40d9d3462ca6a50d34d83d0cd1e393";
    pub const @"zig:type_flags" = (layouts_by_identity).@"zig:zxc_native_60a7adeca35f707f32145951920413f7f68d4577c3decfa59e7eaec01f83fdcc";
};
