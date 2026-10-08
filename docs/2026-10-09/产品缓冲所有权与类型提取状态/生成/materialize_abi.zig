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

pub const zx_type_27 = enum { Invalid, MissingOrigin, Ready, };

pub const zx_type_29 = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
    origins: []const u64,
    status: zx_type_27,
};

pub const zx_type_30 = struct {
    index: u64,
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    scalar_count: u64,
    table: *const zx_type_15,
};

pub const zx_type_31 = struct {
    plan: *const zx_type_29,
    table: *const zx_type_15,
};

pub const zx_type_32 = struct {
    index: u64,
    member: u64,
    plan: *const zx_type_29,
    source: *const zx_type_15,
    table: *const zx_type_15,
};

pub const zx_type_33 = struct { []const u8, void, };
pub const zx_type_34 = struct { []const u32, void, };
pub const zx_type_35 = struct { []const []const u8, void, };

pub const zx_type_36 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
};

pub const zx_type_37 = struct {
    index: u64,
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    source: *const zx_type_23,
};

pub const zx_type_38 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
};

pub const zx_type_39 = struct {
    origins: *const zx_type_23,
    plan: *const zx_type_29,
    table: *const zx_type_15,
};

pub const zx_type_40 = struct { *const zx_type_39, };
pub const zx_type_41 = struct { *const zx_type_39, *const zx_type_15, };
pub const zx_type_42 = struct { *const zx_type_39, *const zx_type_15, *const zx_type_23, };

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

pub const value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    count: u64,
    mapping: []const u64,
    order: []const u32,
    origins: []const u64,
    status: zx_type_27,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    index: u64,
    maximum_count: u64,
    names: []const []const u8,
    origins: *const zx_type_23,
    scalar_count: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_b4c00b0680a164f9ad85cafef49c2f1d31566b1a676a14d85e4570178e088fb9 = struct {
    plan: value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_7743a070b917c662bc2e1be970da7aac86f39c6ea627483252ec49d816e5a235 = struct {
    index: u64,
    member: u64,
    plan: value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    source: *const zx_type_15,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_33, };
pub const value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_34, };
pub const value_zx_type_35_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_35, };

pub const value_zx_type_36_e766e5a134edd1a7902c0d5d489b919f656420f490d9e55c01ece70ba97e7603 = struct {
    origins: *const zx_type_23,
    plan: value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    zx_origin: ?*const zx_type_36 = null,
};

pub const value_zx_type_37_21e4f8ef344e503f822fcb829467993616ac72b250c11649bad4e903e93caa0c = struct {
    index: u64,
    origins: *const zx_type_23,
    plan: value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    source: *const zx_type_23,
    zx_origin: ?*const zx_type_37 = null,
};

pub const value_zx_type_38_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    origins: *const zx_type_23,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_38 = null,
};

pub const value_zx_type_39_95dc6b5df4a3ad758ac0805408bd8dfc8819ad77db483e3a37c2079f379e61db = struct {
    origins: *const zx_type_23,
    plan: value_zx_type_29_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_39 = null,
};

pub const value_zx_type_40_5b864f96f3ba9dd1dbab76f01982658b55a306fb9dad3e9a7eb1a17fff9b2f1f = struct { value_zx_type_39_95dc6b5df4a3ad758ac0805408bd8dfc8819ad77db483e3a37c2079f379e61db, ?*const zx_type_40, };
pub const value_zx_type_41_cd2575fe5fba3484379adb965678c5b529dabf6342901dd1867ca19aeefde725 = struct { value_zx_type_39_95dc6b5df4a3ad758ac0805408bd8dfc8819ad77db483e3a37c2079f379e61db, *const zx_type_15, ?*const zx_type_41, };
pub const value_zx_type_42_4cf7745044134684f3b927cfae5239db1055c9804efd4779ee87ede21450d5b1 = struct { value_zx_type_39_95dc6b5df4a3ad758ac0805408bd8dfc8819ad77db483e3a37c2079f379e61db, *const zx_type_15, *const zx_type_23, ?*const zx_type_42, };

pub const native = struct {
    pub const @"zig:integers" = struct {
        pub const widen = struct {
            pub const Input = u32;
            pub const Output = u64;
            pub const InputValue = u32;
            pub const OutputValue = u64;
        };
        pub const widenByte = struct {
            pub const Input = u8;
            pub const Output = u64;
            pub const InputValue = u8;
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

pub const layouts = struct {
    pub const @"zig:integers" = struct {
    };
};

