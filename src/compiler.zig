const std = @import("std");

const diagnostic = @import("compiler/diagnostic.zig");
const generator = @import("compiler/generator.zig");
const parser = @import("compiler/parser.zig");
const tokenizer = @import("compiler/tokenizer.zig");
const validator = @import("compiler/validate.zig");

const Allocator = std.mem.Allocator;

pub const Diagnostic = diagnostic.Diagnostic;

pub const Result = union(enum) {
    zig_source: []u8,
    diagnostic: Diagnostic,

    pub fn deinit(self: Result, allocator: Allocator) void {
        switch (self) {
            .zig_source => |source| allocator.free(source),
            .diagnostic => {},
        }
    }
};

pub fn compile(
    allocator: Allocator,
    source: []const u8,
    file_name: []const u8,
) Allocator.Error!Result {
    var arena_state = std.heap.ArenaAllocator.init(allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    var reporter = diagnostic.Reporter{ .file_name = file_name };
    const tokens = tokenizer.tokenize(arena, source, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        return .{ .diagnostic = reporter.diagnostic.? };
    };
    const program = parser.parse(arena, tokens, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        return .{ .diagnostic = reporter.diagnostic.? };
    };
    validator.validate(arena, program, &reporter) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;
        return .{ .diagnostic = reporter.diagnostic.? };
    };

    return .{ .zig_source = try generator.generate(allocator, program) };
}
