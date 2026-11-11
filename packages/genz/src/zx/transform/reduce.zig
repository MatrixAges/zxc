const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const elements = @import("../state_value/elements.zig");
const ownership = @import("../state_value/ownership.zig");
const generated = @import("genz_options").generated_analysis;

pub const Request = struct {
    operation: ir.ExprId,
    transform: ir.Transform,
    source: node.ExpressionId,
    layout: node.ExpressionId,
    callback: node.ExpressionId,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), args: Request) Lower.Error!node.ExpressionId {
    const accumulator = self.names[@backingInt(args.transform.parameters[0])];
    const element = args.transform.parameters[1];
    const type_id = self.program.expression(args.operation).type_id;
    const source_type = self.program.expression(args.transform.target).type_id;
    const evaluated = try self.expr(args.transform.initial.?);
    const initial = if (self.state_active) try ownership.erase(self, body, type_id, evaluated) else evaluated;

    if (!generated) try body.append(self.allocator, .{ .variable = .{ .name = accumulator, .type_expr = args.layout, .value = initial } });

    var entered: std.ArrayList(node.Statement) = .empty;
    var renewal_scope = std.heap.ArenaAllocator.init(self.workspace);
    var renewal_buffer: [256]u8 = undefined;
    var renewal_memory = std.heap.BufferFirstAllocator.init(&renewal_buffer, renewal_scope.allocator());

    defer renewal_scope.deinit();

    const renewals = try @import("../iteration/renewal.zig").plan(self, renewal_memory.allocator(), .{
        .owner = args.operation,
        .type_id = type_id,
    });

    try renewals.emit(self, &entered, type_id, .{ .name = accumulator });

    if (!generated and entered.items.len != 0) try body.append(self.allocator, .{ .branch = .{
        .condition = try self.builder.expression(.{ .binary = .{ .operator = .not_equal, .left = try self.field(args.source, "len"), .right = try self.builder.integer(0) } }),
        .yes = try self.builder.statements(entered.items),
        .no = .{},
    } });

    var loop: std.ArrayList(node.Statement) = .empty;
    const callback = if (self.state_active) try ownership.erase(self, &loop, type_id, args.callback) else args.callback;

    if (!generated) {
        try loop.append(self.allocator, .{ .assignment = .{ .target = try self.builder.identifier(accumulator), .value = callback } });

        const result = try self.builder.identifier(accumulator);
        const capture = try elements.captureName(self, &loop, source_type, element);

        try body.append(self.allocator, .{ .for_loop = .{ .iterable = args.source, .capture = capture, .body = try self.builder.statements(loop.items) } });

        return @import("../aggregate.zig").finish(self, body, result);
    }

    const before_assignment = loop.items.len;
    const capture = try elements.captureName(self, &loop, source_type, element);
    const label = try self.fresh("block");
    const entry = @import("generated_reduce_emit");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .source = @backingInt(args.source),
        .initial = @backingInt(initial),
        .callback = @backingInt(callback),
        .layout = @backingInt(args.layout),
        .accumulator = accumulator,
        .capture = capture,
        .label = label,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .entered_count = entered.items.len,
        .element_count = loop.items.len,
        .outer_count = body.items.len,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const outer = view.join(output.outer.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, output.expressions);

    _ = try self.builder.statements(entered.items);
    _ = try self.builder.statements(loop.items[0..before_assignment]);

    try append(self, &self.builder.nodes.statements, output.update);

    _ = try self.builder.statements(loop.items[before_assignment..]);
    _ = try self.builder.statements(body.items);

    try append(self, &self.builder.nodes.statements, &outer);

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
