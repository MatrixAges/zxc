pub const Boundary = union(enum) {
    end: usize,
    failure: struct { offset: usize, message: []const u8 },
};

pub const Reader = *const fn ([]const u8, usize) Boundary;
