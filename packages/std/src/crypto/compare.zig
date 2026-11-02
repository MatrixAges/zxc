const std = @import("std");
pub const Input = @import("zxc_abi").native.@"std:crypto".timingSafeEqual.Input;

pub fn timingSafeEqual(input: Input) !bool {
    if (input.left.len != input.right.len) return error.LengthMismatch;

    return std.crypto.timing_safe.compare(u8, input.left, input.right, .little) == .eq;
}
