const std = @import("std");
const zx = @import("zx");
const genz = @import("genz");
const Lower = @import("lower.zig");

pub fn emit(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{InvalidIr})![]u8 {
    if (try @import("frontend").validateIr(allocator, program) != null) return error.InvalidIr;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const temporary = arena.allocator();

    var lower = Lower{
        .allocator = temporary,
        .program = program,
        .builder = .{ .allocator = temporary },
        .types = try temporary.alloc(*const genz.node.Expression, program.types.len),
        .names = try temporary.alloc([]const u8, program.symbols.len),
        .cache_reads = try temporary.alloc(usize, program.expressions.len),
        .used = try temporary.alloc(bool, program.symbols.len),
    };

    return genz.render(allocator, try lower.declarations());
}
