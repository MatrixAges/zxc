const std = @import("std");
const f = @import("fixture.zig");
const Detached = @import("detached.zig");

fn entry(values: []const f.artifact.Module) !usize {
    for (values, 0..) |value, index| {
        if (std.mem.eql(u8, value.path, "/project/main.zx")) return index;
    }

    return error.MissingFixtureEntry;
}

fn control(values: []const f.artifact.Module) !void {
    var linked = try f.artifact.linker.link(std.testing.allocator, values, "/project/main.zx");

    defer linked.deinit();

    try std.testing.expectEqual(null, try f.compiler.validateIr(std.testing.allocator, linked.program));
}

test "signature columns reject every independent row count mismatch before access" {
    var detached = try Detached.init(std.testing.allocator, f.orderings[0], true);

    defer detached.deinit();

    try control(&detached.values);

    const index = try entry(&detached.values);
    const original = detached.values[index].functions;

    inline for (@typeInfo(f.ir.SignatureTable).@"struct".field_names) |name| {
        var values = detached.values;
        const column = @field(original, name);

        @field(values[index].functions, name) = column[0 .. column.len - 1];

        try std.testing.expect(!values[index].functions.validStructure());
        try std.testing.expectError(error.InvalidModule, f.artifact.linker.link(std.testing.allocator, &values, "/project/main.zx"));
    }
}

test "source signatures reject stray native ABI effect flags" {
    var detached = try Detached.init(std.testing.allocator, f.orderings[0], true);

    defer detached.deinit();

    try control(&detached.values);

    const index = try entry(&detached.values);

    inline for (.{ "native_allocators", "native_io", "native_process", "native_tuples", "native_fallible", "native_concurrent" }) |name| {
        var values = detached.values;
        const column = try std.testing.allocator.dupe(bool, @field(values[index].functions, name));

        defer std.testing.allocator.free(column);

        column[0] = true;

        @field(values[index].functions, name) = column;

        try std.testing.expect(!values[index].functions.validStructure());
        try std.testing.expectError(error.InvalidModule, f.artifact.linker.link(std.testing.allocator, &values, "/project/main.zx"));
    }
}

test "source signature ownership must match its linked function implementation" {
    var detached = try Detached.init(std.testing.allocator, f.orderings[0], true);

    defer detached.deinit();

    try control(&detached.values);

    const index = try entry(&detached.values);
    var values = detached.values;
    const column = try std.testing.allocator.dupe(f.ir.SymbolTable.Ownership, values[index].functions.ownership);

    defer std.testing.allocator.free(column);

    const row = @backingInt(try f.local(values[index], "first"));

    column[row] = if (column[row] == .Copy) .Borrowed else .Copy;
    values[index].functions.ownership = column;

    try std.testing.expect(values[index].functions.validStructure());
    try std.testing.expectError(error.ConflictingInterface, f.artifact.linker.link(std.testing.allocator, &values, "/project/main.zx"));
}
