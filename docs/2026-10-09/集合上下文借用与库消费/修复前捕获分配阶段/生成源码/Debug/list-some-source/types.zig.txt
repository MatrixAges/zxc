pub const zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c = struct { i64, []const i64, };

pub const zx_type_c66e6df860adac873dcd6b04506ccbafe5594eb34ad2d48352f9e62c139aab85 = struct {
    context: []const i64,
    items: []const i64,
};

pub const zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9 = struct { []const i64, };

pub const zx_type_96765a2285a86cd2f122b8c2ddaba3a3ea3e3a586b8698c028f25eca4ca03d91 = struct {
    captures: *const zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9,
    index: u64,
    result: bool,
    source: []const i64,
};

pub const value_zx_type_c66e6df860adac873dcd6b04506ccbafe5594eb34ad2d48352f9e62c139aab85_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    context: []const i64,
    items: []const i64,
    zx_origin: ?*const zx_type_c66e6df860adac873dcd6b04506ccbafe5594eb34ad2d48352f9e62c139aab85 = null,
};

pub const value_zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct { []const i64, ?*const zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9, };

pub const value_zx_type_96765a2285a86cd2f122b8c2ddaba3a3ea3e3a586b8698c028f25eca4ca03d91_f5e553eae73ca161c587937fe6f7a8387771b918fa9e3e0a9ea7ddf837de9813 = struct {
    captures: value_zx_type_5d60e19ae6fa29e1598ed114551536184c522b8dd4d3877a28031be6bf375ea9_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    index: u64,
    result: bool,
    source: []const i64,
    zx_origin: ?*const zx_type_96765a2285a86cd2f122b8c2ddaba3a3ea3e3a586b8698c028f25eca4ca03d91 = null,
};

pub const native = struct {
    pub const @"zig:host" = struct {
        pub const Context = []const i64;
        pub const echo = struct {
            pub const Input = []const i64;
            pub const Output = []const i64;
            pub const InputValue = []const i64;
            pub const OutputValue = []const i64;
        };
        pub const mapValue = struct {
            pub const Input = *const zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c;
            pub const Output = i64;
            pub const InputValue = zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c;
            pub const OutputValue = i64;
        };
        pub const predicate = struct {
            pub const Input = *const zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c;
            pub const Output = bool;
            pub const InputValue = zx_type_4104921f11e90e4d6bf26e6e94b650507a41b38bc093e6b16a777eb022cd403c;
            pub const OutputValue = bool;
        };
    };
};

pub const layouts = struct {
    pub const @"zig:host" = struct {
        pub const Context = []const i64;
    };
};

