const std = @import("std");
const Scanner = std.json.Scanner;
const Token = std.json.Token;
const Self = @This();
const DepthError = error{JsonDepthExceeded};
pub const NextError = Scanner.NextError || DepthError;
pub const AllocError = Scanner.AllocError || DepthError;
pub const PeekError = Scanner.PeekError;

source: Scanner,
maximum_depth: usize,
pub fn parse(comptime T: type, allocator: std.mem.Allocator, bytes: []const u8, maximum_depth: usize) std.json.ParseError(Self)!T {
    var scanner: Self = .{
        .source = Scanner.initCompleteInput(allocator, bytes),
        .maximum_depth = maximum_depth,
    };

    defer scanner.source.deinit();

    return std.json.parseFromTokenSourceLeaky(T, allocator, &scanner, .{ .allocate = .alloc_always, .max_value_len = bytes.len });
}

pub inline fn next(self: *Self) NextError!Token {
    const token = try self.source.next();

    try self.checkOpening(token);

    return token;
}

pub inline fn nextAllocMax(self: *Self, allocator: std.mem.Allocator, when: Scanner.AllocWhen, max_value_len: usize) AllocError!Token {
    const token = try self.source.nextAllocMax(allocator, when, max_value_len);

    try self.checkOpening(token);

    return token;
}

pub inline fn peekNextTokenType(self: *Self) PeekError!std.json.TokenType {
    return self.source.peekNextTokenType();
}

pub inline fn allocNextIntoArrayListMax(self: *Self, values: *std.array_list.Managed(u8), when: Scanner.AllocWhen, max_value_len: usize) Scanner.AllocIntoArrayListError!?[]const u8 {
    return self.source.allocNextIntoArrayListMax(values, when, max_value_len);
}

pub fn skipValue(self: *Self) NextError!void {
    switch (try self.peekNextTokenType()) {
        .array_begin, .object_begin => {
            const depth = self.source.stackHeight();

            _ = try self.next();

            while (self.source.stackHeight() > depth) _ = try self.next();
        },
        else => try self.source.skipValue(),
    }
}

inline fn checkOpening(self: *const Self, token: Token) DepthError!void {
    switch (token) {
        .array_begin, .object_begin => if (self.source.stackHeight() > self.maximum_depth) return error.JsonDepthExceeded,
        else => {},
    }
}
