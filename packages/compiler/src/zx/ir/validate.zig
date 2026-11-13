const std = @import("std");
const zx = @import("zx");
/// IR produced inside this process is trusted; only debug builds re-check it. Loaded libraries and caches are validated at their boundary.
pub const internal = @import("builtin").mode == .debug;

pub fn validate(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!?zx.Diagnostic {
    return validateProjectPrefix(allocator, program, 0);
}

pub fn validateExtending(allocator: std.mem.Allocator, program: zx.ir.Program, verified: zx.ir.FunctionTable) std.mem.Allocator.Error!?zx.Diagnostic {
    const trusted = @import("verified_prefix.zig").count(program.functions, verified);

    return validateProjectPrefix(allocator, program, trusted);
}

/// The caller owns the verified rows and their unchanged type and native bindings.
pub fn validateProjectPrefix(allocator: std.mem.Allocator, program: zx.ir.Program, verified: usize) std.mem.Allocator.Error!?zx.Diagnostic {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, program, verified);
    if (try @import("canonical/validation/host.zig").validate(allocator, program, verified)) return null;

    return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid ZX IR version, structure, types or bindings" };
}
