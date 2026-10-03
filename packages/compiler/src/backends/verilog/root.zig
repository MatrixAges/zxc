const std = @import("std");
const ir = @import("../hardware/ir.zig");

pub fn emit(allocator: std.mem.Allocator, module: ir.Module, clocked: bool) ![]u8 {
    if (!@import("../hardware/validate.zig").validate(module)) return error.InvalidHardwareIr;

    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();

    const writer = &output.writer;

    try writer.writeAll("`default_nettype none\n\n");
    try writer.print("module {s}(\n", .{if (clocked) "zxc_core" else "zxc_kernel"});
    for (module.inputs) |port| try writer.print("    input wire [{d}:0] {s},\n", .{ port.sort.width - 1, port.name });
    for (module.outputs) |port| try writer.print("    output wire [{d}:0] {s},\n", .{ port.sort.width - 1, port.name });
    try writer.writeAll("    output wire fault\n);\n\n");

    for (module.nodes, 0..) |node, index| {
        try writer.print("wire [{d}:0] n_{d};\nassign n_{d} = ", .{ node.sort.width - 1, index, index });
        try @import("expressions.zig").write(writer, module, node);
        try writer.writeAll(";\n\n");
    }

    for (module.outputs) |port| try writer.print("assign {s} = n_{d};\n", .{ port.name, @intFromEnum(port.node) });
    try writer.print("assign fault = !n_{d};\n\nendmodule\n\n", .{@intFromEnum(module.safe)});
    if (clocked) try @import("clocked.zig").write(writer, module);
    try writer.writeAll("`default_nettype wire\n");

    return output.toOwnedSlice();
}
