const std = @import("std");
const zx = @import("zx");
const Graph = @import("../types.zig");
const enabled = @import("rx_options").generated_graph;
const generated = if (enabled) @import("generated_rx_field_access") else void;

const Receiver = if (enabled) @FieldType(@typeInfo(generated.Input).pointer.child, "receiver") else enum {
    Unknown,
    Sequence,
    Object,
    List,
    DeclaredObject,
    DeclaredList,
    String,
    OtherDeclared,
    Other,
};

const Route = if (enabled) generated.Output else enum {
    Declared,
    Open,
    Length,
    RequireList,
    DeferLength,
    InvalidDeclared,
    InvalidInferred,
};

pub fn route(shape: Graph.Shape, concrete: ?zx.ir.Type, name: []const u8) Route {
    const receiver: Receiver = switch (shape) {
        .unknown => .Unknown,
        .sequence => .Sequence,
        .object => .Object,
        .list => .List,
        .known => switch (concrete.?) {
            .object => .DeclaredObject,
            .list => .DeclaredList,
            .scalar => |scalar| if (scalar == .string) .String else .OtherDeclared,
            else => .OtherDeclared,
        },
        else => .Other,
    };

    if (!enabled) {
        const length = std.mem.eql(u8, name, "length");

        return switch (receiver) {
            .Unknown => if (length) .DeferLength else .Open,
            .Sequence => if (length) .RequireList else .InvalidInferred,
            .Object => .Open,
            .List => if (length) .Length else .InvalidInferred,
            .DeclaredObject => .Declared,
            .DeclaredList, .String => if (length) .Length else .InvalidDeclared,
            .OtherDeclared => .InvalidDeclared,
            .Other => .InvalidInferred,
        };
    }

    var bytes: [0]u8 = undefined;
    var scratch = std.heap.FixedBufferAllocator.init(&bytes);

    return generated.executeIn(scratch.allocator(), &.{ .receiver = receiver, .name = name }) catch unreachable;
}
