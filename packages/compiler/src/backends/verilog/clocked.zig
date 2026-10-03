const std = @import("std");
const ir = @import("../hardware/ir.zig");

pub fn write(writer: *std.Io.Writer, module: ir.Module) std.Io.Writer.Error!void {
    try writer.writeAll("module zxc_kernel(\n    input wire clk,\n    input wire reset,\n    input wire input_valid,\n    output wire input_ready,\n    output reg output_valid,\n    input wire output_ready,\n");
    for (module.inputs) |port| try writer.print("    input wire [{d}:0] {s},\n", .{ port.sort.width - 1, port.name });
    for (module.outputs) |port| try writer.print("    output reg [{d}:0] {s},\n", .{ port.sort.width - 1, port.name });
    try writer.writeAll("    output reg fault\n);\n\nwire core_fault;\n");
    for (module.outputs) |port| try writer.print("wire [{d}:0] core_{s};\n", .{ port.sort.width - 1, port.name });
    try writer.writeAll("\nzxc_core core(\n");
    for (module.inputs) |port| try writer.print("    .{s}({s}),\n", .{ port.name, port.name });
    for (module.outputs) |port| try writer.print("    .{s}(core_{s}),\n", .{ port.name, port.name });
    try writer.writeAll("    .fault(core_fault)\n);\n\nassign input_ready = !reset && (!output_valid || output_ready);\n\nalways @(posedge clk) begin\n    if (reset) begin\n        output_valid <= 1'b0;\n        fault <= 1'b0;\n");
    for (module.outputs) |port| try writer.print("        {s} <= {d}'d0;\n", .{ port.name, port.sort.width });
    try writer.writeAll("    end else if (input_ready) begin\n        output_valid <= input_valid;\n\n        if (input_valid) begin\n            fault <= core_fault;\n");
    for (module.outputs) |port| try writer.print("            {s} <= core_{s};\n", .{ port.name, port.name });
    try writer.writeAll("        end\n    end\nend\n\nendmodule\n\n");
}
