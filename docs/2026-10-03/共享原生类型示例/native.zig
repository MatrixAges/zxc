const abi = @import("zxc_abi").native.@"zig:transport";

pub fn echo(input: abi.echo.Input) abi.echo.Output {
    return input;
}
