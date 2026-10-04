pub const zx_type_12 = struct {
    history: []const u64,
    value: u64,
};

pub const zx_type_13 = struct {
    increment: u64,
    state: *const zx_type_12,
};

pub const zx_type_14 = struct {
    current: u64,
    first: u64,
    second: u64,
};

pub const zx_type_15 = struct { u64, *const zx_type_12, };
pub const zx_type_16 = struct { u64, u64, };
pub const zx_type_17 = struct { u64, };
pub const zx_type_18 = struct { u64, u64, u64, *const zx_type_12, };
pub const zx_type_19 = struct { u64, u64, u64, u64, };

pub const native = struct {
};

pub const layouts = struct {
};

