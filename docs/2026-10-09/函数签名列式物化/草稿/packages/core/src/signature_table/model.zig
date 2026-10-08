const ir = @import("../ir.zig");

pub const Signature = struct {
    file_name: []const u8,
    input_type: ir.TypeId,
    output_type: ir.TypeId,
    output_ownership: ir.Ownership,
    external: ?ir.External,
};
