const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");

pub const Error = std.mem.Allocator.Error || error{ConflictingNominalType};

pub fn find(table: ir.TypeTable, bindings: Origins.Table, origin: Origins.Origin, value: ir.TypeValue) Error!?ir.TypeId {
    if (!@import("parser_options").generated_parser) return @import("seed_nominal.zig").find(table, bindings, origin, value);

    const generated = @import("generated_nominal_lookup");
    const Input = @typeInfo(generated.Input).pointer.child;
    const Tables = @typeInfo(@FieldType(Input, "tables")).pointer.child;
    const Table = @typeInfo(@FieldType(Tables, "base")).pointer.child;
    const Bindings = @typeInfo(@FieldType(Input, "origins")).pointer.child;
    const Binding = @typeInfo(@FieldType(Bindings, "base")).pointer.child;
    const Origin = @typeInfo(@FieldType(Input, "origin")).pointer.child;
    const Candidate = @typeInfo(@FieldType(Input, "candidate")).pointer.child;
    const Fields = @typeInfo(@FieldType(Candidate, "fields")).pointer.child;
    const base = ir.TypeTable.borrow(Table, table);
    const delta = ir.TypeTable.borrow(Table, .{});
    const tables: Tables = .{ .base = &base, .delta = &delta };
    const bound = Origins.Table.borrow(Binding, bindings);
    const empty = Origins.Table.borrow(Binding, .{});
    const origins: Bindings = .{ .base = &bound, .delta = &empty };

    const identity: Origin = .{
        .kind = switch (origin) {
            .source => 0,
            .native => 1,
            .external => 2,
        },
        .owner = switch (origin) {
            .source, .native => |text| text,
            .external => |entry| entry.module,
        },
        .member = if (origin == .external) origin.external.member else "",
    };

    const fields: Fields = .{ .names = &.{}, .types = &.{} };
    const candidate = @import("candidate.zig").borrow(Candidate, value, &fields);
    const input: Input = .{ .tables = &tables, .origins = &origins, .origin = &identity, .candidate = &candidate };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    const result = generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return switch (result) {
        0 => null,
        1 => error.ConflictingNominalType,
        else => @fromBackingInt(@intCast(result - 2)),
    };
}
