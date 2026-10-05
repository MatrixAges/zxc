const std = @import("std");
const allocation_testing = @import("allocation_testing");
const rx = @import("rx");

const Case = struct {
    source: []const u8,
    value: []const u8 = "",
    raw: []const u8 = "",
    kind: @FieldType(rx.ast.Attribute, "kind") = .string,
    syntax: bool = false,
    path: ?[]const u8 = null,
    attribute: ?[]const u8 = null,
    offset: usize = 0,
};

pub fn check(text: []const u8) !void {
    const document = try std.json.parseFromSlice(Case, std.testing.allocator, text, .{});

    defer document.deinit();

    try verify(std.testing.allocator, document.value);
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, verify, .{document.value});
}

fn verify(allocator: std.mem.Allocator, case: Case) !void {
    const source = try allocator.dupe(u8, case.source);

    defer allocator.free(source);

    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();
    @memset(source, 'x');

    if (case.syntax) {
        try std.testing.expect(parsed.value == .diagnostic);
        try std.testing.expectEqual(.syntax, parsed.value.diagnostic.code);

        return;
    }

    if (parsed.value == .diagnostic) {
        std.debug.print("unexpected XML diagnostic: {s}\n", .{parsed.value.diagnostic.message});

        return error.UnexpectedDiagnostic;
    }

    if (case.path) |path| {
        var result = try rx.validate(allocator, path, parsed.value.node);

        defer result.deinit();

        if (case.attribute) |attribute| {
            try std.testing.expect(result.value == .diagnostic);
            try std.testing.expectEqual(.invalid_attribute, result.value.diagnostic.code);
            try std.testing.expectEqualStrings(attribute, result.value.diagnostic.attribute.?);
            try std.testing.expectEqual(case.offset, result.value.diagnostic.location.offset);
        } else {
            if (result.value == .diagnostic) std.debug.print("unexpected schema diagnostic: {s}\n", .{result.value.diagnostic.message});
            try std.testing.expect(result.value == .data);
        }

        return;
    }

    const attributes = parsed.value.node.attributes;

    try std.testing.expectEqual(@as(usize, 2), attributes.len);
    try std.testing.expectEqual(case.kind, attributes[0].kind);
    try std.testing.expectEqualStrings(case.value, attributes[0].value);
    try std.testing.expectEqualStrings(case.raw, attributes[0].raw_value.?);
    try std.testing.expectEqualStrings("tail", attributes[1].value);
    try std.testing.expectEqual(case.offset, attributes[0].value_location.offset);
    try std.testing.expectEqual(attributes[0].value_location, rx.attributeLocation(attributes[0], 0).?);

    const finish = rx.attributeEndLocation(attributes[0], case.value.len).?;

    try std.testing.expectEqual(case.offset + case.raw.len, finish.offset);
}
