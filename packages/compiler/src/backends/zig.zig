const std = @import("std");
const zx = @import("zx");

pub fn emit(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts, NativeRequiresBundle })![]u8 {
    try validate(allocator, program);
    if (program.native_modules.len != 0) return error.NativeRequiresBundle;

    return @import("genz").zx.emit(allocator, program);
}

pub const Bundle = @import("genz").zx.Bundle;

pub fn emitBundle(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts })!Bundle {
    try validate(allocator, program);

    return @import("genz").zx.bundle(allocator, program);
}

fn validate(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts })!void {
    if (try @import("frontend").validateIr(allocator, program) != null) return error.InvalidIr;
    if (program.contracts.len != 0) return error.UnverifiedContracts;

    for (program.functions) |function| {
        if (function.contracts.len != 0) return error.UnverifiedContracts;
    }
}
