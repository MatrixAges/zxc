const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const options = @import("parser_options");
pub const Facts = struct { output: ir.Ownership, stores_owned: bool };

pub fn check(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!void {
    _ = try analyze(allocator, program, reporter);
}

pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!ir.Ownership {
    return (try facts(allocator, program, reporter)).output;
}

pub fn facts(allocator: std.mem.Allocator, program: ir.Program, reporter: *zx.Reporter) zx.Error!Facts {
    if (program.type_only) return .{ .output = .copy, .stores_owned = true };

    if (comptime options.generated_parser) {
        return @import("generated.zig").facts(allocator, program, reporter);
    } else {
        const result = try @import("ownership_seed").facts(allocator, program, reporter);

        return .{ .output = result.output, .stores_owned = result.stores_owned };
    }
}
