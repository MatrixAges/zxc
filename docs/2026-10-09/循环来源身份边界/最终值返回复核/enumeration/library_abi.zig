pub const zx_type_11 = enum { Off, On, };

pub const zx_type_13 = struct {
    count: u64,
    phase: zx_type_11,
    saved: ?zx_type_11,
};

pub const zx_type_14 = struct {
    item: bool,
    state: *const zx_type_13,
};

pub const zx_type_16 = struct {
    seed: *const zx_type_13,
    steps: []const bool,
};

pub const zx_type_17 = struct {
    index: u64,
    result: *const zx_type_13,
    source: []const bool,
};

pub const value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91 = struct {
    count: u64,
    phase: zx_type_11,
    saved: ?zx_type_11,
    zx_origin: ?*const zx_type_13 = null,
};

pub const value_zx_type_14_a11759b1e7fb1d577ca2ade2175b6dc4aa6988dab8c55e53269d2cc006525ab5 = struct {
    item: bool,
    state: value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_16_20ba4de8b3c65311b405214c8b837f27e4756ddfe17938968cad9d115f14c7db = struct {
    seed: value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91,
    steps: []const bool,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_493bf4aed8f128280cd28835dc1bd257d55aabdfcb56f445dde94b8e9ab82233 = struct {
    index: u64,
    result: value_zx_type_13_20a297b47418fd06b33d66ad439aabb4d11fb942d502db09fb84016cd1b19c91,
    source: []const bool,
    zx_origin: ?*const zx_type_17 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

