const std = @import("std");
const generated = @import("rx_options").generated_rules;
const rule = if (generated) @import("generated_rx_execution_tag") else void;

pub const Tag = if (generated) rule.Output else enum {
    Unknown,
    Module,
    Type,
    Args,
    Store,
    Import,
    Call,
    Task,
    Parallel,
    Switch,
    If,
    Else,
    Case,
    Default,
    Emit,
    Return,
    Route,
};

const Input = if (generated) std.meta.Child(rule.Input) else void;
pub const Scope = if (generated) @FieldType(Input, "scope") else enum { Any, Body, Task, Parallel };

pub fn admit(name: []const u8, scope: Scope) Tag {
    if (comptime generated) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        return rule.executeValue(empty.allocator(), &.{ .name = name, .scope = scope }) catch unreachable;
    }

    const tag = std.meta.stringToEnum(Tag, name) orelse return .Unknown;

    return switch (scope) {
        .Any => tag,
        .Parallel => switch (tag) {
            .Call, .Task => tag,
            else => .Unknown,
        },
        .Task, .Body => switch (tag) {
            .Call, .Parallel, .Switch, .If, .Emit, .Return => tag,
            .Task => if (scope == .Body) tag else .Unknown,
            else => .Unknown,
        },
    };
}
