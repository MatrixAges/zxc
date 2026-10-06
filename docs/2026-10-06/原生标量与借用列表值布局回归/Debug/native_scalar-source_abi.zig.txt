pub const zx_type_12 = struct {
    index: u64,
    last: u64,
    steps: []const u64,
    total: u64,
};

pub const zx_type_13 = struct {
    first: *const zx_type_12,
    second: *const zx_type_12,
};

pub const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    first: *const zx_type_12,
    second: *const zx_type_12,
    zx_origin: ?*const zx_type_13 = null,
};

pub const native = struct {
    pub const @"zig:scalar" = struct {
        pub const first = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
        pub const second = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
        pub const allocated = struct {
            pub const Input = u64;
            pub const Output = u64;
            pub const InputValue = u64;
            pub const OutputValue = u64;
        };
    };
};

pub const layouts = struct {
    pub const @"zig:scalar" = struct {
    };
};

