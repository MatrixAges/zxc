const std = @import("std");
const Analysis = @import("frontend").AnalysisResult;
const generating = @import("genz").zx.modules;
const names = @import("names.zig");
const references = @import("references.zig");
const fingerprint = @import("fingerprint.zig");
const Cache = @import("cache.zig");
pub const Error = names.Error || generating.Error || error{ InvalidAnalysis, ConflictingFunction };
pub const File = struct { name: []const u8, source: []const u8, imports: []const []const u8 };

pub const Bundle = struct {
    arena: std.heap.ArenaAllocator,
    entry: File,
    types: []const u8,
    modules: []const File,
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
    var files: std.ArrayList(File) = .empty;
    var seen: std.StringHashMapUnmanaged(usize) = .empty;

    for (program.functions, 0..) |function, index| {
        if (!needed[index]) continue;

        const source = try emit(owned, program, identities, .{ .function = @enumFromInt(index) }, cache);

        const file = File{
            .name = identities.functions[index],
            .source = source,
            .imports = if (function.external) |external| try owned.dupe([]const u8, &.{try owned.dupe(u8, program.native_modules[@intFromEnum(external.module)].import_name)}) else try references.imports(owned, function.expressions, function.contracts, identities.functions),
        };

        const entry = try seen.getOrPut(owned, file.name);

        if (entry.found_existing) {
            if (!std.mem.eql(u8, files.items[entry.value_ptr.*].source, source)) return error.ConflictingFunction;

            continue;
        }

        entry.value_ptr.* = files.items.len;

        try files.append(owned, file);
    }

    const entry = File{ .name = "application", .source = try emit(owned, program, identities, .entry, cache), .imports = try references.imports(owned, program.expressions, program.contracts, identities.functions) };
    const type_source = try emit(owned, program, identities, .types, cache);
    const modules = try files.toOwnedSlice(owned);

    return .{ .arena = arena, .entry = entry, .types = type_source, .modules = modules };
}

fn emit(allocator: std.mem.Allocator, program: @import("zx").ir.Program, identities: generating.Names, unit: fingerprint.Unit, cache: ?*Cache) Error![]const u8 {
    const store = cache orelse return generate(allocator, program, identities, unit);

    const name = switch (unit) {
        .function => |id| identities.functions[@intFromEnum(id)],
        .entry, .types => try std.fmt.allocPrint(allocator, "{s}:{s}", .{ @tagName(unit), program.file_name }),
    };

    const key = fingerprint.create(program, identities, unit);

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
