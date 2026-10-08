pub const zx_type_11 = struct {
    value: u64,
};

pub const zx_type_13 = struct {
    child: *const zx_type_11,
    count: u64,
    labels: []const []const u8,
    last: u64,
    text: []const u8,
    total: u64,
};

pub const zx_type_14 = struct {
    item: u64,
    state: *const zx_type_13,
};

pub const zx_type_16 = struct {
    seed: *const zx_type_13,
    steps: []const u64,
};

pub const zx_type_17 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const u64,
};

pub const value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744 = struct {
    value: u64,
    zx_origin: ?*const zx_type_11 = null,
};

pub const value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2 = struct {
    child: value_zx_type_11_4f40a753d66cbdf2828707a9f642bbaf44febd927bbdba19d0f7279821ade744,
    count: u64,
    labels: []const []const u8,
    last: u64,
    text: []const u8,
    total: u64,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_5d345f57a03de9e730e12c8e7abca63f76cc239985c7520918b0a63b00bebc5c = struct {
    item: u64,
    state: value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_16_e75fd8bd7ba4953908df45d7cb21dac97f86c37d2cbeb6384f0f32c728bafd68 = struct {
    seed: value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2,
    steps: []const u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_db7b9a176a8a65a928df13888caad813282619a02073536d21c4ab7df2040d64 = struct {
    index: u64,
    result: value_zx_type_13_35ddb6d0529dc7f822e63e150b14ec433bbe8f9a218bb1186d703bbdfb1f98b2,
    source: []const u64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

