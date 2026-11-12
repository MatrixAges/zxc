const std = @import("std");
const dsl = @import("dsl");
const generated = @import("generated_xml");
const adapter = @import("xml_adapter");
pub const Document = generated.Output;

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: union(enum) { document: Document, diagnostic: dsl.Diagnostic },
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn parse(allocator: std.mem.Allocator, source: []const u8) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const output = generated.execute(&arena, &.{ .source = source, .expressions = true }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => {
            const message = try std.fmt.allocPrint(arena.allocator(), "internal compiler error: generated XML parser failed with {s}", .{@errorName(err)});

            return .{ .arena = arena, .value = .{ .diagnostic = .{
                .code = .syntax,
                .location = .{ .offset = 0, .line = 1, .column = 1 },
                .element = "",
                .message = message,
            } } };
        },
    };

    if (output.control.message.len != 0) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .syntax,
        .location = adapter.location(output.control.issue),
        .element = "",
        .message = output.control.message,
    } } };

    return .{ .arena = arena, .value = .{ .document = output } };
}
