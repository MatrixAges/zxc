const Message = @import("zxc_abi").native.@"zig:construction".Message;
const access = @import("access.zig");
const Writer = access.Writer;
const view = access.view;

pub fn failType(writer: Writer, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(writer).reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, text(message));
}

pub fn failOwnership(writer: Writer, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(writer).reporter.fail(.ownership, .{ .start = 0, .end = 0 }, text(message));
}

pub fn failCapability(writer: Writer, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(writer).reporter.fail(.capability, .{ .start = 0, .end = 0 }, text(message));
}

fn text(message: Message) []const u8 {
    return switch (message) {
        .TaskContainer => "tasks cannot be placed in containers",
        .VoidList => "lists cannot contain void",
        .TaskTuple => "tasks cannot be placed in tuples",
        .TaskObject => "tasks cannot be placed in objects",
        .NativeTask => "tasks cannot return host references",
        .NestedTask => "a task cannot return another task",
    };
}
