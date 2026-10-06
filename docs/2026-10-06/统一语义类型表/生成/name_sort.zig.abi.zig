pub const zx_type_11 = opaque {};
pub const zx_type_12 = struct { *const zx_type_11, u64, u64, };

pub const zx_type_13 = struct {
    columns: *const zx_type_11,
    count: u64,
    start: u64,
};

pub const zx_type_14 = struct {
    active: bool,
    columns: *const zx_type_11,
    count: u64,
    root: u64,
};

pub const zx_type_15 = struct {
    columns: *const zx_type_11,
    count: u64,
    remaining: u64,
};

pub const zx_type_16 = struct {
    columns: *const zx_type_11,
    remaining: u64,
};

pub const zx_type_17 = struct { *const zx_type_11, };

pub const value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    columns: *const zx_type_11,
    count: u64,
    start: u64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    active: bool,
    columns: *const zx_type_11,
    count: u64,
    root: u64,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    columns: *const zx_type_11,
    count: u64,
    remaining: u64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    columns: *const zx_type_11,
    remaining: u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { *const zx_type_11, ?*const zx_type_17, };

pub const native_by_identity = struct {
    pub const @"zig:zxc_native_0d5ffa1f0c8311a11c9d2d3ed4d1fa96fc2e2862bc1ea28f9bb0af9d8109feba" = struct {
        pub const Columns = *const zx_type_11;
        pub const length = struct {
            pub const Input = *const zx_type_11;
            pub const Output = u64;
            pub const InputValue = zx_type_11;
            pub const OutputValue = u64;
        };
        pub const less = struct {
            pub const Input = *const zx_type_12;
            pub const Output = bool;
            pub const InputValue = zx_type_12;
            pub const OutputValue = bool;
        };
        pub const swap = struct {
            pub const Input = *const zx_type_12;
            pub const Output = void;
            pub const InputValue = zx_type_12;
            pub const OutputValue = void;
        };
    };
};

pub const layouts_by_identity = struct {
    pub const @"zig:zxc_native_0d5ffa1f0c8311a11c9d2d3ed4d1fa96fc2e2862bc1ea28f9bb0af9d8109feba" = struct {
        pub const Columns = zx_type_11;
    };
};

pub const native = struct {
    pub const @"zig:named_columns" = (native_by_identity).@"zig:zxc_native_0d5ffa1f0c8311a11c9d2d3ed4d1fa96fc2e2862bc1ea28f9bb0af9d8109feba";
};

pub const layouts = struct {
    pub const @"zig:named_columns" = (layouts_by_identity).@"zig:zxc_native_0d5ffa1f0c8311a11c9d2d3ed4d1fa96fc2e2862bc1ea28f9bb0af9d8109feba";
};

