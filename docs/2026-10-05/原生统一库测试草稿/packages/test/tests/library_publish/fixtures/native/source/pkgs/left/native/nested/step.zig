const Request = @import("zxc_abi").native.@"zig:bridge".Request;
const data = @embedFile("../delta.txt");

pub fn apply(input: Request) i32 {
    return input.value + @as(i32, data.len);
}
