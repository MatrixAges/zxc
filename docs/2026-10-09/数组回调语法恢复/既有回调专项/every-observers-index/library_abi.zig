pub const zx_type_12 = struct {
    items: []const i64,
    limit: u64,
};

pub const zx_type_13 = struct {
    calls: u64,
    limit: u64,
    result: bool,
    visited: []const i64,
};

pub const zx_type_14 = struct { []const i64, void, };

pub const zx_type_15 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const i64,
};

pub const value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    items: []const i64,
    limit: u64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165 = struct {
    calls: u64,
    limit: u64,
    result: bool,
    visited: []const i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const i64, void, ?*const zx_type_14, };

pub const value_zx_type_15_b1e142daee037f4e878cbf299a1fbc548ca07053d40ed23b14bc9b2e5836ecbb = struct {
    index: u64,
    result: value_zx_type_13_268ac4b4059d05d5a9982d9acb60fad8e26591753d205e05b9629059f7c70165,
    source: []const i64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

