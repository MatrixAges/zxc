pub const zx_type_11 = opaque {};
pub const zx_type_12 = struct { *const zx_type_11, u32, };
pub const zx_type_13 = struct { *const zx_type_11, u64, u32, };
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
    buffer: *const zx_type_11,
    index: u64,
    table: *const zx_type_18,
};

pub const zx_type_26 = struct {
    buffer: *const zx_type_11,
    count: u64,
    first: u64,
    index: u64,
    values: []const u32,
};

pub const zx_type_27 = struct { *const zx_type_25, };

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

pub const value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    buffer: *const zx_type_11,
    index: u64,
    table: *const zx_type_18,
    zx_origin: ?*const zx_type_25 = null,
};

pub const value_zx_type_26_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    buffer: *const zx_type_11,
    count: u64,
    first: u64,
    index: u64,
    values: []const u32,
    zx_origin: ?*const zx_type_26 = null,
};

pub const value_zx_type_27_49129128bed2eab4847d5108d0ed3c4d32810f9cdd95b1d04dcc61383544ee70 = struct { value_zx_type_25_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292, ?*const zx_type_27, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_8240bd5355b80afacc1c1f629377c5bec648c55202f0851a4d3cf4e54d75664d" = struct {
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
    pub const @"zig:zxc_native_59e48c764a8db2b6cadf43349790f4f831003e6e5f74a81bd803635b956b0514" = struct {
        pub const Buffer = *const zx_type_11;

        pub const get = struct {
            pub const Input = *const zx_type_12;
            pub const Output = u32;
            pub const InputValue = zx_type_12;
            pub const OutputValue = u32;
        };
        pub const set = struct {
            pub const Input = *const zx_type_13;
            pub const Output = void;
            pub const InputValue = zx_type_13;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_8240bd5355b80afacc1c1f629377c5bec648c55202f0851a4d3cf4e54d75664d" = struct {
    };
    pub const @"zig:zxc_native_59e48c764a8db2b6cadf43349790f4f831003e6e5f74a81bd803635b956b0514" = struct {
        pub const Buffer = zx_type_11;
    };
};

pub const native = struct {
    pub const @"zig:integers" = (native_by_identity).@"zig:zxc_native_8240bd5355b80afacc1c1f629377c5bec648c55202f0851a4d3cf4e54d75664d";
    pub const @"zig:references" = (native_by_identity).@"zig:zxc_native_59e48c764a8db2b6cadf43349790f4f831003e6e5f74a81bd803635b956b0514";
};

pub const layouts = struct {
    pub const @"zig:integers" = (layouts_by_identity).@"zig:zxc_native_8240bd5355b80afacc1c1f629377c5bec648c55202f0851a4d3cf4e54d75664d";
    pub const @"zig:references" = (layouts_by_identity).@"zig:zxc_native_59e48c764a8db2b6cadf43349790f4f831003e6e5f74a81bd803635b956b0514";
};

