const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub const Result = struct { declaration: node.Declaration, io: bool, process: bool };

pub fn build(self: *Lower, value: ir.Transform, child: node.ExpressionId, errors: ?[]const []const u8) Lower.Error!Result {
    var worker = self.*;
    worker.names = try self.allocator.dupe([]const u8, self.names);
    worker.used = try self.allocator.alloc(bool, self.used.len);
    worker.cache_reads = try self.allocator.alloc(usize, self.cache_reads.len);
    worker.cache = .empty;
    worker.stack_symbols = .empty;
    worker.reference_storage = .empty;
    worker.state_symbols = .empty;
    worker.iteration_value = null;
    worker.capture = null;
    worker.uses_allocator = false;
    worker.uses_io = false;
    worker.uses_process = false;

    @memset(worker.used, false);
    @memset(worker.cache_reads, 0);

    const names = [_][]const u8{ "left", "right", "environment" };

    for (value.parameters, names) |symbol, name| {
        worker.names[@backingInt(symbol)] = name;

        if (worker.state_active and worker.state_plan.represented(worker.program, worker.program.symbols.at(@backingInt(symbol)).type_id)) try worker.state_symbols.put(self.allocator, symbol, {});
    }

    const result = try worker.expr(value.body);
    var locals: std.ArrayList(node.Statement) = .empty;
    const raw_names = [_][]const u8{ "left_element", "right_element" };

    for (value.parameters[0..2], names[0..2], raw_names) |symbol, name, raw_name| {
        const raw = try self.builder.identifier(raw_name);

        if (worker.used[@backingInt(symbol)]) {
            const element = try @import("../state_value/elements.zig").read(&worker, &locals, self.program.expression(value.target).type_id, raw);

            try locals.append(self.allocator, .{ .constant = .{ .name = name, .value = element } });
        } else try locals.append(self.allocator, .{ .discard = raw });
    }

    var body: std.ArrayList(node.Statement) = .empty;
    const context = try self.builder.identifier("context");

    for ([_][]const u8{ "allocator", "io", "process", "environment" }, [_]bool{ worker.uses_allocator, worker.uses_io, worker.uses_process, worker.used[@backingInt(value.parameters[2])] }) |name, used| {
        if (used) try body.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.field(context, name) } });
    }

    if (!worker.uses_allocator and !worker.uses_io and !worker.uses_process and !worker.used[@backingInt(value.parameters[2])]) try body.append(self.allocator, .{ .discard = context });
    try body.appendSlice(self.allocator, worker.reference_storage.items);
    try body.appendSlice(self.allocator, locals.items);
    try body.append(self.allocator, .{ .result = result });

    return .{
        .declaration = .{ .function = .{
            .name = "compare",
            .parameters = try self.allocator.dupe(node.Field, &.{ .{ .name = "context", .value = try self.builder.expression(.{ .primitive = .@"anytype" }) }, .{ .name = "left_element", .value = child }, .{ .name = "right_element", .value = child } }),
            .return_type = try self.builder.expression(.{ .error_union = .{ .payload = try self.typeExpr(self.program.expression(value.body).type_id), .errors = errors } }),
            .body = try self.builder.statements(body.items),
        } },
        .io = worker.uses_io,
        .process = worker.uses_process,
    };
}
