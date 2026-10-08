pub const zx_type_12 = struct {
    context: i64,
    item: i64,
};

pub const zx_type_13 = struct {
    items: []const i64,
    tag: i64,
};

pub const zx_type_14 = struct { i64, };

pub const zx_type_15 = struct {
    captures: *const zx_type_14,
    index: u64,
    result: bool,
    source: []const i64,
};

pub const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    items: []const i64,
    tag: i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { i64, ?*const zx_type_14, };

pub const value_zx_type_15_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813 = struct {
    captures: value_zx_type_14_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    index: u64,
    result: bool,
    source: []const i64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const native = struct {
    pub const @"lib:context" = struct {
        pub const context = struct {
            pub const Input = i64;
            pub const Output = i64;
            pub const InputValue = i64;
            pub const OutputValue = i64;
        };
    };
    pub const @"lib:source" = struct {
        pub const source = struct {
            pub const Input = []const i64;
            pub const Output = []const i64;
            pub const InputValue = []const i64;
            pub const OutputValue = []const i64;
        };
    };
    pub const @"lib:visit" = struct {
        pub const predicate = struct {
            pub const Input = *const zx_type_12;
            pub const Output = bool;
            pub const InputValue = zx_type_12;
            pub const OutputValue = bool;
        };
    };
};

pub const layouts = struct {
    pub const @"lib:context" = struct {
    };
    pub const @"lib:source" = struct {
    };
    pub const @"lib:visit" = struct {
    };
};

