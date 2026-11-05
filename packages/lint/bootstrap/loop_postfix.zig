const std = @import("std");
pub const Kind = enum { Other, Call, Field, Index, Identifier };

pub fn check(kind: Kind, receiver: Kind, callee: Kind, name: []const u8) bool {
    const postfix = kind == .Call or kind == .Field or kind == .Index;

    return postfix and receiver == .Call and callee == .Identifier and std.mem.eql(u8, name, "loop");
}
