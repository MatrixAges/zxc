pub const zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c = struct {
    count: u64,
    limit: u64,
};

pub const zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591 = struct {
    count: u64,
};

pub const zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908 = struct {
    literal: []const u8,
    small: bool,
    text: []const u8,
    value: u64,
};

pub const zx_type_a5245a6c68a1282d233df430125422ac47e374adc850bbad43e46774a25eef8c = struct { *const zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591, };
pub const zx_type_3648c4289d1f2cc5b00fa09a5b947e4165385c43a3455b57a73cecad6fc67314 = struct { *const zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591, []const u8, };
pub const zx_type_afb060d8efc5f3869f9b6b338ff232657ace079a4b853afa8bf8a43b8c37b48f = struct { *const zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591, []const u8, u64, };
pub const zx_type_6327696f5ee68e0d39822663e449d21318b57a3709998fc7072424da32dccea2 = struct { *const zx_type_d17201b8d765b68b3c68db0cc13b2632f2f147245d89b474623a02ca11dd7591, *const zx_type_4dc68a745291a1e8ce9d29b5448a7a4dba1059872e3e101e379c2a3b80b4b908, };

pub const native = struct {
};

pub const layouts = struct {
};

