const std = @import("std");
const f = @import("fixture.zig");

test "native bindings reject a type id at the exact table boundary" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);

    module.types.type_ids = &.{@intCast(case.program.types.count())};

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native bindings reject the maximum out of range type id" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);

    module.types.type_ids = &.{std.math.maxInt(u32)};

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native bindings reject duplicate names even when ids agree" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);
    const id = module.types.type_ids[0];

    module.types = .{ .names = &.{ "Node", "Node" }, .type_ids = &.{ id, id } };

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native bindings permit a scalar binding alongside an opaque declaration" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);
    const id = module.types.type_ids[0];
    module.types = .{ .names = &.{ "Node", "Scalar" }, .type_ids = &.{ id, @backingInt(f.ir.Scalar.u64) } };

    try case.modules(&.{module});
    try case.expectModules(true);
}

test "native bindings permit a non ASCII scalar binding name" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);
    const id = module.types.type_ids[0];
    module.types = .{ .names = &.{ "Node", "数值" }, .type_ids = &.{ id, @backingInt(f.ir.Scalar.u64) } };

    try case.modules(&.{module});
    try case.expectModules(true);
}

test "native owners reject missing declaration bindings" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);

    module.types = .{};

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native owners require a binding matching the opaque declaration name" {
    var case = try f.Case.init();

    defer case.deinit();

    var module = case.program.native_modules.at(0);

    module.types.names = &.{"Other"};

    try case.modules(&.{module});
    try case.expectModules(false);
}

test "native owners permit two import aliases with equal binding identities" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    var alias = original;
    alias.import_name = "alias";

    try case.modules(&.{ original, alias });
    try case.expectModules(true);
}

test "native owners unify absent identity and an explicit specifier identity" {
    var case = try f.Case.init();

    defer case.deinit();

    var original = case.program.native_modules.at(0);
    original.identity = null;
    var alias = original;
    alias.identity = original.specifier;
    alias.import_name = "alias";

    try case.modules(&.{ original, alias });
    try case.expectModules(true);
}

test "native owners permit renamed aliases when one binding retains the declaration name" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    var alias = original;
    alias.import_name = "alias";
    alias.types.names = &.{"Alias"};

    try case.modules(&.{ original, alias });
    try case.expectModules(true);
}

test "native bindings reject conflicting type ids across aliases of one owner" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    var alias = original;
    alias.import_name = "alias";
    alias.types.type_ids = &.{@backingInt(f.ir.Scalar.u64)};

    try case.modules(&.{ original, alias });
    try case.expectModules(false);
}

test "native owners reject an opaque reference assigned to distinct identities" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    var other = original;
    other.import_name = "other";
    other.identity = "other-owner";

    try case.modules(&.{ original, other });
    try case.expectModules(false);
}

test "native owner checks traverse long alias prefixes and reject a conflicting tail" {
    var case = try f.Case.init();

    defer case.deinit();

    const original = case.program.native_modules.at(0);
    const rows = try case.arena.allocator().alloc(f.ir.NativeModule, 33);

    for (rows, 0..) |*row, index| {
        row.* = original;
        row.import_name = try std.fmt.allocPrint(case.arena.allocator(), "alias{d}", .{index});
    }

    try case.modules(rows);
    try case.expectModules(true);

    rows[rows.len - 1].types.type_ids = &.{@backingInt(f.ir.Scalar.u64)};

    try case.modules(rows);
    try case.expectModules(false);
}
