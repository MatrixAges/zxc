pub const zx_type_11 = opaque {};
pub const zx_type_12 = struct { *const zx_type_11, u64, };
pub const zx_type_13 = enum { Scalar, Object, Optional, List, Tuple, ErrorSet, Task, Enumeration, NativeReference, };

pub const zx_type_17 = struct {
    children: []const u32,
    field_names: []const []const u8,
    field_types: []const u32,
    first: []const u32,
    kinds: []const u8,
    labels: []const []const u8,
    names: []const []const u8,
    second: []const u32,
};

pub const zx_type_18 = struct {
    base: *const zx_type_17,
    delta: *const zx_type_17,
};

pub const zx_type_19 = struct {
    delta: bool,
    first: u32,
    kind: zx_type_13,
    label: []const u8,
    second: u32,
};

pub const zx_type_20 = struct {
    names: []const []const u8,
    types: []const u32,
};

pub const zx_type_21 = struct {
    children: []const u32,
    fields: *const zx_type_20,
    first: u32,
    kind: zx_type_13,
    label: []const u8,
    names: []const []const u8,
    second: u32,
};

pub const zx_type_22 = struct {
    found: bool,
    id: u32,
};

pub const zx_type_23 = struct {
    delta: *const zx_type_17,
    id: u32,
};

pub const zx_type_24 = struct {
    first: u64,
    kinds: []const u8,
    writer: *const zx_type_11,
};

pub const zx_type_25 = struct {
    index: u64,
    kinds: []const u8,
    writer: *const zx_type_11,
};

pub const zx_type_26 = struct { *const zx_type_24, };

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    base: *const zx_type_17,
    delta: *const zx_type_17,
    zx_origin: ?*const zx_type_18 = null,
};

pub const value_zx_type_19_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    delta: bool,
    first: u32,
    kind: zx_type_13,
    label: []const u8,
    second: u32,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    types: []const u32,
    zx_origin: ?*const zx_type_20 = null,
};

pub const value_zx_type_21_733f63291ddde64b1bc83a721ebf685a0d9d5fe955b56f62c3e2ecdaa3727384 = struct {
    children: []const u32,
    fields: value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    first: u32,
    kind: zx_type_13,
    label: []const u8,
    names: []const []const u8,
    second: u32,
    zx_origin: ?*const zx_type_21 = null,
};

pub const value_zx_type_22_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    found: bool,
    id: u32,
    zx_origin: ?*const zx_type_22 = null,
};

pub const value_zx_type_23_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    delta: *const zx_type_17,
    id: u32,
    zx_origin: ?*const zx_type_23 = null,
};

pub const value_zx_type_24_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    first: u64,
    kinds: []const u8,
    writer: *const zx_type_11,
    zx_origin: ?*const zx_type_24 = null,
};

pub const value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    kinds: []const u8,
    writer: *const zx_type_11,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_24_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_26, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_f5fdeceb83fbf18af63d01e2958ebe1c908bf2a1bdad18664f054e450c59eb18" = struct {
        pub const Writer = *const zx_type_11;
        pub const append = struct {
            pub const Input = *const zx_type_12;
            pub const Output = void;
            pub const InputValue = zx_type_12;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_f5fdeceb83fbf18af63d01e2958ebe1c908bf2a1bdad18664f054e450c59eb18" = struct {
        pub const Writer = zx_type_11;
    };
};

pub const native = struct {
    pub const @"zig:origin_writer" = (native_by_identity).@"zig:zxc_native_f5fdeceb83fbf18af63d01e2958ebe1c908bf2a1bdad18664f054e450c59eb18";
};

pub const layouts = struct {
    pub const @"zig:origin_writer" = (layouts_by_identity).@"zig:zxc_native_f5fdeceb83fbf18af63d01e2958ebe1c908bf2a1bdad18664f054e450c59eb18";
};

