pub const zx_type_11 = struct {
    value: u64,
};

pub const zx_type_13 = struct {
    argument: ?*const zx_type_11,
    local: ?*const zx_type_11,
};

pub const zx_type_16 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const u64,
};

pub const zx_type_17 = struct {
    index: u64,
    result: []const *const zx_type_13,
    source: []const u64,
};

pub const zx_type_18 = struct { []const *const zx_type_13, void, };

pub const value_zx_type_16_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const *const zx_type_13,
    source: []const u64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const *const zx_type_13, void, ?*const zx_type_18, };

pub const native = struct {
};

pub const layouts = struct {
};

