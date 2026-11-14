const std = @import("std");
const zx = @import("zx");
/// IR produced inside this process is trusted; only debug builds re-check it. Loaded libraries and caches are validated at their boundary.
pub const internal = @import("builtin").mode == .debug;
pub const TypePrefix = @import("canonical/validation/type_prefix.zig");

pub const Verified = struct {
    functions: usize = 0,
    types: ?TypePrefix = null,
    native: bool = false,
};

pub fn validate(allocator: std.mem.Allocator, program: zx.ir.Program) std.mem.Allocator.Error!?zx.Diagnostic {
    return validateProjectPrefix(allocator, program, .{});
}

pub fn validateExtending(allocator: std.mem.Allocator, program: zx.ir.Program, verified: zx.ir.FunctionTable) std.mem.Allocator.Error!?zx.Diagnostic {
    const trusted = @import("verified_prefix.zig").count(program.functions, verified);

    return validateProjectPrefix(allocator, program, .{ .functions = trusted });
}

/// Verified rows and bindings must still refer to the unchanged parts of this program.
pub fn validateProjectPrefix(allocator: std.mem.Allocator, program: zx.ir.Program, verified: Verified) std.mem.Allocator.Error!?zx.Diagnostic {
    if (comptime !@import("parser_options").generated_parser) return @import("seed_validate.zig").validate(allocator, program, verified.functions);
    if (try @import("canonical/validation/host.zig").verify(allocator, &program, verified) != null) return null;

    return .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid ZX IR version, structure, types or bindings" };
}
