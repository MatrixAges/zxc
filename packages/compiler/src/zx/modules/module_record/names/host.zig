const std = @import("std");
const zx = @import("zx");
const enabled = @import("parser_options").generated_parser;

const Columns = struct {
    locals: []const []const u8,
    originals: []const []const u8 = &.{},
};

pub fn own(allocator: std.mem.Allocator, item: anytype) std.mem.Allocator.Error!Columns {
    if (comptime enabled and @hasField(@TypeOf(item.header), "storage")) return indexed(allocator, item);

    const locals = try allocator.alloc([]const u8, item.nameCount());

    for (locals, 0..) |*owned, index| owned.* = try allocator.dupe(u8, item.nameAt(index).text);

    var originals: ?[][]const u8 = null;

    for (locals, 0..) |local, index| {
        const original = item.sourceAt(index).text;

        if (originals == null and !std.mem.eql(u8, local, original)) {
            originals = try allocator.alloc([]const u8, locals.len);

            @memcpy(originals.?[0..index], locals[0..index]);
        }

        if (originals) |values| values[index] = if (std.mem.eql(u8, local, original)) local else try allocator.dupe(u8, original);
    }

    return .{ .locals = locals, .originals = originals orelse &.{} };
}

fn indexed(allocator: std.mem.Allocator, item: anytype) std.mem.Allocator.Error!Columns {
    const storage = item.header.storage;
    const row = storage.imports[item.index];
    const first: usize = @intCast(row.first);
    const count: usize = @intCast(row.count);

    if (count == 0) return .{ .locals = &.{} };

    const names = @import("generated_module_record_names");
    const alias = @import("generated_module_record_alias");
    const Input = std.meta.Child(names.Input);
    const Source = std.meta.Child(@FieldType(Input, "names"));

    const source: Source = .{
        .source = item.header.source,
        .locals = zx.columns.slice(@FieldType(Source, "locals"), storage.import_names[first..][0..count]),
        .originals = zx.columns.slice(@FieldType(Source, "originals"), storage.import_sources[first..][0..count]),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const aliased = zx.columns.invoke(alias.executeValue, empty.allocator(), &source) catch unreachable;
    const locals = try allocator.alloc([]const u8, count);
    const originals = if (aliased) try allocator.alloc([]const u8, count) else &.{};

    const input: Input = .{
        .names = &source,
        .locals = @ptrCast(&locals),
        .originals = if (aliased) @ptrCast(&originals) else null,
    };

    zx.columns.invoke(names.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{ .locals = locals, .originals = originals };
}
