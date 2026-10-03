const signature = @import("zxc_abi").native.@"zig:arithmetic".double;

pub fn apply(input: signature.Input) signature.Output {
    return input * 2;
}
