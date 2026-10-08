pub const zx_type_12 = struct {
    res: bool,
};

pub const zx_type_13 = struct {
    context: *const zx_type_12,
    items: []const i64,
};

pub const zx_type_15 = struct { *const zx_type_13, };

pub const zx_type_16 = struct {
    captures: *const zx_type_15,
    index: u64,
    result: []const bool,
    source: []const i64,
};

pub const zx_type_17 = struct { []const bool, void, };

pub const value_zx_type_12_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    res: bool,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3 = struct {
    context: value_zx_type_12_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    items: []const i64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_15_d26cf4fcd5483b68fe7ad61978f3c90981fa69aa1dba1771d36fd29e09394b12 = struct { value_zx_type_13_d1b76d1a572dc67900721ab2437a65f6ef299958eba1bc7395b2c55d7fdc2ef3, ?*const zx_type_15, };

pub const value_zx_type_16_9ca1c56e9a76726f89a7e3e40ca45583224013c3c9109e0f8067548d4a04a58c = struct {
    captures: value_zx_type_15_d26cf4fcd5483b68fe7ad61978f3c90981fa69aa1dba1771d36fd29e09394b12,
    index: u64,
    result: []const bool,
    source: []const i64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const bool, void, ?*const zx_type_17, };

pub const native = struct {
};

pub const layouts = struct {
};

