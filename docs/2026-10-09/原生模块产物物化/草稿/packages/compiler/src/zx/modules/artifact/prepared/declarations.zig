const std = @import("std");
const ir = @import("zx").ir;
const Nodes = @import("../nodes.zig");
const model = @import("../model.zig");

pub fn functions(nodes: *Nodes, program: ir.Program, order: []const u32) model.Error![]const model.Signature {
    const values = try nodes.allocator.alloc(model.Signature, order.len);

    for (order, values) |index, *result| {
        const value = program.functions.at(index);

        result.* = .{
            .file_name = try nodes.allocator.dupe(u8, value.file_name),
            .input_type = try nodes.types.include(value.input_type),
            .output_type = try nodes.types.include(value.output_type),
            .output_ownership = value.output_ownership,
            .external = if (value.external) |external| try nodes.external(external) else null,
        };
    }

    return values;
}
