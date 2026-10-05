const std = @import("std");
const ir = @import("zx").ir;
const capabilities = @import("capabilities.zig");
pub const uses = capabilities.uses;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    return capabilities.functions(allocator, program, .io);
}
