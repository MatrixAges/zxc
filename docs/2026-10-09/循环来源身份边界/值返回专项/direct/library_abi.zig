pub const zx_type_12 = struct {
    count: u64,
    flag: bool,
    last: u64,
    optional: ?u64,
    total: u64,
};

pub const zx_type_14 = struct {
    seed: *const zx_type_12,
    steps: []const u64,
};

pub const zx_type_15 = struct {
    index: u64,
    result: *const zx_type_12,
    source: []const u64,
};

pub const value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f = struct {
    count: u64,
    flag: bool,
    last: u64,
    optional: ?u64,
    total: u64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_14_7da5667de74a9dcfa7ece2fe079eb3d81a57b36eab2d28a05a8c0c3dadada60c = struct {
    seed: value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f,
    steps: []const u64,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_15_657ff63339c918543c9de042e432a92e165cae86de8bb442a1f9e4e24eb01416 = struct {
    index: u64,
    result: value_zx_type_12_ce17709e63320e28149f834ac1d9457cf73694d5188ef6a71f19299f16d9b17f,
    source: []const u64,
    zx_origin: ?*const zx_type_15 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

