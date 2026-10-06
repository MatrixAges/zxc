pub const zx_type_12 = struct {
    end: u64,
    source: []const u8,
    start: u64,
};

pub const zx_type_13 = struct {
    []const u8,
    []const u8,
};

pub const value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    end: u64,
    source: []const u8,
    start: u64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const u8,
    []const u8,
    ?*const zx_type_13,
};

pub const native = struct {
    pub const @"std:encoding" = struct {
        pub const encodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeBase64 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeHex = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const encodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
        pub const decodeUtf8 = struct {
            pub const Input = []const u8;
            pub const Output = []const u8;
            pub const InputValue = []const u8;
            pub const OutputValue = []const u8;
        };
    };
};

pub const layouts = struct {
    pub const @"std:encoding" = struct {};
};
