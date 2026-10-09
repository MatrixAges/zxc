const std = @import("std");
const zx = @import("zx");

pub fn validate(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!?zx.Diagnostic {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, program);
    if (try @import("canonical/validation/host.zig").validate(allocator, program)) return null;

    return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid ZX IR version, structure, types or bindings" };
}
