pub const zx_type_12 = struct {
    items: []const i64,
};

pub const zx_type_13 = struct {
    calls: u64,
    result: bool,
    visited: []const i64,
};

pub const zx_type_14 = struct { []const i64, void, };

pub const zx_type_15 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const i64,
};

pub const value_zx_type_12_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    items: []const i64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    calls: u64,
    result: bool,
    visited: []const i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const i64, void, ?*const zx_type_14, };

pub const value_zx_type_15_8aba688e92428ec178bbadc7c92370aee8b1dc4844a62c0720bc84c764544a8f = struct {
    index: u64,
    result: value_zx_type_13_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    source: []const i64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

