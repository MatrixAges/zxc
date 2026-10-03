const std = @import("std");
const plugins = @import("zx_runtime").plugins;
const Input = struct { factor: f64, value: f64 };

fn scale(allocator: std.mem.Allocator, input: Input) !f64 {
    _ = allocator;

    return input.value * input.factor;
}

const methods = blk: {
    @setEvalBranchQuota(100000);

    break :blk [_]plugins.abi.Method{plugins.method("scale", Input, f64, scale)};
};

const descriptor = plugins.abi.Descriptor{ .method_count = methods.len, .methods = &methods };

export fn zxc_plugin_v1() callconv(.c) *const plugins.abi.Descriptor {
    return &descriptor;
}
