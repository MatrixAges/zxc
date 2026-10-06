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
    pub fn header(self: *const @This()) @import("syntax/header.zig").View(@import("generated_parser").Output) {
        return .{ .source = self.source, .storage = self.output };
    }
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

    pub fn metadata(self: *const Self) struct { has_store: bool, function_start: usize } {
        return switch (self.*) {
            .native => |result| .{ .has_store = result.value.parsed.ast.has_store, .function_start = result.value.parsed.ast.function_start },
            .indexed => |result| if (indexed_enabled) .{ .has_store = result.output.has_store, .function_start = @intCast(result.output.function_start) } else unreachable,
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
            .indexed => |result| if (indexed_enabled) block: {
                const header = result.header();

                if (result.output.body == null and result.output.contracts.len == 0) break :block try lint.source.checkHeader(allocator, result.source, result.output.comments, header);

                var scratch = std.heap.ArenaAllocator.init(allocator);

                defer scratch.deinit();

                const View = @import("syntax/program.zig").View(@TypeOf(result.output));
                const view = try View.init(scratch.allocator(), result.source, result.output);
                const program = view.program();

                break :block try lint.source.checkView(allocator, result.source, result.output.comments, header, program.contracts, program.body);
            } else unreachable,
        };
    }
    pub fn format(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
        const spaced = try self.formatSpacing(allocator);

        defer allocator.free(spaced);

        const source = switch (self.*) {
            .native => |result| result.value.parsed.source,
            .indexed => |result| if (indexed_enabled) result.source else unreachable,
        };

        if (std.mem.eql(u8, source, spaced)) return self.indent(allocator);

        const file_name = switch (self.*) {
            .native => |result| result.value.parsed.file_name,
            .indexed => |result| if (indexed_enabled) result.file_name else unreachable,
        };

        var parsed = try parser.parseModule(allocator, spaced, file_name);

        defer parsed.deinit();
        std.debug.assert(parsed.diagnostic() == null);

        return parsed.indent(allocator);
    }
    fn indent(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
        return switch (self.*) {
            .native => |result| lint.indentation.zx.format(allocator, result.value.parsed.source, result.value.parsed.lexed.tokens, result.value.parsed.lexed.comments),
            .indexed => |result| if (indexed_enabled) lint.indentation.zx.format(allocator, result.source, result.output.tokens, result.output.comments) else unreachable,
        };
    }
    fn formatSpacing(self: *const Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
        return switch (self.*) {
            .native => |result| lint.source.format(allocator, .{
                .source = result.value.parsed.source,
                .comments = result.value.parsed.lexed.comments,
                .program = result.value.parsed.ast,
            }),
            .indexed => |result| if (indexed_enabled) block: {
                var scratch = std.heap.ArenaAllocator.init(allocator);

                defer scratch.deinit();

                const View = @import("syntax/program.zig").View(@TypeOf(result.output));
                const view = try View.init(scratch.allocator(), result.source, result.output);

                break :block try lint.source.formatView(allocator, result.source, result.output.comments, result.header(), view.program().body);
            } else unreachable,
        };
    }
};
