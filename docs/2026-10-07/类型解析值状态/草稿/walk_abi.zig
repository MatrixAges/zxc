pub const zx_type_13 = struct {
    names: []const []const u8,
    source: []const u8,
};

pub const zx_type_14 = struct {
    end: u64,
    start: u64,
};

pub const zx_type_16 = struct {
    index: u64,
    names: []const []const u8,
    source: []const u8,
    spans: []const *const zx_type_14,
};

pub const zx_type_17 = struct {
    span: *const zx_type_14,
    state: *const zx_type_13,
};

pub const zx_type_18 = struct {
    []const u8,
    []const u8,
};

pub const zx_type_19 = struct {
    []const []const u8,
    void,
};

pub const zx_type_20 = struct {
    source: []const u8,
    spans: []const *const zx_type_14,
};

pub const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    names: []const []const u8,
    source: []const u8,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_16_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    index: u64,
    names: []const []const u8,
    source: []const u8,
    spans: []const *const zx_type_14,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    span: *const zx_type_14,
    state: value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const u8,
    []const u8,
    ?*const zx_type_18,
};

pub const value_zx_type_19_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    []const []const u8,
    void,
    ?*const zx_type_19,
};

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    source: []const u8,
    spans: []const *const zx_type_14,
    zx_origin: ?*const zx_type_20 = null,
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
