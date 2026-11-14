const std = @import("std");
const zx = @import("zx");
const Symbols = @import("symbols.zig").Symbols;
const generated = @import("generated_project_binding");
pub const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const Record = if (@typeInfo(Input) == .pointer) std.meta.Child(Input) else Input;
const Names = @FieldType(Record, "names");

pub fn init(allocator: std.mem.Allocator, item: anytype, symbols: *const Symbols) std.mem.Allocator.Error!Input {
    const names = try importNames(allocator, item);
    const export_names = try allocator.alloc([]const u8, symbols.exports.len);
    const export_ids = try allocator.alloc(u32, symbols.exports.len);

    for (symbols.exports, export_names, export_ids) |value, *name, *id| {
        name.* = value.name;
        id.* = @backingInt(value.type_id);
    }

    const exports = try record(@FieldType(Record, "exports"), allocator, .{ .names = export_names, .ids = export_ids });
    const constants = try allocator.alloc([]const u8, if (item.kind == .type_only) 0 else symbols.constants.len);

    for (symbols.constants[0..constants.len], constants) |*value, *name| name.* = value.name;

    return record(Input, allocator, .{
        .target = @as(@FieldType(Record, "target"), switch (symbols.target) {
            .source => .Source,
            .compiled => .Compiled,
            .native => .Native,
        }),
        .kind = @as(@FieldType(Record, "kind"), switch (item.kind) {
            .function => .Function,
            .enumeration => .Enumeration,
            .type_only => .TypeOnly,
        }),
        .reexport = item.exported,
        .wildcard = item.wildcard,
        .start = @as(u64, item.span.start),
        .end = @as(u64, item.span.end),
        .names = names,
        .type_kinds = symbols.types.kinds,
        .exports = exports,
        .constants = constants,
        .members = symbols.functions,
    });
}

fn importNames(allocator: std.mem.Allocator, item: anytype) std.mem.Allocator.Error!Names {
    if (comptime @hasField(@TypeOf(item.header), "storage")) {
        const storage = item.header.storage;
        const row = storage.imports[item.index];
        const first: usize = @intCast(row.first);
        const count: usize = @intCast(row.count);

        return record(Names, allocator, .{
            .source = @as(?[]const u8, item.header.source),
            .locals = zx.columns.slice(field(Names, "locals"), storage.import_names[first..][0..count]),
            .originals = zx.columns.slice(field(Names, "originals"), storage.import_sources[first..][0..count]),
            .values = @as([]const []const u8, &.{}),
            .aliases = @as([]const []const u8, &.{}),
        });
    }

    const count = item.nameCount();
    const values = try allocator.alloc([]const u8, count);
    const aliases = try allocator.alloc([]const u8, count);
    const Span = std.meta.Child(field(Names, "originals"));
    const indirect = @typeInfo(Span) == .pointer;
    const Position = if (indirect) std.meta.Child(Span) else Span;
    const positions = try allocator.alloc(Position, count);
    const spans = if (indirect) try allocator.alloc(Span, count) else positions;

    for (values, aliases, positions, 0..) |*value, *alias, *span, index| {
        const source = item.sourceAt(index);

        value.* = source.text;
        alias.* = item.nameAt(index).text;
        span.* = .{ .start = source.span.start, .end = source.span.end };

        if (indirect) spans[index] = span;
    }

    return record(Names, allocator, .{
        .source = @as(?[]const u8, null),
        .locals = @as(field(Names, "locals"), &.{}),
        .originals = @as(field(Names, "originals"), spans),
        .values = @as([]const []const u8, values),
        .aliases = @as([]const []const u8, aliases),
    });
}

fn field(comptime Target: type, comptime name: []const u8) type {
    return @FieldType(if (@typeInfo(Target) == .pointer) std.meta.Child(Target) else Target, name);
}

inline fn record(comptime Target: type, allocator: std.mem.Allocator, fields: anytype) std.mem.Allocator.Error!Target {
    const Value = if (@typeInfo(Target) == .pointer) std.meta.Child(Target) else Target;
    var value: Value = undefined;

    inline for (@typeInfo(Value).@"struct".field_names) |name| {
        @field(value, name) = if (comptime std.mem.eql(u8, name, "zx_origin")) null else @field(fields, name);
    }

    if (@typeInfo(Target) != .pointer) return value;

    const owned = try allocator.create(Value);

    owned.* = value;

    return owned;
}
