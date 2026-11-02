const std = @import("std");
const Options = @import("zxc_abi").native.@"std:crypto".ScryptOptions;

pub fn scrypt(allocator: std.mem.Allocator, input: Options) ![]const u8 {
    if (input.cost < 2 or !std.math.isPowerOfTwo(input.cost)) return error.InvalidCost;
    if (input.block_size == 0 or input.parallelism == 0) return error.InvalidParameters;
    if (@as(u64, input.block_size) * input.parallelism >= 1 << 30) return error.InvalidParameters;
    if (input.length == 0) return error.InvalidKeyLength;

    const logarithm = std.math.log2_int(u32, input.cost);

    if (logarithm >= @as(u64, input.block_size) * 16) return error.InvalidCost;

    const blocks = @as(u64, input.cost) + input.parallelism + 2;
    const block_bytes = @as(u64, input.block_size) * 128;
    const workspace = std.math.mul(u64, blocks, block_bytes) catch return error.MemoryLimitExceeded;
    const requested = std.math.add(u64, workspace, input.length) catch return error.MemoryLimitExceeded;

    if (requested > input.max_memory or requested > std.math.maxInt(usize)) return error.MemoryLimitExceeded;

    const output = try allocator.alloc(u8, input.length);

    errdefer {
        std.crypto.secureZero(u8, output);
        allocator.free(output);
    }

    try std.crypto.pwhash.scrypt.kdf(allocator, output, input.password, input.salt, .{
        .ln = @intCast(logarithm),
        .r = @intCast(input.block_size),
        .p = @intCast(input.parallelism),
    });

    return output;
}
