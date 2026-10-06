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
    candidate: *const zx_type_19,
    tables: *const zx_type_16,
};

pub const zx_type_23 = struct { []const u8, void, };
pub const zx_type_24 = struct { []const u32, void, };
pub const zx_type_25 = struct { []const []const u8, void, };

pub const zx_type_26 = struct {
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_27 = struct {
    candidate: *const zx_type_19,
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_28 = struct {
    candidate: *const zx_type_19,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_29 = struct {
    candidate: *const zx_type_19,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_30 = struct {
    fields: *const zx_type_18,
    name: []const u8,
};

pub const zx_type_31 = struct {
    fields: *const zx_type_18,
    index: u64,
    name: []const u8,
};

pub const zx_type_32 = struct {
    fields: *const zx_type_18,
    index: u64,
    names: []const []const u8,
    sorted: []const u32,
};

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

pub const value_zx_type_22_f9f434bc9d0869ee4fe93b8f2d75449d97ec21cc1ea12455f1df810be7821e22 = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_23, };
pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_24, };
pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_25, };

pub const value_zx_type_26_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_2c4a87f781c651962259ae1ef67d878ae312a61c3d14b66307e5fd0a9c7f1e1e = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_24cb83be264601bd878a3a89f4dc79e53724e5f2364f209841a04e7a327c23bf = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_0e70c693f6adee041b71153b65d39c537ba5de74cae3bc9eba48950bd94db775 = struct {
    candidate: value_zx_type_19_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_758dce47268ce260391b79fcce19430100f29f81aa06dca556ac6c937c9b34ac = struct {
    fields: value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    name: []const u8,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_b136b1d01bf66184f41ee2f39a29133b575d8ab64b8482edb58d6f8c2be9e268 = struct {
    fields: value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    index: u64,
    name: []const u8,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_bb9acc4b5ca34576bdffb316733b6b1e3d98e910d36f68b0607ed6833555aa6a = struct {
    fields: value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    index: u64,
    names: []const []const u8,
    sorted: []const u32,
    zx_origin: ?*const zx_type_32 = null,
};

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
