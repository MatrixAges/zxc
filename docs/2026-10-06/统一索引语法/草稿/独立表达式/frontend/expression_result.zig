const std = @import("std");
const zx = @import("zx");
const parser = @import("parse_expression.zig");
pub const indexed_enabled = @import("parser_options").generated_parser;
pub const View = if (indexed_enabled) @import("syntax/program.zig").View(@import("generated_expression").Output) else void;

pub const Indexed = if (indexed_enabled) struct {
    arena: std.heap.ArenaAllocator,
    syntax_arena: std.heap.ArenaAllocator,
    source: []const u8,
    file_name: []const u8,
    output: @import("generated_expression").Output,
    pub fn view(self: @This(), allocator: std.mem.Allocator) std.mem.Allocator.Error!View {
        return View.init(allocator, self.source, self.output);
    }
} else void;

pub const Result = union(enum) {
    native: parser.Result,
    indexed: Indexed,
    pub fn deinit(self: *@This()) void {
        switch (self.*) {
            .native => |*result| result.deinit(),
            .indexed => |*result| if (indexed_enabled) {
                result.syntax_arena.deinit();
                result.arena.deinit();
            } else unreachable,
        }

        self.* = undefined;
    }

    pub fn diagnostic(self: *const @This()) ?zx.Diagnostic {
        return switch (self.*) {
            .native => |result| if (result.value == .diagnostic) result.value.diagnostic else null,
            .indexed => null,
        };
    }
};
