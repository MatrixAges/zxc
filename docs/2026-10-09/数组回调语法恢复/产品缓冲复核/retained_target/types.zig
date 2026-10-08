pub const zx_type_12 = struct {
    count: u64,
    delta: i64,
    enabled: bool,
    left: []const i64,
    left_index: u64,
    marker: u64,
    right: []const i64,
    right_index: u64,
};

pub const zx_type_13 = struct {
    left: []const i64,
    right: []const i64,
};

pub const zx_type_14 = struct {
    columns: *const zx_type_13,
    count: u64,
    delta: i64,
    enabled: bool,
    left_index: u64,
    marker: u64,
    right_index: u64,
    round: u64,
};

pub const zx_type_15 = struct { *const zx_type_13, u64, };

pub const zx_type_16 = struct {
    count: u64,
    delta: i64,
    enabled: bool,
    left_index: u64,
    product: *const zx_type_15,
    right_index: u64,
    round: u64,
};

pub const zx_type_17 = struct {
    index: u64,
    result: []const i64,
    source: []const i64,
};

pub const zx_type_18 = struct { []const i64, void, };

pub const zx_type_19 = struct {
    before: *const zx_type_13,
    columns: *const zx_type_13,
    marker: u64,
    original: *const zx_type_13,
    rounds: u64,
};

pub const zx_type_20 = struct { *const zx_type_12, };
pub const zx_type_21 = struct { *const zx_type_12, *const zx_type_14, };
pub const zx_type_22 = struct { *const zx_type_12, *const zx_type_14, *const zx_type_14, };

pub const value_zx_type_12_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b = struct {
    count: u64,
    delta: i64,
    enabled: bool,
    left: []const i64,
    left_index: u64,
    marker: u64,
    right: []const i64,
    right_index: u64,
    zx_origin: ?*const zx_type_12 = null,
};

pub const value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { *const zx_type_13, u64, ?*const zx_type_15, };

pub const value_zx_type_16_8ef34bbb872828b188ee19a8359363920bfe3b0d8f03ea6e170828e6a3907906 = struct {
    count: u64,
    delta: i64,
    enabled: bool,
    left_index: u64,
    product: value_zx_type_15_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814,
    right_index: u64,
    round: u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_01b64116cded339e0425481afb235b18d36a68077b7c6c7e6676de6f82bf2292 = struct {
    index: u64,
    result: []const i64,
    source: []const i64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const value_zx_type_18_b5816fa2b3544d0ae53d8d80e4e8f16090caa096626dd61dae8a75a090525814 = struct { []const i64, void, ?*const zx_type_18, };

pub const value_zx_type_19_2ddc8d81c21e68612e817c7293e54a7cb5f26a22cd74db770ee9bdcef0645bce = struct {
    before: *const zx_type_13,
    columns: *const zx_type_13,
    marker: u64,
    original: *const zx_type_13,
    rounds: u64,
    zx_origin: ?*const zx_type_19 = null,
};

pub const value_zx_type_20_99b24a49db0e4c56e7b7285c93ad96930e1fddeebfd8d8086cfb69b8c53caeaf = struct { value_zx_type_12_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, ?*const zx_type_20, };
pub const value_zx_type_21_3fd235e03c65a6809dbfc1f8c9af05ad3740e7bdb3ee2ec0b25cf4f091780922 = struct { value_zx_type_12_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, *const zx_type_14, ?*const zx_type_21, };
pub const value_zx_type_22_e1a3efb1661a55082d96026e298239963014feef940e12b8f12b12b89508e175 = struct { value_zx_type_12_74d420388c65b4f82d1929508045cc03e4c927fc5790f97f65a1df1f97c4c49b, *const zx_type_14, *const zx_type_14, ?*const zx_type_22, };

pub const native = struct {
};

pub const layouts = struct {
};

