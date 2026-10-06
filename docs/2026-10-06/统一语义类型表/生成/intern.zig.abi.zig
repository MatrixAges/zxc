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
    name: []const u8,
    type_id: u32,
};

pub const zx_type_20 = struct {
    children: []const u32,
    fields: []const *const zx_type_18,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_21 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_22 = struct {
    delta: *const zx_type_15,
    id: u32,
};

pub const zx_type_23 = struct {
    candidate: *const zx_type_20,
    tables: *const zx_type_16,
};

pub const zx_type_24 = struct { []const u8, void, };
pub const zx_type_25 = struct { []const u32, void, };
pub const zx_type_26 = struct { []const []const u8, void, };

pub const zx_type_27 = struct {
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_28 = struct {
    candidate: *const zx_type_20,
    id: u32,
    tables: *const zx_type_16,
};

pub const zx_type_29 = struct {
    candidate: *const zx_type_20,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_15,
};

pub const zx_type_30 = struct {
    candidate: *const zx_type_20,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: *const zx_type_16,
};

pub const zx_type_31 = struct {
    fields: []const *const zx_type_18,
    name: []const u8,
};

pub const zx_type_32 = struct {
    fields: []const *const zx_type_18,
    index: u64,
    name: []const u8,
};

pub const zx_type_33 = struct {
    fields: []const *const zx_type_18,
    index: u64,
    names: []const []const u8,
    sorted: []const *const zx_type_18,
};

pub const zx_type_34 = struct { []const *const zx_type_18, void, };

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

pub const value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca = struct {
    children: []const u32,
    fields: []const *const zx_type_18,
    first: u32,
    kind: zx_type_11,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_15,
    id: u32,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_00e3ef3b64e3e127eced7e87f8ee6775b4dcd73d40450fbd3ce817a1a99b043e = struct {
    candidate: value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u8, void, ?*const zx_type_24, };
pub const value_zx_type_25_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const u32, void, ?*const zx_type_25, };
pub const value_zx_type_26_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const []const u8, void, ?*const zx_type_26, };

pub const value_zx_type_27_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_27 = null,
};

pub const value_zx_type_28_867ec9aa987e04cef9004f10d74da0de91acec53c3b161384080c48e933b23d1 = struct {
    candidate: value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    id: u32,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_28 = null,
};

pub const value_zx_type_29_d2e4d06425605a3095bd6f7957b18e3af692840d1bc8f7fe99cedf53cd1f64ef = struct {
    candidate: value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    count: u64,
    equal: bool,
    first: u64,
    index: u64,
    table: *const zx_type_15,
    zx_origin: ?*const zx_type_29 = null,
};

pub const value_zx_type_30_ffc066d5fdba52f06be097a41e07a127b186f7a443dfeddb5e35d31f2546a0e3 = struct {
    candidate: value_zx_type_20_22fe918e18f9428f62efcc8e91e15b66c5ac26027d11257c6c444d8c51b7c4ca,
    count: u64,
    found: bool,
    id: u32,
    index: u64,
    tables: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_30 = null,
};

pub const value_zx_type_31_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    fields: []const *const zx_type_18,
    name: []const u8,
    zx_origin: ?*const zx_type_31 = null,
};

pub const value_zx_type_32_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    fields: []const *const zx_type_18,
    index: u64,
    name: []const u8,
    zx_origin: ?*const zx_type_32 = null,
};

pub const value_zx_type_33_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    fields: []const *const zx_type_18,
    index: u64,
    names: []const []const u8,
    sorted: []const *const zx_type_18,
    zx_origin: ?*const zx_type_33 = null,
};

pub const value_zx_type_34_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_18, void, ?*const zx_type_34, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_22744a7721f95b6699578e861f563aa84628a885ffe4395623188cd7b0cc6f83" = struct {
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
    pub const @"zig:zxc_native_22744a7721f95b6699578e861f563aa84628a885ffe4395623188cd7b0cc6f83" = struct {
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_22744a7721f95b6699578e861f563aa84628a885ffe4395623188cd7b0cc6f83";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_22744a7721f95b6699578e861f563aa84628a885ffe4395623188cd7b0cc6f83";
};
