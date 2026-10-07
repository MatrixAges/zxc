const std = @import("std");
const zx = @import("zx");
const modules = @import("zig/modules.zig");
const library = @import("zig/library.zig");
pub const LibraryBundle = library.Bundle;
pub const ModuleBundle = modules.Bundle;
pub const ModuleFile = modules.File;
pub const GenerationCache = @import("zig/cache.zig");
pub const host = @import("genz").host;
pub const abi_view = @import("genz").zx.modules.abi_view;
pub const store_initializers = @import("zig/store_initializers.zig");
pub const gateway = @import("zig/gateway/root.zig");
pub const state = @import("zig/state.zig");

pub fn emitLibrary(allocator: std.mem.Allocator, result: *const @import("../library/root.zig").Result) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    return emitLibraryCached(allocator, result, null);
}

pub fn emitLibraryCached(allocator: std.mem.Allocator, result: *const @import("../library/root.zig").Result, cache: ?*GenerationCache) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    try validate(allocator, result.program);

    return library.createCached(allocator, result, cache);
}

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

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);

        if (function.contracts.len != 0) return error.UnverifiedContracts;
    }
}
