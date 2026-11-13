const std = @import("std");
const Symbols = @import("symbols.zig").Symbols;
const generated = @import("generated_project_binding");
pub const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const Record = if (@typeInfo(Input) == .pointer) std.meta.Child(Input) else Input;

pub fn init(allocator: std.mem.Allocator, item: anytype, symbols: *const Symbols) std.mem.Allocator.Error!Input {
    const values = try allocator.alloc([]const u8, item.nameCount());
    const starts = try allocator.alloc(u64, values.len);
    const ends = try allocator.alloc(u64, values.len);
    var aliases: ?[][]const u8 = null;

    for (values, starts, ends, 0..) |*value, *start, *end, index| {
        const name = item.nameAt(index);
        const source = item.sourceAt(index);

        value.* = source.text;
        start.* = source.span.start;
        end.* = source.span.end;

        if (aliases == null and !std.mem.eql(u8, value.*, name.text)) {
            aliases = try allocator.alloc([]const u8, values.len);

            @memcpy(aliases.?[0..index], values[0..index]);
        }

        if (aliases) |locals| locals[index] = name.text;
    }

    const names = try record(@FieldType(Record, "names"), allocator, .{ .values = values, .aliases = aliases orelse values, .starts = starts, .ends = ends });
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
