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
    kind: u8,
    member: []const u8,
    owner: []const u8,
};

pub const zx_type_23 = struct {
    ids: []const u32,
    kinds: []const u8,
    members: []const []const u8,
    owners: []const []const u8,
};

pub const zx_type_24 = struct {
    base: *const zx_type_23,
    delta: *const zx_type_23,
};

pub const zx_type_25 = enum { Missing, Found, Conflict, };

pub const zx_type_26 = struct {
    id: u32,
    status: zx_type_25,
};

pub const zx_type_27 = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
};

pub const zx_type_28 = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    previous: u64,
    unique: bool,
};

pub const zx_type_29 = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
};

pub const zx_type_30 = struct {
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
};

pub const zx_type_31 = struct {
    count: u64,
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
    valid: bool,
};

pub const zx_type_32 = struct { *const zx_type_30, };
pub const zx_type_33 = struct { *const zx_type_30, bool, };

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
    kind: u8,
    member: []const u8,
    owner: []const u8,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_23,
    delta: *const zx_type_23,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    id: u32,
    status: zx_type_25,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    previous: u64,
    unique: bool,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    count: u64,
    index: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    table: *const zx_type_15,
    valid: bool,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_30_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_32, };
pub const value_zx_type_33_654b20ccf64f2ca64b6802425f9952e8447842f7a750a25aaabc98a2fcd9a52f = struct { value_zx_type_30_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, bool, ?*const zx_type_33, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_ab1a63d8cf97838215788706211de53a5d41e9d88c5ec7cc04f2fc8dfe34676e" = struct {
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
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_ab1a63d8cf97838215788706211de53a5d41e9d88c5ec7cc04f2fc8dfe34676e" = struct {
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_ab1a63d8cf97838215788706211de53a5d41e9d88c5ec7cc04f2fc8dfe34676e";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_ab1a63d8cf97838215788706211de53a5d41e9d88c5ec7cc04f2fc8dfe34676e";
};

