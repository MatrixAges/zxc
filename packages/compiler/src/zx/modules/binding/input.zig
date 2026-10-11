const std = @import("std");
const Context = @import("context.zig");
const generated = @import("generated_project_binding");
pub const Input = @typeInfo(@TypeOf(generated.executeValue)).@"fn".param_types[1].?;
const Names = @FieldType(Input, "names");
const Exports = @FieldType(Input, "exports");
const Members = @FieldType(Input, "members");

pub fn init(allocator: std.mem.Allocator, item: anytype, context: Context) std.mem.Allocator.Error!Input {
    const values = try allocator.alloc([]const u8, item.nameCount());
    const starts = try allocator.alloc(u64, values.len);
    const ends = try allocator.alloc(u64, values.len);

    for (values, starts, ends, 0..) |*value, *start, *end, index| {
        const name = item.nameAt(index);

        value.* = name.text;
        start.* = name.span.start;
        end.* = name.span.end;
    }

    const names = try record(Names, allocator, .{ .values = values, .starts = starts, .ends = ends });
    const export_values = if (item.kind == .function) context.exports[0..0] else context.exports;
    const export_names = try allocator.alloc([]const u8, export_values.len);
    const export_ids = try allocator.alloc(u32, export_values.len);

    for (export_values, export_names, export_ids) |value, *name, *id| {
        name.* = value.name;
        id.* = @backingInt(value.type_id);
    }

    const exports = try record(Exports, allocator, .{ .names = export_names, .ids = export_ids });
    const member_values = if (item.kind == .function) context.members else context.members[0..0];
    const member_names = try allocator.alloc([]const u8, member_values.len);
    const ids = try allocator.alloc(u32, member_values.len);
    const input_types = try allocator.alloc(u32, member_values.len);
    const output_types = try allocator.alloc(u32, member_values.len);

    for (member_values, 0..) |value, index| {
        member_names[index] = value.name;
        ids[index] = @backingInt(value.id);
        input_types[index] = @backingInt(value.input_type);
        output_types[index] = @backingInt(value.output_type);
    }

    const members = try record(Members, allocator, .{ .names = member_names, .ids = ids, .input_types = input_types, .output_types = output_types });

    return .{
        .target = switch (context.target) {
            .source => .Source,
            .compiled => .Compiled,
            .native => .Native,
        },
        .kind = switch (item.kind) {
            .function => .Function,
            .enumeration => .Enumeration,
            .type_only => .TypeOnly,
        },
        .start = item.span.start,
        .end = item.span.end,
        .names = names,
        .type_only = context.type_only,
        .type_kinds = context.types.kinds,
        .exports = exports,
        .members = members,
    };
}

inline fn record(comptime Target: type, allocator: std.mem.Allocator, fields: anytype) std.mem.Allocator.Error!Target {
    const Value = if (@typeInfo(Target) == .pointer) @typeInfo(Target).pointer.child else Target;
    var value: Value = undefined;

    inline for (@typeInfo(Value).@"struct".field_names) |name| {
        @field(value, name) = if (comptime std.mem.eql(u8, name, "zx_origin")) null else @field(fields, name);
    }

    if (@typeInfo(Target) != .pointer) return value;

    const owned = try allocator.create(Value);

    owned.* = value;

    return owned;
}
