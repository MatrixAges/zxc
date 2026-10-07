const std = @import("std");
const zx_abi = @import("zxc_abi");

pub fn call(allocator: ((std).mem).Allocator, in: *const (zx_abi).zx_type_ba25d6b49cead92d6b9fb85ed4307d538f9aa4a6f619925feefc783dbf0d547c) anyerror!u64 {
    @setRuntimeSafety(true);

    _ = allocator;

    return ((in).count + (in).limit);
}

