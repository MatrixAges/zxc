const std = @import("std");
const h = @import("provenance/check.zig");
const f = h.f;

test "entry artifact rejects a record path different from its program source" {
    try h.source(.entry_path);
}

test "function artifact rejects a record path different from its function source" {
    try h.source(.function_path);
}

test "entry record cannot select a different source function body" {
    try h.source(.entry_as_function);
}

test "helper record cannot select the entry body from a different source" {
    try h.source(.function_as_entry);
}

test "native function cannot become a source artifact body even with a matching path" {
    try h.source(.native_body);
}

test "function artifact rejects the first body id outside the function table" {
    try h.source(.function_end);
}

test "function artifact rejects the maximum body id before reading source columns" {
    try h.source(.function_max);
}

test "type record from a different file remains eligible for extraction" {
    var analysis = try f.analyze(f.orders[0]);

    defer analysis.deinit();

    const selected = try f.index(analysis, f.types_path);

    try std.testing.expect(!std.mem.eql(u8, analysis.modules[selected].path, analysis.value.ir.file_name));
    try f.control(&analysis, selected);
}

test "type only program cannot become an entry body with a matching file path" {
    var analysis = try f.compiler.project.analyze(std.testing.allocator, &.{.{ .path = "types.zx", .source = "export type Count = u64\n" }}, .{ .entry = "types.zx", .root_dir = "/project" });

    defer analysis.deinit();

    try std.testing.expect(analysis.value == .ir and analysis.value.ir.type_only);
    try f.control(&analysis, 0);

    const records = try h.mutation.records(&analysis);

    records[0].body = .entry;

    try h.rejected(&analysis, 0, error.InvalidModule);
}
