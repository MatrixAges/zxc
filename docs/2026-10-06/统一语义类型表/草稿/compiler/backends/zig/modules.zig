const std = @import("std");
const Analysis = @import("frontend").AnalysisResult;
const generating = @import("genz").zx.modules;
const names = @import("names.zig");
const references = @import("references.zig");
const fingerprint = @import("fingerprint.zig");
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
    native_modules: []const @import("zx").ir.NativeModule = &.{},
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
    const program = analysis.value.ir;
    const identities = try names.create(owned, program, analysis.nominal_types);
    const needed = try references.reachable(owned, program);
    const modules = try functionFiles(owned, program, identities, needed, cache);
    const entry = File{ .name = "application", .source = try emit(owned, program, identities, .entry, cache), .imports = try references.imports(owned, program.expressions, program.contracts, identities.functions) };
    const type_source = try emit(owned, program, identities, .types, cache);
    const type_names = try typeNames(owned, program, identities);
    const native_modules = try nativeModules(owned, program);

    const signature = Signature{
        .types = try @import("frontend").type_table.copy(owned, program.types),
        .input = program.input_type,
        .output = program.output_type,
    };

    return .{ .arena = arena, .entry = entry, .types = type_source, .modules = modules, .type_names = type_names, .native_modules = native_modules, .signature = signature };
}

pub fn emit(allocator: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, unit: fingerprint.Unit, cache: ?*Cache) Error![]const u8 {
    const store = cache orelse return generate(allocator, program, identities, unit);

    const name = switch (unit) {
        .function => |id| identities.functions[@backingInt(id)],
        .entry, .types => try std.fmt.allocPrint(allocator, "{s}:{s}", .{ @tagName(unit), program.file_name }),
    };

    const key = try fingerprint.create(allocator, program, identities, unit);

    if (try store.get(name, key)) |source| return allocator.dupe(u8, source);

    const source = try generate(allocator, program, identities, unit);

    store.generated += 1;

    try store.put(name, key, source);

    return source;
}

fn generate(allocator: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, unit: fingerprint.Unit) Error![]const u8 {
    return switch (unit) {
        .entry => generating.entry(allocator, program, identities),
        .function => |id| generating.function(allocator, program, id, identities),
        .types => generating.types(allocator, program, identities),
    };
}

pub fn functionFiles(owned: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, needed: []const bool, cache: ?*Cache) Error![]const File {
    var files: std.ArrayList(File) = .empty;
    var seen: std.StringHashMapUnmanaged(usize) = .empty;

    for (program.functions, 0..) |function, index| {
        if (!needed[index]) continue;

        const source = try emit(owned, program, identities, .{ .function = @fromBackingInt(@intCast(index)) }, cache);

        const file = File{
            .name = identities.functions[index],
            .source = source,
            .imports = if (function.external) |external| try owned.dupe([]const u8, &.{try owned.dupe(u8, program.native_modules[@backingInt(external.module)].import_name)}) else try references.imports(owned, function.expressions, function.contracts, identities.functions),
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
    var type_names: std.ArrayList([]const u8) = .empty;
    var type_set: std.StringHashMapUnmanaged(void) = .empty;
    const state_plan = try @import("genz").zx.state_value.Analysis.create(owned, program);

    defer owned.free(state_plan.selected);
    defer owned.free(state_plan.keys);

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

pub fn nativeModules(owned: std.mem.Allocator, program: @import("zx").ir.Program) std.mem.Allocator.Error![]const @import("zx").ir.NativeModule {
    const native_modules = try owned.dupe(@import("zx").ir.NativeModule, program.native_modules);

    for (native_modules) |*module| {
        module.specifier = try owned.dupe(u8, module.specifier);
        module.import_name = try owned.dupe(u8, module.import_name);
        module.identity = if (module.identity) |key| try owned.dupe(u8, key) else null;
        module.types = &.{};
        module.type_namespace = &.{};
    }

    return native_modules;
}
