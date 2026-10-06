const std = @import("std");
const rx = @import("rx");

pub const location: rx.ast.Location = .{ .offset = 40, .line = 3, .column = 5 };
pub const value_location: rx.ast.Location = .{ .offset = 60, .line = 3, .column = 25 };

pub fn node(comptime name: []const u8, comptime attributes: anytype, children: []const rx.ast.Node) rx.ast.Node {
    const values = comptime blk: {
        const fields = @typeInfo(@TypeOf(attributes)).@"struct".field_names;
        var result: [fields.len]rx.ast.Attribute = undefined;

        for (fields, 0..) |field, index| {
            result[index] = .{
                .kind = if (expressionAttribute(name, field)) .expression else .string,
                .name = field,
                .value = @field(attributes, field),
                .location = location,
                .value_location = value_location,
            };
        }

        break :blk result;
    };

    return .{ .name = name, .location = location, .attributes = &values, .children = children };
}

fn expressionAttribute(comptime name: []const u8, comptime field: []const u8) bool {
    if (std.mem.eql(u8, name, "Call")) return std.mem.eql(u8, field, "in") or std.mem.eql(u8, field, "setter");
    if (std.mem.eql(u8, name, "Switch")) return std.mem.eql(u8, field, "on");
    if (std.mem.eql(u8, name, "Store")) return std.mem.eql(u8, field, "version");
    if (std.mem.eql(u8, name, "Gateway")) return std.mem.eql(u8, field, "max_header_bytes") or std.mem.eql(u8, field, "max_body_bytes");

    inline for (.{ "Return", "Case", "Emit", "Field" }) |tag| {
        if (std.mem.eql(u8, name, tag)) return std.mem.eql(u8, field, "value");
    }

    return false;
}

pub fn module(children: []const rx.ast.Node) rx.ast.Node {
    return node("Module", .{ .in = "Input", .out = "Output" }, children);
}

pub fn call() rx.ast.Node {
    return node("Call", .{ .@"fn" = "create_order", .in = "$in" }, &.{});
}

pub fn expectValid(file: []const u8, root: rx.ast.Node) !void {
    var result = try rx.validate(std.testing.allocator, file, root);

    defer result.deinit();

    switch (result.value) {
        .data => {},
        .diagnostic => |issue| {
            std.debug.print("Unexpected RX diagnostic: {s} <{s}> {s}\n", .{ @tagName(issue.code), issue.element, issue.message });

            return error.UnexpectedDiagnostic;
        },
    }
}

pub fn expectError(file: []const u8, root: rx.ast.Node, code: @FieldType(rx.Diagnostic, "code")) !rx.Diagnostic {
    var result = try rx.validate(std.testing.allocator, file, root);

    defer result.deinit();

    switch (result.value) {
        .data => return error.ExpectedDiagnostic,
        .diagnostic => |issue| {
            try std.testing.expectEqual(code, issue.code);

            return issue;
        },
    }
}
