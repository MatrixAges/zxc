const ir = @import("zx").ir;

pub fn borrow(comptime Candidate: type, value: ir.TypeValue, fields: @FieldType(Candidate, "fields")) Candidate {
    return .{
        .kind = switch (value) {
            .scalar => .Scalar,
            .object => .Object,
            .optional => .Optional,
            .list => .List,
            .task => .Task,
            .tuple => .Tuple,
            .error_set => .ErrorSet,
            .enumeration => .Enumeration,
            .native_reference => .NativeReference,
        },
        .first = switch (value) {
            .scalar => |scalar| @intCast(@backingInt(scalar)),
            .optional, .list => |child| @backingInt(child),
            .task => |task| @backingInt(task.result),
            else => 0,
        },
        .second = if (value == .task) @backingInt(value.task.errors) else 0,
        .label = value.nominalName() orelse "",
        .children = if (value == .tuple) @as([*]const u32, @ptrCast(value.tuple.ptr))[0..value.tuple.len] else &.{},
        .fields = fields,
        .names = switch (value) {
            .error_set => |names| names,
            .enumeration => |entry| entry.members,
            else => &.{},
        },
    };
}
