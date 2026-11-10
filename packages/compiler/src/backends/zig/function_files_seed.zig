const std = @import("std");
const generating = @import("genz").zx.modules;
const Batch = @import("batch.zig");
const references = @import("genz").zx.references;
const modules = @import("modules.zig");
const File = modules.File;
const Error = modules.Error;

pub fn create(owned: std.mem.Allocator, batch: *const Batch, units: []generating.Unit, sources: [][]const u8, roots: []const []const u8) Error![]const File {
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
            .imports = if (function.external) |external| try owned.dupe([]const u8, &.{try owned.dupe(u8, program.native_modules.at(@backingInt(external.module)).import_name)}) else try references.imports(owned, batch.backing, function.expressions, function.contracts, identities.functions, &.{}),
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
