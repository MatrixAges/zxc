const Request = @import("zxc_abi").native.@"zig:bridge".Request;
const step = @import("nested/step.zig");

pub fn apply(input: Request) i32 {
    return step.apply(input);
}
