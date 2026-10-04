const abi = @import("zxc_abi").native.@"lib:record";
pub const Input = abi.borrow.Input;
pub const Output = abi.borrow.Output;

pub fn borrow(value: Input) Output {
    return value;
}

pub fn zero() f64 {
    return 0;
}
