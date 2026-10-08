const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("nominal_data");

pub const Result = struct {
    origins: []const u64,
    mapping: []ir.TypeId,
    arena: std.heap.ArenaAllocator,
    pub fn deinitScratch(self: *Result) void {
        self.arena.deinit();
    }
};

pub const Error = std.mem.Allocator.Error || error{InvalidModule};

pub fn prepare(allocator: std.mem.Allocator, temporary: std.mem.Allocator, source: ir.TypeTable, origins: Origins.Table, target: ir.TypeTable, first: usize) Error!Result {
    if (!@import("parser_options").generated_parser) return @import("seed_preflight.zig").prepare(allocator, temporary, source, origins, target, first);

    const generated = @import("generated_merge_preflight");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Table = @typeInfo(@FieldType(Input, "source")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const source_table = ir.TypeTable.borrow(Table, source);
    const target_table = ir.TypeTable.borrow(Table, target);
    const bindings = Origins.Table.borrow(Bindings, origins);
    const input: Input = .{ .source = &source_table, .target = &target_table, .origins = &bindings, .names = origins.names, .first = first };
    var arena = std.heap.ArenaAllocator.init(temporary);

    errdefer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    const indices = result orelse return error.InvalidModule;

    return .{ .origins = indices, .mapping = try allocator.alloc(ir.TypeId, source.count()), .arena = arena };
}
