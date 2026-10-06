pub const zx_type_13 = struct {
    bytes: []const u8,
    index: u64,
    names: []const []const u8,
    source: []const u8,
};

pub const zx_type_14 = struct {
    []const []const u8,
    void,
};

pub const value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    bytes: []const u8,
    index: u64,
    names: []const []const u8,
    source: []const u8,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const []const u8,
    void,
    ?*const zx_type_14,
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
