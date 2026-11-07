const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_1006502d85b00db94d62e7584c67554e71822f1609e653427d133725ff4b435d) error{}!bool {
    @setRuntimeSafety(true);

    _ = allocator;

    const value_1: u64 = @as(u64, ((in).paths).len);
    const value_2: u64 = @as(u64, ((in).inodes).len);
    const value_3: u64 = @as(u64, ((in).sizes).len);
    const value_4: u64 = @as(u64, ((in).mtime_high).len);
    const value_5: u64 = @as(u64, ((in).mtime_low).len);
    const value_6: u64 = @as(u64, ((in).ctime_high).len);
    const value_7: u64 = @as(u64, ((in).ctime_low).len);

    return ((((((!(!(value_2 == value_1))) and (value_3 == value_1)) and (value_4 == value_1)) and (value_5 == value_1)) and (value_6 == value_1)) and (value_7 == value_1));
}
