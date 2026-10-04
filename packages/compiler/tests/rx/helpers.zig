const std = @import("std");
const rx = @import("rx");

pub const location: rx.ast.Location = .{ .offset = 40, .line = 3, .column = 5 };
pub const value_location: rx.ast.Location = .{ .offset = 60, .line = 3, .column = 25 };

pub fn node(comptime name: []const u8, comptime attributes: anytype, children: []const rx.ast.Node) rx.ast.Node {
    const values = comptime blk: {
        const fields = std.meta.fields(@TypeOf(attributes));
        var result: [fields.len]rx.ast.Attribute = undefined;

        for (fields, 0..) |field, index| {
            result[index] = .{
                .name = field.name,
                .value = @field(attributes, field.name),
                .location = location,
                .value_location = value_location,
            };
        }

        break :blk result;
    };

    return .{ .name = name, .location = location, .attributes = &values, .children = children };
}

pub fn module(children: []const rx.ast.Node) rx.ast.Node {
    return node("Module", .{ .in = "Input", .out = "Output" }, children);
}

pub fn call() rx.ast.Node {
    return node("Call", .{ .@"fn" = "create_order", .in = "$in", .out = "ctx.order" }, &.{});
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
