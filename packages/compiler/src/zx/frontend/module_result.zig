const std = @import("std");
const zx = @import("zx");
const lint = @import("lint");
const parser = @import("parse.zig");
pub const indexed_enabled = @import("parser_options").generated_parser;

pub const Indexed = if (indexed_enabled) struct {
    arena: std.heap.ArenaAllocator,
    syntax_arena: std.heap.ArenaAllocator,
    source: []const u8,
    file_name: []const u8,
    output: @import("generated_parser").Output,
} else void;

pub const Result = union(enum) {
    const Self = @This();

    native: parser.Result,
    indexed: Indexed,
    pub fn deinit(self: *Self) void {
        switch (self.*) {
            .native => |*result| result.deinit(),
            .indexed => |*result| if (indexed_enabled) {
                result.syntax_arena.deinit();
                result.arena.deinit();
            } else unreachable,
        }

        self.* = undefined;
    }

    pub fn diagnostic(self: *const Self) ?zx.Diagnostic {
        return switch (self.*) {
            .native => |result| if (result.value == .diagnostic) result.value.diagnostic else null,
            .indexed => null,
        };
    }
    pub fn check(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!?zx.Diagnostic {
        if (self.diagnostic()) |issue| return issue;

        return switch (self.*) {
            .native => |result| lint.source.check(allocator, .{
                .source = result.value.parsed.source,
                .comments = result.value.parsed.lexed.comments,
                .program = result.value.parsed.ast,
            }),
            .indexed => |result| if (indexed_enabled) lint.source.checkHeader(allocator, result.source, result.output.comments, @import("syntax/header.zig").View(@TypeOf(result.output)){
                .source = result.source,
                .storage = result.output,
            }) else unreachable,
        };
    }
};
