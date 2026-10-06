const std = @import("std");
const F = @import("fixture.zig");

test "kinds row column shorter than the other row columns" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();
    table.kinds = table.kinds[0 .. table.kinds.len - 1];

    try f.checkTable(table, false, false);
}

test "first row column shorter than the other row columns" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();

    table.first = table.first[0 .. table.first.len - 1];

    try f.checkTable(table, false, false);
}

test "second row column shorter than the other row columns" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();

    table.second = table.second[0 .. table.second.len - 1];

    try f.checkTable(table, false, false);
}

test "labels row column shorter than the other row columns" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();
    table.labels = table.labels[0 .. table.labels.len - 1];

    try f.checkTable(table, false, false);
}

test "field_names length mismatch rejects before field access" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();

    table.field_names = table.field_names[0 .. table.field_names.len - 1];

    try f.checkTable(table, false, false);
}

test "field_types length mismatch rejects before field access" {
    var f = try F.init();

    defer f.deinit();

    var table = f.storage.view();

    table.field_types = table.field_types[0 .. table.field_types.len - 1];

    try f.checkTable(table, false, false);
}

test "children unowned trailing element is rejected" {
    var f = try F.init();

    defer f.deinit();

    try f.storage.children.append(std.testing.allocator, 0);
    try f.check(false, false);
}

test "names unowned trailing element is rejected" {
    var f = try F.init();

    defer f.deinit();

    try f.storage.names.append(std.testing.allocator, "Tail");
    try f.check(false, false);
}

test "unowned paired field tail is rejected" {
    var f = try F.init();

    defer f.deinit();

    try f.storage.field_names.append(std.testing.allocator, "tail");
    try f.storage.field_types.append(std.testing.allocator, 5);
    try f.check(false, false);
}

test "tuple noncontiguous auxiliary start is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.tuple] += 1;

    try f.check(false, false);
}

test "tuple maximum start rejects before auxiliary subtraction" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.tuple] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "tuple maximum count rejects before auxiliary slicing" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.tuple] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "object noncontiguous auxiliary start is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.object] += 1;

    try f.check(false, false);
}

test "object maximum start rejects before auxiliary subtraction" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.object] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "object maximum count rejects before auxiliary slicing" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.object] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "enumeration noncontiguous auxiliary start is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.enumeration] += 1;

    try f.check(false, false);
}

test "enumeration maximum start rejects before auxiliary subtraction" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.enumeration] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "enumeration maximum count rejects before auxiliary slicing" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.enumeration] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "errors noncontiguous auxiliary start is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.errors] += 1;

    try f.check(false, false);
}

test "errors maximum start rejects before auxiliary subtraction" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.errors] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "errors maximum count rejects before auxiliary slicing" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.errors] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "optional unexpected second column is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.optional] = 1;

    try f.check(false, false);
}

test "list unexpected second column is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.list] = 1;

    try f.check(false, false);
}

test "native unexpected second column is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.native] = 1;

    try f.check(false, false);
}

test "native reference unexpected first column is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.native] = 1;

    try f.check(false, false);
}

test "scalar code outside scalar range is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[0] = std.math.maxInt(u32);

    try f.check(false, false);
}

test "scalar unexpected second column is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[0] = 1;

    try f.check(false, false);
}

test "unknown kind 9 rejects before row interpretation" {
    var f = try F.init();

    defer f.deinit();

    f.storage.kinds.items[f.ids.tuple] = 9;

    try f.check(false, false);
}

test "unknown kind 255 rejects before row interpretation" {
    var f = try F.init();

    defer f.deinit();

    f.storage.kinds.items[f.ids.tuple] = 255;

    try f.check(false, false);
}

test "optional cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.optional] = "Unexpected";

    try f.check(false, false);
}

test "list cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.list] = "Unexpected";

    try f.check(false, false);
}

test "tuple cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.tuple] = "Unexpected";

    try f.check(false, false);
}

test "object cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.object] = "Unexpected";

    try f.check(false, false);
}

test "errors cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.errors] = "Unexpected";

    try f.check(false, false);
}

test "task cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.task] = "Unexpected";

    try f.check(false, false);
}

test "scalar cannot carry a nominal label" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[0] = "Unexpected";

    try f.check(false, false);
}
