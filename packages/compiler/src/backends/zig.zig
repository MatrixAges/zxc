pub const file_ledger = @import("zig/output.zig");
const std = @import("std");
const zx = @import("zx");
const modules = @import("zig/modules.zig");
const library = @import("zig/library.zig");
pub const LibraryBundle = library.Bundle;
pub const LibraryOptions = library.Options;
pub const ModuleBundle = modules.Bundle;
pub const ModuleFile = modules.File;
pub const GenerationCache = @import("zig/cache.zig");
pub const host = @import("genz").host;
pub const constant_namespace = @import("genz").zx.constant_namespace;
pub const bundle_abi = @import("zig/bundle_abi.zig");
pub const abi_view = @import("genz").zx.modules.abi_view;
pub const store_initializers = @import("zig/store_initializers.zig");
pub const gateway = @import("zig/gateway/root.zig");
pub const state = @import("zig/state.zig");
pub const partition = @import("zig/partition.zig");
/// The vectorized substring search generated-code scans share.
pub const search = @import("zig/search.zig");

pub fn emitLibrary(allocator: std.mem.Allocator, result: *const @import("../library/root.zig").Result) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    return emitLibraryCached(allocator, result, null);
}

pub fn emitLibraryCached(allocator: std.mem.Allocator, result: *const @import("../library/root.zig").Result, cache: ?*GenerationCache) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    try trusted(allocator, result.program);

    return library.createCached(allocator, result, cache);
}

pub fn emitLibraryFilesCached(allocator: std.mem.Allocator, output: std.mem.Allocator, result: *const @import("../library/root.zig").Result, cache: ?*GenerationCache) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    try trusted(allocator, result.program);

    return library.createFilesCached(allocator, output, result, cache);
}

/// Analysis and memo allocators must be threadsafe, and no other call may use the memo until this returns.
pub fn emitLibraryFilesCachedConcurrent(allocator: std.mem.Allocator, output: std.mem.Allocator, result: *const @import("../library/root.zig").Result, cache: ?*GenerationCache) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    return emitLibraryFilesCachedConcurrentWith(allocator, output, result, cache, .{});
}

pub fn emitLibraryFilesCachedConcurrentWith(allocator: std.mem.Allocator, output: std.mem.Allocator, result: *const @import("../library/root.zig").Result, cache: ?*GenerationCache, options: LibraryOptions) (library.Error || error{ InvalidIr, UnverifiedContracts })!LibraryBundle {
    try trusted(allocator, result.program);

    return library.createFilesCachedConcurrentWith(allocator, output, result, cache, options);
}

pub fn emitModules(allocator: std.mem.Allocator, analysis: *const @import("frontend").AnalysisResult) (modules.Error || error{ InvalidIr, UnverifiedContracts })!ModuleBundle {
    return emitModulesCached(allocator, analysis, null);
}

pub fn emitModulesCached(allocator: std.mem.Allocator, analysis: *const @import("frontend").AnalysisResult, cache: ?*GenerationCache) (modules.Error || error{ InvalidIr, UnverifiedContracts })!ModuleBundle {
    if (analysis.value != .ir) return error.InvalidAnalysis;
    try trusted(allocator, analysis.value.ir);

    return modules.createCached(allocator, analysis, cache);
}

pub fn emit(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts, NativeRequiresBundle })![]u8 {
    return emitWithConcurrency(allocator, program, false);
}

/// `allocator` and its parents must be threadsafe.
pub fn emitConcurrent(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts, NativeRequiresBundle })![]u8 {
    return emitWithConcurrency(allocator, program, true);
}

fn emitWithConcurrency(allocator: std.mem.Allocator, program: zx.ir.Program, comptime concurrent: bool) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts, NativeRequiresBundle })![]u8 {
    try validate(allocator, program);

    if (program.native_modules.count() != 0) return error.NativeRequiresBundle;

    return if (concurrent) @import("genz").zx.emitConcurrent(allocator, program) else @import("genz").zx.emit(allocator, program);
}

pub const Bundle = @import("genz").zx.Bundle;

pub fn emitBundle(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts })!Bundle {
    try validate(allocator, program);

    return @import("genz").zx.bundle(allocator, program);
}

fn validate(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts })!void {
    if (try @import("frontend").validateIr(allocator, program) != null) return error.InvalidIr;

    return verified(program);
}

/// Libraries and analysis results were validated where they entered the process, so only debug builds fully re-check their IR.
fn trusted(allocator: std.mem.Allocator, program: zx.ir.Program) (std.mem.Allocator.Error || error{ InvalidIr, UnverifiedContracts })!void {
    if (program.version != zx.ir_version) return error.InvalidIr;
    if (@import("frontend").checks_internal_ir) return validate(allocator, program);

    return verified(program);
}

fn verified(program: zx.ir.Program) error{UnverifiedContracts}!void {
    if (program.contracts.count() != 0) return error.UnverifiedContracts;

    for (0..program.functions.count()) |function_row| {
        const function = program.functions.at(function_row);

        if (function.contracts.count() != 0) return error.UnverifiedContracts;
    }
}
