pub const zx_type_11 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_15 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_16 = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
};

pub const zx_type_17 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    second: u32,
};

pub const zx_type_18 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_19 = struct {
    children: []const u32,
    fields: *const zx_type_18,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_20 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_21 = struct {
    delta: *const zx_type_15,
    id: u32,
};

pub const zx_type_22 = struct {
    maximum_count: u64,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_23 = struct {
    child_end: u64,
    field_end: u64,
    index: u64,
    name_end: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
};

pub const zx_type_24 = opaque {};
pub const zx_type_25 = struct { *const zx_type_24, u64, };
pub const zx_type_26 = struct { *const zx_type_24, u64, u64, };

pub const zx_type_27 = struct {
    count: u64,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    object: bool,
    table: *const zx_type_15,
};

pub const zx_type_28 = struct {
    count: u64,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    object: bool,
    owner: u64,
    table: *const zx_type_15,
    valid: bool,
    values: []const u32,
};

pub const zx_type_29 = struct {
    count: u64,
    errors: bool,
    first: u64,
    names: *const zx_type_24,
    values: []const []const u8,
};

pub const zx_type_30 = struct {
    count: u64,
    errors: bool,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    valid: bool,
    values: []const []const u8,
};

pub const zx_type_31 = struct {
    count: u64,
    first: u64,
    index: u64,
    member: []const u8,
    unique: bool,
    values: []const []const u8,
};

pub const zx_type_32 = struct {
    index: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_33 = struct {
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_34 = struct {
    index: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
};

pub const zx_type_35 = struct {
    maximum_count: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_36 = struct { *const zx_type_35, };
pub const zx_type_37 = struct { *const zx_type_35, bool, };
pub const zx_type_38 = struct { *const zx_type_35, bool, bool, };

pub const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_15,
    delta: *const zx_type_15,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_18 = null,
};

pub const value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_15,
    id: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    maximum_count: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    child_end: u64,
    field_end: u64,
    index: u64,
    name_end: u64,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_27_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    object: bool,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_36e32a7d36ecb8b71dbe7e25a4158128c7836c2521d5fee40349f25f49cdbf83 = struct {
    count: u64,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    object: bool,
    owner: u64,
    table: *const zx_type_15,
    valid: bool,
    values: []const u32,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    count: u64,
    errors: bool,
    first: u64,
    names: *const zx_type_24,
    values: []const []const u8,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    count: u64,
    errors: bool,
    first: u64,
    index: u64,
    names: *const zx_type_24,
    valid: bool,
    values: []const []const u8,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    first: u64,
    index: u64,
    member: []const u8,
    unique: bool,
    values: []const []const u8,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
    valid: bool,
    zx_origin: ?*const zx_type_34 = null,
};

pub const value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    maximum_count: u64,
    names: *const zx_type_24,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_35 = null,
};

pub const value_zx_type_36_009b209c29dfed37d6f0ddf10651eb819801430299ea03fd6bf9a11471606d6e = struct { value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, ?*const zx_type_36, };
pub const value_zx_type_37_9068dcb27588fc549cd15008d3bd15e507480c6631115fd15614e1d02077b29f = struct { value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, bool, ?*const zx_type_37, };
pub const value_zx_type_38_9e473f196db28165f17fa02012d877e38b20b2fdd7fbf0bd932a3b8513569fa0 = struct { value_zx_type_35_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165, bool, bool, ?*const zx_type_38, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_df4a2b46817b0eb5c182c0f5cd68986e8afd5236bbf5273461f1f7bf9cb356f1" = struct {
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
    pub const @"zig:zxc_native_fd6fd88c05c8adda0d65ae516862fb31c32b3c4c181ad15016e019fe56f8b464" = struct {
        pub const Names = *const zx_type_24;
        pub const validLabel = struct {
            pub const Input = *const zx_type_25;
            pub const Output = bool;
            pub const InputValue = zx_type_25;
            pub const OutputValue = bool;
        };
        pub const validMember = struct {
            pub const Input = *const zx_type_25;
            pub const Output = bool;
            pub const InputValue = zx_type_25;
            pub const OutputValue = bool;
        };
        pub const fieldsAscending = struct {
            pub const Input = *const zx_type_26;
            pub const Output = bool;
            pub const InputValue = zx_type_26;
            pub const OutputValue = bool;
        };
        pub const membersAscending = struct {
            pub const Input = *const zx_type_26;
            pub const Output = bool;
            pub const InputValue = zx_type_26;
            pub const OutputValue = bool;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_df4a2b46817b0eb5c182c0f5cd68986e8afd5236bbf5273461f1f7bf9cb356f1" = struct {
    };
    pub const @"zig:zxc_native_fd6fd88c05c8adda0d65ae516862fb31c32b3c4c181ad15016e019fe56f8b464" = struct {
        pub const Names = zx_type_24;
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_df4a2b46817b0eb5c182c0f5cd68986e8afd5236bbf5273461f1f7bf9cb356f1";
    pub const @"zig:type_names" = (native_by_identity).@"zig:zxc_native_fd6fd88c05c8adda0d65ae516862fb31c32b3c4c181ad15016e019fe56f8b464";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_df4a2b46817b0eb5c182c0f5cd68986e8afd5236bbf5273461f1f7bf9cb356f1";
    pub const @"zig:type_names" = (layouts_by_identity).@"zig:zxc_native_fd6fd88c05c8adda0d65ae516862fb31c32b3c4c181ad15016e019fe56f8b464";
};

