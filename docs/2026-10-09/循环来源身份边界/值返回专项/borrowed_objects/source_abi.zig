pub const zx_type_11 = struct {
    label: []const u8,
    value: u64,
};

pub const zx_type_14 = struct {
    index: u64,
    saved: ?*const zx_type_11,
    total: u64,
    values: []const *const zx_type_11,
};

pub const zx_type_15 = struct {
    ordinal: u64,
    saved: ?*const zx_type_11,
    seed: u64,
    values: []const *const zx_type_11,
};

pub const zx_type_16 = struct {
    empty: *const zx_type_14,
    first: *const zx_type_14,
    second: *const zx_type_14,
};

pub const zx_type_19 = struct {
    index: u64,
    result: []const *const zx_type_16,
    source: []const *const zx_type_15,
};

pub const zx_type_20 = struct { []const *const zx_type_16, void, };

pub const value_zx_type_19_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const *const zx_type_16,
    source: []const *const zx_type_15,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_16, void, ?*const zx_type_20, };

pub const native = struct {
};

pub const layouts = struct {
};

