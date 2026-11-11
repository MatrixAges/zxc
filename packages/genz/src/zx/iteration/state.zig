const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const statements = @import("../../node/import_statements.zig");

pub const Declaration = struct {
    name: []const u8,
    layout: node.ExpressionId,
    initial: node.ExpressionId,
    mutable: bool = true,
    tracking: ?[]const u8 = null,
};

pub const Tracker = union(enum) {
    seed: []const u8,
    generated: @FieldType(node.Statement, "assignment"),
    pub fn mark(self: Tracker, lowering: *Lower, body: *std.ArrayList(node.Statement)) Lower.Error!void {
        const assignment: @FieldType(node.Statement, "assignment") = switch (self) {
            .seed => |name| .{
                .target = try lowering.builder.identifier(name),
                .value = try lowering.builder.expression(.{ .boolean = true }),
            },
            .generated => |assignment| assignment,
        };

        try body.append(lowering.allocator, .{ .assignment = assignment });
    }
};

pub fn declare(self: *Lower, body: *std.ArrayList(node.Statement), args: Declaration) Lower.Error!?Tracker {
    if (!@import("genz_options").generated_analysis) return seed(self, body, args);

    const entry = @import("generated_iteration_state_declaration");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Binding = std.meta.Child(@FieldType(Input, "declaration"));

    const binding: Binding = .{
        .name = args.name,
        .layout = @backingInt(args.layout),
        .initial = @backingInt(args.initial),
        .mutable = args.mutable,
    };

    const input: Input = .{
        .declaration = &binding,
        .tracking = args.tracking,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);
    const declaration = zx.columns.view(std.meta.Child(@FieldType(Output, "declaration")), output.declaration);

    statements.appendBorrowingText(self.allocator, body, &declaration) catch |err| return failure(err);

    const tracker = output.tracker orelse return null;
    const State = std.meta.Child(@typeInfo(@FieldType(Output, "tracker")).optional.child);
    const expressions = zx.columns.view(std.meta.Child(@FieldType(State, "expressions")), tracker.expressions);
    const flag = zx.columns.view(std.meta.Child(@FieldType(State, "declaration")), tracker.declaration);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);

    statements.appendBorrowingText(self.allocator, body, &flag) catch |err| return failure(err);

    return .{ .generated = .{
        .target = @fromBackingInt(tracker.target),
        .value = @fromBackingInt(tracker.value),
    } };
}

fn seed(self: *Lower, body: *std.ArrayList(node.Statement), args: Declaration) Lower.Error!?Tracker {
    const declaration: node.Constant = .{ .name = args.name, .type_expr = args.layout, .value = args.initial };

    try body.append(self.allocator, if (args.mutable) .{ .variable = declaration } else .{ .constant = declaration });

    const name = args.tracking orelse return null;

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .value = try self.builder.expression(.{ .boolean = false }),
    } });

    return .{ .seed = name };
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
