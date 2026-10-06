const std = @import("std");
const f = @import("fixture.zig");
const ir = f.compiler.ir;

pub const Mode = enum { missing_nominal, source_origin, other_origin, nominal_name, duplicate_nominal, missing_binding, renamed_binding, distinct_owner, same_owner_alias };

pub fn apply(value: *f.compiler.library.Result, mode: Mode) !void {
    const allocator = value.arena.allocator();
    const modules = try allocator.dupe(ir.NativeModule, value.program.native_modules);
    const bindings = try allocator.dupe(ir.Export, modules[0].types);
    const nominal = try allocator.dupe(@TypeOf(value.nominal_types[0]), value.nominal_types);

    value.program.native_modules = modules;
    modules[0].types = bindings;
    value.nominal_types = nominal;

    switch (mode) {
        .missing_nominal => value.nominal_types = &.{},
        .source_origin => nominal[0].origin = .{ .source = "types.zx" },
        .other_origin => nominal[0].origin = .{ .native = "another-owner" },
        .nominal_name => nominal[0].name = "Other",
        .duplicate_nominal => value.nominal_types = try allocator.dupe(@TypeOf(nominal[0]), &.{ nominal[0], nominal[0] }),
        .missing_binding => modules[0].types = &.{},
        .renamed_binding => bindings[0].name = "Alias",
        .distinct_owner => {
            const repeated = try allocator.dupe(ir.NativeModule, &.{ modules[0], modules[0] });

            repeated[1].identity = "another-owner";
            repeated[1].import_name = "alias";
            value.program.native_modules = repeated;
        },
        .same_owner_alias => modules[0].types = try allocator.dupe(ir.Export, &.{ bindings[0], .{ .name = "Alias", .type_id = bindings[0].type_id } }),
    }
}

pub fn envelope(allocator: std.mem.Allocator, value: *const f.compiler.library.Result) ![]u8 {
    const payload = try std.json.Stringify.valueAlloc(allocator, .{
        .ir_version = value.program.version,
        .program = value.program,
        .exports = value.exports,
        .nominal_types = value.nominal_types,
        .store_initializers = value.store_initializers,
    }, .{});

    defer allocator.free(payload);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(payload, &digest, .{});

    return std.fmt.allocPrint(allocator, "zxc.library.v2\n{s}\n{s}", .{ std.fmt.bytesToHex(digest, .lower), payload });
}

pub fn rejected(allocator: std.mem.Allocator, value: *const f.compiler.library.Result) !void {
    if (f.compiler.library.codec.encode(allocator, value)) |bytes| {
        allocator.free(bytes);

        return error.ExpectedInvalidLibrary;
    } else |err| if (err != error.InvalidLibrary) return err;

    const bytes = try envelope(allocator, value);

    defer allocator.free(bytes);

    if (f.compiler.library.codec.decode(allocator, bytes)) |original| {
        var decoded = original;

        decoded.deinit();

        return error.ExpectedInvalidLibrary;
    } else |err| if (err != error.InvalidLibrary) return err;
}
