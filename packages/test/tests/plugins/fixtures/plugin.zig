const std = @import("std");
const plugins = @import("runtime").plugins;
const kind = @import("config").kind;
const abi = plugins.abi;
const Input = struct { count: u64, text: []const u8, values: []const i64, maybe: ?bool };

fn echo(allocator: std.mem.Allocator, input: Input) !Input {
    _ = allocator;

    return input;
}

fn raw(input: [*]const u8, length: usize, context: *anyopaque, write: abi.Write) callconv(.c) u32 {
    if (length != 1) return 1;

    switch (input[0]) {
        '0' => {
            if (write(context, "1", 1) != 0) return 3;
            if (write(context, "2", 1) != 0) return 3;
        },
        '1' => _ = write(context, "[", 1),
        '2' => _ = write(context, "\"x\"", 3),
        '3' => return 2,
        '4' => _ = write(context, "", abi.maximum_output + 1),
        '5' => {},
        '6' => {
            _ = write(context, "12", 2);

            return 2;
        },
        '7' => _ = write(context, "1.5", 3),
        '8' => _ = write(context, "18446744073709551616", 20),
        '9' => _ = write(context, "9007199254740993", 16),
        else => return 1,
    }

    return 0;
}

fn unused(allocator: std.mem.Allocator, input: u32) !u64 {
    _ = allocator;

    return input;
}

const methods = blk: {
    @setEvalBranchQuota(100000);

    var result = if (std.mem.eql(u8, kind, "good"))
        [_]abi.Method{ plugins.method("echo", Input, Input, echo), plugins.method("raw", u32, u64, unused) }

    else
        [_]abi.Method{ .{ .name = "echo", .schema = @splat(0), .invoke = raw }, .{ .name = "raw", .schema = @splat(0), .invoke = raw } };

    result[1].invoke = raw;

    if (std.mem.eql(u8, kind, "duplicate")) result[1].name = result[0].name;
    if (std.mem.eql(u8, kind, "empty_name")) result[0].name = "";

    break :blk result;
};

const descriptor = abi.Descriptor{
    .abi_version = if (std.mem.eql(u8, kind, "version")) abi.version + 1 else abi.version,
    .descriptor_size = if (std.mem.eql(u8, kind, "size")) 0 else @sizeOf(abi.Descriptor),
    .flags = if (std.mem.eql(u8, kind, "flags")) 0 else abi.pure,
    .method_count = if (std.mem.eql(u8, kind, "empty")) 0 else if (std.mem.eql(u8, kind, "large")) 1025 else methods.len,
    .methods = &methods,
};

fn entry() callconv(.c) *const abi.Descriptor {
    return &descriptor;
}

comptime {
    @export(&entry, .{ .name = if (std.mem.eql(u8, kind, "no_entry")) "other_entry" else "zxc_plugin_v1" });
}
