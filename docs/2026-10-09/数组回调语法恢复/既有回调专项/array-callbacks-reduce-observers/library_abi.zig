pub const zx_type_12 = struct {
    items: []const i64,
    seed: i64,
};

pub const zx_type_13 = struct {
    current: i64,
    previous: i64,
};

pub const zx_type_15 = struct {
    value: i64,
    visits: []const *const zx_type_13,
};

pub const zx_type_16 = struct { []const *const zx_type_13, void, };

pub const zx_type_17 = struct {
    index: u64,
    result: *const zx_type_15,
    source: []const i64,
};

pub const value_zx_type_12_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    items: []const i64,
    seed: i64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct {
    value: i64,
    visits: []const *const zx_type_13,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_zx_type_16_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_13, void, ?*const zx_type_16, };

pub const value_zx_type_17_9638323d174581190e16ab503293f71b5cdb03fa5c46773baeea6b9588a76bd1 = struct {
    index: u64,
    result: value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    source: []const i64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

