const signature = @import("zxc_abi").native.@"zig:arithmetic".increment;

pub fn apply(input: signature.Input) signature.Output {
    return input + 1;
}
