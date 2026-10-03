const std = @import("std");
const diagnostic = @import("diagnostic.zig");
const children = @import("children.zig");
pub const ast = @import("ast.zig");
pub const parseXml = @import("xml/root.zig").parse;
pub const XmlResult = @import("xml/root.zig").Result;
pub const Diagnostic = diagnostic.Diagnostic;
pub const Reporter = diagnostic.Reporter;
pub const Error = diagnostic.Error;
pub const element = @import("element.zig").element;
pub const empty = children.empty;
pub const list = children.list;
pub const sequence = children.sequence;
pub const choice = children.choice;

pub fn Result(comptime Schema: type) type {
    return struct {
        arena: std.heap.ArenaAllocator,
        value: union(enum) {
            data: Schema.Data,
            diagnostic: Diagnostic,
        },
        pub fn deinit(self: *@This()) void {
            self.arena.deinit();

            self.* = undefined;
        }
    };
}

pub fn validate(comptime Schema: type, allocator: std.mem.Allocator, node: ast.Node, context: anytype) std.mem.Allocator.Error!Result(Schema) {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var reporter: Reporter = .{};

    const data = Schema.decode(arena.allocator(), node, &reporter, context) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = reporter.diagnostic.? } };
    };

    return .{ .arena = arena, .value = .{ .data = data } };
}

pub fn refine(comptime Schema: type, comptime callback: anytype) type {
    return struct {
        pub const Data = Schema.Data;
        pub const matches = Schema.matches;
        pub const names = Schema.names;

        pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *Reporter, context: anytype) Error!Data {
            const data = try Schema.decode(allocator, node, reporter, context);

            try callback(data, node, context, reporter);

            return data;
        }
    };
}
