const access = @import("access.zig");
const Workspace = access.Workspace;
const view = access.view;
const Message = @import("zxc_abi").native.@"zig:resolution".Message;

pub fn failName(workspace: Workspace, start: u64, end: u64, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(workspace).reporter.fail(.name, .{ .start = @intCast(start), .end = @intCast(end) }, text(message));
}

pub fn failType(workspace: Workspace, start: u64, end: u64, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(workspace).reporter.fail(.type_mismatch, .{ .start = @intCast(start), .end = @intCast(end) }, text(message));
}

pub fn failOwnership(workspace: Workspace, start: u64, end: u64, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(workspace).reporter.fail(.ownership, .{ .start = @intCast(start), .end = @intCast(end) }, text(message));
}

pub fn failUnsupported(workspace: Workspace, start: u64, end: u64, message: Message) error{ InvalidSource, OutOfMemory }!void {
    return view(workspace).reporter.fail(.unsupported, .{ .start = @intCast(start), .end = @intCast(end) }, text(message));
}

fn text(message: Message) []const u8 {
    return switch (message) {
        .ImportedBuiltin => "an imported type cannot replace a built-in type",
        .ImportedDuplicate => "duplicate imported type name",
        .ImportedConflict => "a local type cannot replace an imported type",
        .DeclaredBuiltin => "a type cannot replace a built-in scalar",
        .DeclaredDuplicate => "duplicate type declaration",
        .Recursive => "recursive type aliases are not supported",
        .Depth => "type alias nesting exceeds 256 levels",
        .Unknown => "unknown or unsupported type",
        .EmptyEnum => "an enum must have at least one member",
        .DuplicateMember => "duplicate enum member",
        .AnonymousEnum => "enum types require a named declaration",
        .Application => "generic and database types are not enabled",
        .TaskContainer => "tasks cannot be placed in containers",
        .VoidList => "lists cannot contain void",
        .TaskTuple => "tasks cannot be placed in tuples",
        .VoidField => "object fields cannot have type void",
        .TaskObject => "tasks cannot be placed in objects",
        .DuplicateField => "duplicate object field",
    };
}
