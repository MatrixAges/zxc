pub const zx_type_13 = struct {
    items: []const []const i64,
    threshold: i64,
};

pub const zx_type_14 = struct {
    calls: u64,
    result: bool,
    threshold: i64,
    visited: []const i64,
};

pub const zx_type_15 = struct { []const i64, void, };

pub const zx_type_16 = struct {
    index: u64,
    result: *const zx_type_14,
    source: []const []const i64,
};

pub const value_zx_type_13_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    items: []const []const i64,
    threshold: i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    calls: u64,
    result: bool,
    threshold: i64,
    visited: []const i64,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const i64, void, ?*const zx_type_15, };

pub const value_zx_type_16_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = struct {
    index: u64,
    result: value_zx_type_14_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    source: []const []const i64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

