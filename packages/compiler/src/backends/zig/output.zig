const std = @import("std");
const zx = @import("zx");
pub const available = @import("parser_options").generated_parser;

pub const Input = struct {
    paths: []const []const u8,
    hashes: []const u64,
    previous_paths: []const []const u8,
    previous_hashes: []const u64,
    present: bool,
};

pub const Selection = struct { changed: []const u32, aligned: bool };
pub const Index = if (available) std.meta.Child(@import("generated_output_wanted").Output) else zx.bytes.Map(void);

pub const Changes = struct {
    arena: std.heap.ArenaAllocator,
    value: Selection,
    pub fn deinit(self: *@This()) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const Wanted = struct {
    arena: std.heap.ArenaAllocator,
    value: Index,
    pub fn deinit(self: *@This()) void {
        self.arena.deinit();

        self.* = undefined;
    }

    pub fn shouldRemove(self: *const @This(), path: []const u8, fingerprint: []const u8, preserve: bool) bool {
        if (comptime !available) return !(preserve and std.mem.eql(u8, path, fingerprint)) and !self.value.contains(path);

        const entry = @import("generated_output_stale");
        const Fields = std.meta.Child(entry.Input);
        const input: Fields = .{ .index = &self.value, .path = path, .fingerprint = fingerprint, .preserve_fingerprint = preserve };
        var memory = std.heap.FixedBufferAllocator.init(&.{});

        return entry.executeValue(memory.allocator(), &input) catch |err| switch (err) {
            else => @panic(@errorName(err)),
        };
    }
};

pub fn changes(workspace: std.mem.Allocator, input: Input) std.mem.Allocator.Error!Changes {
    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const allocator = arena.allocator();

    if (comptime !available) return .{ .arena = arena, .value = try @import("output_seed.zig").changes(allocator, input) };

    const entry = @import("generated_output_changes");
    const Fields = std.meta.Child(entry.Input);
    const fields: Fields = .{ .paths = input.paths, .hashes = input.hashes, .previous_paths = input.previous_paths, .previous_hashes = input.previous_hashes, .present = input.present };
    const result = zx.columns.invoke(entry.executeValue, allocator, &fields) catch |err| return failure(err);

    return .{ .arena = arena, .value = .{ .changed = result.changed, .aligned = result.aligned } };
}

pub fn wanted(workspace: std.mem.Allocator, paths: []const []const u8) std.mem.Allocator.Error!Wanted {
    var arena = std.heap.ArenaAllocator.init(workspace);

    errdefer arena.deinit();

    const allocator = arena.allocator();

    if (comptime !available) return .{ .arena = arena, .value = try @import("output_seed.zig").wanted(allocator, paths) };

    const result = @import("generated_output_wanted").executeValue(allocator, paths) catch |err| return failure(err);

    return .{ .arena = arena, .value = zx.columns.view(Index, result) };
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid generated file ledger"),
    };
}
