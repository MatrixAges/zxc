//! Borrows a `[][]u8` descriptor. The host keeps its shape and writable cells
//! alive and stable for every operation; cells are accessed atomically.

pub fn count(in: *const anyopaque) u64 {
    return rows(in).len;
}

pub fn rowLength(in: *const anyopaque, row: u64) error{IndexOutOfBounds}!u64 {
    const values = rows(in);

    if (row >= values.len) return error.IndexOutOfBounds;

    return values[@intCast(row)].len;
}

pub fn load(in: *const anyopaque, row: u64, index: u64) error{IndexOutOfBounds}!u8 {
    const target = try cell(in, row, index);

    return @atomicLoad(u8, target, .monotonic);
}

pub fn store(in: *const anyopaque, row: u64, index: u64, value: u8) error{IndexOutOfBounds}!void {
    const target = try cell(in, row, index);

    @atomicStore(u8, target, value, .monotonic);
}

pub fn fill(in: *const anyopaque, row: u64, value: u8) error{IndexOutOfBounds}!void {
    const table = rows(in);

    if (row >= table.len) return error.IndexOutOfBounds;
    for (table[@intCast(row)]) |*target| @atomicStore(u8, target, value, .monotonic);
}

fn cell(in: *const anyopaque, row: u64, index: u64) error{IndexOutOfBounds}!*u8 {
    const table = rows(in);

    if (row >= table.len) return error.IndexOutOfBounds;

    const values = table[@intCast(row)];

    if (index >= values.len) return error.IndexOutOfBounds;

    return &values[@intCast(index)];
}

fn rows(in: *const anyopaque) [][]u8 {
    const value: *const [][]u8 = @ptrCast(@alignCast(in));

    return value.*;
}
