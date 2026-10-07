pub const zx_type_12 = struct {
    count: u64,
    start: i64,
    values: []const i64,
};

pub const zx_type_13 = struct {
    initial: i64,
    other: i64,
    previous: i64,
    steps: u64,
    total: i64,
    values: []const i64,
};

pub const zx_type_14 = struct {
    previous: i64,
    total: i64,
};

pub const zx_type_15 = struct {
    index: u64,
    leaf: *const zx_type_14,
    limit: u64,
};

pub const zx_type_16 = struct { *const zx_type_14, u64, };

pub const zx_type_17 = struct {
    index: u64,
    left: *const zx_type_14,
    limit: u64,
    previous: i64,
    right: *const zx_type_14,
};

pub const zx_type_18 = struct {
    limit: u64,
    pair: *const zx_type_16,
};

pub const zx_type_19 = struct {
    previous: i64,
    total: i64,
    values: []const i64,
};

pub const zx_type_20 = struct {
    box: *const zx_type_19,
    index: u64,
    limit: u64,
};

pub const value_zx_type_12_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    count: u64,
    start: i64,
    values: []const i64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_13_c49a07f0cb1fc4a63cf7628de04d8941b125bb18730256ca50477a6a29730701 = struct {
    initial: i64,
    other: i64,
    previous: i64,
    steps: u64,
    total: i64,
    values: []const i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_15_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    leaf: *const zx_type_14,
    limit: u64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { *const zx_type_14, u64, ?*const zx_type_16, };

pub const value_zx_type_17_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    index: u64,
    left: *const zx_type_14,
    limit: u64,
    previous: i64,
    right: *const zx_type_14,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_18_7c1fb3c3119eaae5cd4f1cb07357028eca5a8de092f6534ed4fdf3ca985575ec = struct {
    limit: u64,
    pair: value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    zx_origin: ?*const zx_type_18 = null,
};

pub const value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    previous: i64,
    total: i64,
    values: []const i64,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_aee76122a8aa68efe04b2c02a68c8e3c08413ae0f993bee8758d75935e4a54be = struct {
    box: value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292,
    index: u64,
    limit: u64,
    zx_origin: ?*const zx_type_20 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

