const std = @import("std");
const zx = @import("zx");
const Parser = @import("frontend").Parser;
const lexer = @import("lexer");
const generated = @import("generated");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const starts = try std.json.parseFromSlice([]const usize, allocator, args[2], .{});
    const depth = try std.fmt.parseInt(usize, args[3], 10);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);
    var reporter = zx.Reporter{};
    const lexed = try lexer.lex(allocator, source, &reporter);

    for (starts.value) |start| {
        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        reporter = .{};

        var parser = Parser{ .allocator = arena.allocator(), .source = source, .tokens = lexed.tokens, .reporter = &reporter, .index = start, .depth = depth };

        const value = parser.typeNode() catch |err| switch (err) {
            error.InvalidSource => null,
            else => return err,
        };

        const actual = try generated.execute(&arena, &.{ .source = source, .start = start, .depth = depth });
        const diagnostic: struct { code: []const u8, start: usize, end: usize, message: []const u8 } = if (reporter.diagnostic) |item| .{ .code = @tagName(item.code), .start = item.span.start, .end = item.span.end, .message = item.message } else .{ .code = "", .start = @as(usize, 0), .end = @as(usize, 0), .message = "" };

        try output.interface.writeAll("{\"start\":");
        try std.json.Stringify.value(start, .{}, &output.interface);
        try output.interface.writeAll(",\"expected\":{\"value\":");
        if (value) |node| try writeType(&output.interface, node) else try output.interface.writeAll("null");
        try output.interface.writeAll(",\"index\":");
        try std.json.Stringify.value(parser.index, .{}, &output.interface);
        try output.interface.writeAll(",\"diagnostic\":");
        try std.json.Stringify.value(diagnostic, .{}, &output.interface);
        try output.interface.writeAll("},\"actual\":");
        try std.json.Stringify.value(actual, .{}, &output.interface);
        try output.interface.writeAll("}");
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}

fn writeType(writer: *std.Io.Writer, value: *const zx.ast.Type) std.Io.Writer.Error!void {
    try writer.writeByte('{');
    try std.json.Stringify.value(@tagName(value.*), .{}, writer);
    try writer.writeByte(':');

    switch (value.*) {
        .named => |name| try std.json.Stringify.value(name, .{}, writer),
        .enumeration => |names| try std.json.Stringify.value(names, .{}, writer),
        .optional, .list => |child| try writeType(writer, child),
        .application => |application| {
            try writer.writeAll("{\"name\":");
            try std.json.Stringify.value(application.name, .{}, writer);
            try writer.writeAll(",\"argument\":");
            try writeType(writer, application.argument);
            try writer.writeByte('}');
        },
        .tuple => |items| {
            try writer.writeByte('[');

            for (items, 0..) |item, index| {
                if (index != 0) try writer.writeByte(',');
                try writeType(writer, item);
            }

            try writer.writeByte(']');
        },
        .object => |fields| {
            try writer.writeByte('[');

            for (fields, 0..) |field, index| {
                if (index != 0) try writer.writeByte(',');
                try writer.writeAll("{\"name\":");
                try std.json.Stringify.value(field.name, .{}, writer);
                try writer.writeAll(",\"value\":");
                try writeType(writer, field.value);
                try writer.writeByte('}');
            }

            try writer.writeByte(']');
        },
    }

    try writer.writeByte('}');
}
