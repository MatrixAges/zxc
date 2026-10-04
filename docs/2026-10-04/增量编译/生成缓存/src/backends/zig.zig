const std = @import("std");
const zx = @import("zx");
const modules = @import("zig/modules.zig");
pub const ModuleBundle = modules.Bundle;
pub const ModuleFile = modules.File;
pub const GenerationCache = @import("zig/cache.zig");

pub fn emitModules(allocator: std.mem.Allocator, analysis: *const @import("frontend").AnalysisResult) (modules.Error || error{ InvalidIr, UnverifiedContracts })!ModuleBundle {
    return emitModulesCached(allocator, analysis, null);
}

pub fn emitModulesCached(allocator: std.mem.Allocator, analysis: *const @import("frontend").AnalysisResult, cache: ?*GenerationCache) (modules.Error || error{ InvalidIr, UnverifiedContracts })!ModuleBundle {
    if (analysis.value != .ir) return error.InvalidAnalysis;
    try validate(allocator, analysis.value.ir);

    return modules.createCached(allocator, analysis, cache);
}

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
