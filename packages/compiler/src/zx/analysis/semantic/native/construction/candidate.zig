const access = @import("access.zig");
const Writer = access.Writer;
const view = access.view;

pub fn candidateKind(writer: Writer) u8 {
    return @intCast(@backingInt(view(writer).value));
}

pub fn candidateFirst(writer: Writer) u32 {
    return switch (view(writer).value) {
        .optional, .list => |child| @backingInt(child),
        .task => |task| @backingInt(task.result),
        else => 0,
    };
}

pub fn candidateSecond(writer: Writer) u32 {
    const value = view(writer).value;

    return if (value == .task) @backingInt(value.task.errors) else 0;
}

pub fn references(writer: Writer) []const u32 {
    const value = view(writer).value;

    return if (value == .tuple) @ptrCast(value.tuple) else &.{};
}

pub fn fieldNames(writer: Writer) []const []const u8 {
    const data = view(writer);

    return if (data.value == .object) data.state.columns.names else &.{};
}

pub fn fieldTypes(writer: Writer) []const u32 {
    return view(writer).state.columns.types orelse &.{};
}

pub fn memberNames(writer: Writer) []const []const u8 {
    const data = view(writer);

    return if (data.value == .error_set) data.state.columns.names else &.{};
}
