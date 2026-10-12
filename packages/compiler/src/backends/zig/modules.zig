const std = @import("std");
const Analysis = @import("frontend").AnalysisResult;
const generating = @import("genz").zx.modules;
const names = @import("names.zig");
const references = @import("references.zig");
const fingerprint = @import("fingerprint.zig");
pub const Batch = @import("batch.zig");
const Cache = @import("cache.zig");
pub const Error = names.Error || generating.Error || error{ InvalidAnalysis, ConflictingFunction };
pub const File = struct { name: []const u8, source: []const u8, imports: []const []const u8 };
pub const StoreInitializer = struct { identity: []const u8, schema_version: u32, module_name: []const u8, type_name: []const u8 };
pub const Signature = struct { types: @import("zx").ir.TypeTable, input: @import("zx").ir.TypeId, output: @import("zx").ir.TypeId };

pub const Bundle = struct {
    arena: std.heap.ArenaAllocator,
    entry: File,
    types: []const u8,
    modules: []const File,
    type_names: []const []const u8 = &.{},
    native_modules: @import("zx").ir.NativeModuleTable = .{},
    store_initializers: []const StoreInitializer = &.{},
    state_module: ?[]const u8 = null,
    runner: ?[]const u8 = null,
    signature: ?Signature = null,
    pub fn deinit(self: *Bundle) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn create(allocator: std.mem.Allocator, analysis: *const Analysis) Error!Bundle {
    return createCached(allocator, analysis, null);
}

pub fn createCached(allocator: std.mem.Allocator, analysis: *const Analysis, cache: ?*Cache) Error!Bundle {
    if (analysis.value != .ir) return error.InvalidAnalysis;

    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const program = try @import("genz").zx.prepare(owned, analysis.value.ir);
    const identities = try names.create(owned, program, analysis.nominal_types);
    const needed = try references.reachable(owned, program);
    var batch = try Batch.create(allocator, program, identities, cache);

    defer batch.deinit();

    const entry = File{ .name = "application", .source = try batch.emit(owned, .entry), .imports = try references.imports(owned, program.expressions, program.contracts, identities.functions) };
    const modules = try functionFilesAnalyzed(owned, &batch, needed, &.{entry.source});
    const type_source = try batch.emit(owned, .types);
    const type_names = try typeNamesAnalyzed(owned, program, identities, batch.analysis.value.value.state);
    const native_modules = try nativeModules(owned, program);

    const signature = Signature{
        .types = try @import("frontend").type_table.copy(owned, program.types),
        .input = program.input_type,
        .output = program.output_type,
    };

    return .{ .arena = arena, .entry = entry, .types = type_source, .modules = modules, .type_names = type_names, .native_modules = native_modules, .signature = signature };
}

pub fn emit(allocator: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, unit: fingerprint.Unit, cache: ?*Cache) Error![]const u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return emitPrepared(allocator, try @import("genz").zx.prepare(arena.allocator(), program), identities, unit, cache);
}

pub fn emitPrepared(allocator: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, unit: fingerprint.Unit, cache: ?*Cache) Error![]const u8 {
    var batch = try Batch.create(allocator, program, identities, cache);

    defer batch.deinit();

    return batch.emit(allocator, unit);
}

/// The files of the `needed` functions; `roots` are the other generated sources that call into them.
pub fn functionFilesAnalyzed(owned: std.mem.Allocator, batch: *const Batch, needed: []const bool, roots: []const []const u8) Error![]const File {
    const units = try functionUnits(owned, needed);
    const sources = try @import("function_sources.zig").create(owned, batch, units);

    return functionFilesFrom(owned, batch, units, sources, roots);
}

/// The units of the `needed` functions.
pub fn functionUnits(owned: std.mem.Allocator, needed: []const bool) std.mem.Allocator.Error![]generating.Unit {
    var units: std.ArrayList(generating.Unit) = .empty;

    for (needed, 0..) |wanted, index| {
        if (wanted) try units.append(owned, .{ .function = @fromBackingInt(@intCast(index)) });
    }

    return units.toOwnedSlice(owned);
}

/// The files of function `units` from their generated `sources`, once the `roots` that call them are known.
pub fn functionFilesFrom(owned: std.mem.Allocator, batch: *const Batch, units: []generating.Unit, sources: [][]const u8, roots: []const []const u8) Error![]const File {
    const program = batch.program;
    const identities = batch.names;
    var files: std.ArrayList(File) = .empty;
    var seen: @import("zx").bytes.Map(usize) = .empty;

    try @import("regular_calls.zig").complete(owned, batch, roots, units, sources);

    for (units, sources) |unit, source| {
        const index = @backingInt(switch (unit) {
            .function, .regular => |id| id,
            else => unreachable,
        });

        const function = program.functions.at(index);

        const file = File{
            .name = identities.functions[index],
            .source = source,
            .imports = if (function.external) |external| try owned.dupe([]const u8, &.{try owned.dupe(u8, program.native_modules.at(@backingInt(external.module)).import_name)}) else try references.imports(owned, function.expressions, function.contracts, identities.functions),
        };

        const entry = try seen.getOrPut(owned, file.name);

        if (entry.found_existing) {
            if (!std.mem.eql(u8, files.items[entry.value_ptr.*].source, source)) return error.ConflictingFunction;

            continue;
        }

        entry.value_ptr.* = files.items.len;

        try files.append(owned, file);
    }

    return files.toOwnedSlice(owned);
}

pub fn typeNames(owned: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names) std.mem.Allocator.Error![]const []const u8 {
    const state_plan = try @import("genz").zx.state_value.Analysis.create(owned, program);

    defer owned.free(state_plan.selected);
    defer owned.free(state_plan.keys);

    return typeNamesAnalyzed(owned, program, identities, state_plan);
}

pub fn typeNamesAnalyzed(owned: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, state_plan: @import("genz").zx.state_value.Analysis) std.mem.Allocator.Error![]const []const u8 {
    var type_names: std.ArrayList([]const u8) = .empty;
    var type_set: @import("zx").bytes.Map(void) = .empty;

    for (0..program.types.count(), identities.types, 0..) |view_index, name, index| {
        const value = program.types.at(view_index);

        if (value != .object and value != .tuple and value != .enumeration and value != .native_reference) continue;
        if (!(try type_set.getOrPut(owned, name)).found_existing) try type_names.append(owned, name);

        if (state_plan.selected[index]) {
            const internal_name = try state_plan.name(owned, @fromBackingInt(@intCast(index)), name);

            if (!(try type_set.getOrPut(owned, internal_name)).found_existing) try type_names.append(owned, internal_name);
        }
    }

    return type_names.toOwnedSlice(owned);
}

pub fn nativeModules(owned: std.mem.Allocator, program: @import("zx").ir.Program) std.mem.Allocator.Error!@import("zx").ir.NativeModuleTable {
    const ir = @import("zx").ir;
    var native_modules: ir.NativeModuleStorage = .{};

    errdefer native_modules.deinit(owned);

    for (0..program.native_modules.count()) |index| {
        const module = program.native_modules.at(index);

        try native_modules.append(owned, .{
            .specifier = try owned.dupe(u8, module.specifier),
            .identity = if (module.identity) |identity| try owned.dupe(u8, identity) else null,
            .import_name = try owned.dupe(u8, module.import_name),
        });
    }

    return native_modules.finish(owned);
}
