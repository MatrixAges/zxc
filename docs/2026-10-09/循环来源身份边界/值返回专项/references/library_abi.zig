pub const zx_type_11 = struct {
    value: u64,
};

pub const zx_type_14 = struct {
    cell: *const zx_type_11,
    count: u64,
    items: []const u64,
    saved: ?*const zx_type_11,
};

pub const zx_type_15 = struct {
    item: u64,
    state: *const zx_type_14,
};

pub const zx_type_16 = struct {
    seed: *const zx_type_14,
    steps: []const u64,
};

pub const zx_type_17 = struct {
    index: u64,
    result: *const zx_type_14,
    source: []const u64,
};

pub const value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745 = struct {
    cell: *const zx_type_11,
    count: u64,
    items: []const u64,
    saved: ?*const zx_type_11,
    zx_origin: ?*const zx_type_14 = null,
};

pub const value_zx_type_15_43293a0559e659d31769b0e1af22594d1529269d296f78779abd36c6eae934e2 = struct {
    item: u64,
    state: value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745,
    zx_origin: ?*const zx_type_15 = null,
};

pub const value_zx_type_16_16878eaf6a964b7c2766c5dc980126bf394a0a5ef441d5fb3c790a3d6ada087c = struct {
    seed: value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745,
    steps: []const u64,
    zx_origin: ?*const zx_type_16 = null,
};

pub const value_zx_type_17_cfc2881811d921a5a56610f136ce54d046b6352e50732bd8da3ae4e2ed5dd438 = struct {
    index: u64,
    result: value_zx_type_14_f5412c40e1556b23a1b841484368479887468a539c7edd221ebc9223b0126745,
    source: []const u64,
    zx_origin: ?*const zx_type_17 = null,
};

pub const native = struct {
};

pub const layouts = struct {
};

