pub const zx_type_12 = struct {
    count: u64,
    flag: bool,
    last: u64,
    optional: ?u64,
    total: u64,
};

pub const zx_type_14 = struct {
    item: []const u64,
    state: *const zx_type_12,
};

pub const zx_type_16 = struct {
    seed: *const zx_type_12,
    steps: []const []const u64,
};

pub const zx_type_17 = struct {
    index: u64,
    result: *const zx_type_12,
    source: []const []const u64,
};

pub const value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = struct {
    count: u64,
    flag: bool,
    last: u64,
    optional: ?u64,
    total: u64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_14_d3379d1bbe14c2ddbe4222a11a8f95c49e27b3011e78840c53c4331286e0a632 = struct {
    item: []const u64,
    state: value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_16_7da5667de74a9dcfa7ece2fe079eb3d81a57b36eab2d28a05a8c0c3dadada60c = struct {
    seed: value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f,
    steps: []const []const u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = struct {
    index: u64,
    result: value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f,
    source: []const []const u64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

