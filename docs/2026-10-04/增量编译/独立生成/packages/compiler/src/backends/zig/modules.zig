const std = @import("std");
const Analysis = @import("frontend").AnalysisResult;
const generating = @import("genz").zx.modules;
const names = @import("names.zig");
const references = @import("references.zig");
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

        const source = try generating.function(owned, program, @enumFromInt(index), identities);

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

    return .{
        .arena = arena,
        .entry = .{ .name = "application", .source = try generating.entry(owned, program, identities), .imports = try references.imports(owned, program.expressions, program.contracts, identities.functions) },
        .types = try generating.types(owned, program, identities),
        .modules = try files.toOwnedSlice(owned),
    };
}
