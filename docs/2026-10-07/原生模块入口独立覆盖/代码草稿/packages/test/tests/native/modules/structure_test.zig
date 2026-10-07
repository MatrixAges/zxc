const f = @import("fixture.zig");

fn short(comptime field: []const u8) !void {
    var case = try f.Case.init();

    defer case.deinit();

    @field(case.program.native_modules, field) = &.{};

    try case.expectModules(false);
}

test "native modules accept the complete analyzed registry" {
    var case = try f.Case.init();

    defer case.deinit();

    try case.expectModules(true);
}

test "native modules accept an empty registry without native reference types" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.types = .{};
    case.program.functions = .{};
    case.program.native_modules = .{};

    try case.expectModules(true);
}

test "native modules reject an empty registry that leaves an opaque type unowned" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.native_modules = .{};

    try case.expectModules(false);
}

test "native modules reject a short identity column before row access" {
    try short("identities");
}

test "native modules reject a short import name column before row access" {
    try short("import_names");
}

test "native modules reject a short specifier column before row access" {
    try short("specifiers");
}

test "native modules reject a short type id column before row access" {
    try short("type_ids");
}

test "native modules reject a short binding name column before row access" {
    try short("type_names");
}

test "native modules reject a short namespace column before row access" {
    try short("type_namespaces");
}

test "native modules reject an excess outer column" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.native_modules.identities = &.{ null, null };

    try case.expectModules(false);
}

test "native modules reject binding ids without matching names" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.native_modules.type_names = &.{&.{}};

    try case.expectModules(false);
}

test "native modules reject binding names without matching ids" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.native_modules.type_ids = &.{&.{}};

    try case.expectModules(false);
}

test "native modules reject extra inner binding names" {
    var case = try f.Case.init();

    defer case.deinit();

    case.program.native_modules.type_names = &.{&.{ "Node", "Other" }};

    try case.expectModules(false);
}
