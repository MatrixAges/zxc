const std = @import("std");
const node = @import("../node.zig");
pub const Fields = struct { start: u32, len: u32 };
pub const Arms = struct { start: u32, len: u32 };
pub const Declarations = struct { start: u32, len: u32 };

pub fn Value(comptime Source: type) type {
    @setEvalBranchQuota(10_000);

    if (Source == []const node.Field) return Fields;
    if (Source == []const node.SelectionArm) return Arms;
    if (Source == []const node.Declaration) return Declarations;
    if (Source == f64) return u64;

    return switch (@typeInfo(Source)) {
        .@"struct" => |info| blk: {
            var types: [info.field_names.len]type = undefined;
            var changed = false;

            for (info.field_names, &types) |name, *target| {
                target.* = Value(@FieldType(Source, name));
                changed = changed or target.* != @FieldType(Source, name);
            }

            if (!changed) break :blk Source;

            break :blk @Struct(.auto, null, info.field_names, &types, &@splat(.{}));
        },
        .@"union" => |info| blk: {
            var types: [info.field_names.len]type = undefined;

            for (info.field_names, &types) |name, *target| target.* = Value(@FieldType(Source, name));

            break :blk @Union(.auto, std.meta.Tag(Source), info.field_names, &types, &@splat(.{}));
        },
        else => Source,
    };
}

pub fn copy(storage: *@import("storage.zig"), allocator: std.mem.Allocator, source: anytype) std.mem.Allocator.Error!Value(@TypeOf(source)) {
    const Source = @TypeOf(source);

    if (Source == []const node.Field) return storage.fields(allocator, source);
    if (Source == []const node.SelectionArm) return storage.arms(allocator, source);
    if (Source == []const node.Declaration) return storage.declarations(allocator, source);
    if (Source == f64) return @bitCast(source);

    return switch (@typeInfo(Source)) {
        .@"struct" => |info| blk: {
            var result: Value(Source) = undefined;

            inline for (info.field_names) |name| @field(result, name) = try copy(storage, allocator, @field(source, name));

            break :blk result;
        },
        .@"union" => switch (source) {
            inline else => |payload, tag| @unionInit(Value(Source), @tagName(tag), try copy(storage, allocator, payload)),
        },
        else => source,
    };
}
