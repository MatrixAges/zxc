const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
pub const required = @import("allocator.zig").required;

pub fn start(self: *Lower, id: ir.ExprId, concurrent: bool) Lower.Error!*const node.Expression {
    const task = self.program.expression(id).value.task;
    var arguments: std.ArrayList(*const node.Expression) = .empty;
    self.uses_allocator = true;
    self.uses_io = true;

    try arguments.append(self.allocator, try self.builder.identifier("allocator"));
    try arguments.append(self.allocator, try self.builder.identifier("io"));

    const process = @import("../capabilities.zig").uses(self.program.expressions, &.{}, self.process_functions);

    if (process) {
        self.uses_process = true;

        try arguments.append(self.allocator, try self.builder.identifier("process"));
    }

    for (task.captures) |symbol| {
        self.used[@backingInt(symbol)] = true;

        const value = try self.builder.identifier(self.names[@backingInt(symbol)]);

        try arguments.append(self.allocator, if (self.stack_symbols.contains(symbol)) try self.builder.expression(.{ .address_of = value }) else value);
    }

    const worker = try @import("worker.zig").lower(self, id, process);

    return self.call(try self.field(try self.builder.identifier("io"), if (concurrent) "concurrent" else "async"), &.{ try self.field(worker, "run"), try self.builder.expression(.{ .tuple = try arguments.toOwnedSlice(self.allocator) }) }, concurrent);
}

pub fn bind(self: *Lower, output: *std.ArrayList(node.Statement), name: []const u8, id: ir.ExprId, concurrent: bool) Lower.Error!void {
    try output.append(self.allocator, .{ .variable = .{ .name = name, .value = try start(self, id, concurrent) } });

    const cleanup = try self.call(try self.field(try self.builder.identifier(name), "cancel"), &.{try self.builder.identifier("io")}, false);

    try output.append(self.allocator, .{ .defer_scope = try self.allocator.dupe(node.Statement, &.{.{ .discard_error = cleanup }}) });
}

pub fn wait(self: *Lower, child: ir.ExprId) Lower.Error!*const node.Expression {
    self.uses_io = true;

    if (self.program.expression(child).value != .task) return self.call(try self.field(try self.expr(child), "await"), &.{try self.builder.identifier("io")}, true);

    const name = try self.fresh("future");
    var body: std.ArrayList(node.Statement) = .empty;

    try bind(self, &body, name, child, false);

    return @import("../aggregate.zig").finish(self, &body, try self.call(try self.field(try self.builder.identifier(name), "await"), &.{try self.builder.identifier("io")}, true));
}

pub fn parallel(self: *Lower, type_id: ir.TypeId, branches: @FieldType(@FieldType(ir.ExpressionRow, "value"), "parallel")) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const futures = try self.allocator.alloc([]const u8, branches.len);
    const results = try self.allocator.alloc([]const u8, branches.len);
    var fields: std.ArrayList(node.Field) = .empty;

    for (0..branches.len, futures) |record_index, *name| {
        const branch = branches.at(record_index);
        name.* = try self.fresh("future");

        try bind(self, &body, name.*, branch.task, true);
    }

    for (futures, results) |future, *result| {
        result.* = try self.fresh("task_result");

        try body.append(self.allocator, .{ .constant = .{ .name = result.*, .value = try self.call(try self.field(try self.builder.identifier(future), "await"), &.{try self.builder.identifier("io")}, false) } });
    }

    for (0..branches.len, results) |record_index, result| {
        const branch = branches.at(record_index);
        const raw = try self.builder.identifier(result);
        const value = if (self.capture) |boundary| try self.builder.expression(.{ .catch_value = .{ .value = raw, .capture = boundary.name, .label = boundary.label, .result = boundary.failure } }) else try self.builder.expression(.{ .try_value = raw });

        if (branch.field) |index| {
            const name = try self.fresh("task_value");

            try body.append(self.allocator, .{ .constant = .{ .name = name, .value = value } });
            try fields.append(self.allocator, .{ .name = self.program.typeOf(type_id).object.at(index).name, .value = try self.builder.identifier(name) });
        } else try body.append(self.allocator, .{ .expression = value });
    }

    const result = if (self.program.typeOf(type_id) == .object) try self.construct(type_id, try self.builder.expression(.{ .object = .{ .fields = try fields.toOwnedSlice(self.allocator) } })) else try self.builder.expression(.unit);

    return @import("../aggregate.zig").finish(self, &body, result);
}

pub fn cancel(self: *Lower, child: ir.ExprId) Lower.Error!*const node.Expression {
    self.uses_io = true;

    var body: std.ArrayList(node.Statement) = .empty;

    const future = if (self.program.expression(child).value == .task) blk: {
        const name = try self.fresh("future");

        try bind(self, &body, name, child, false);

        break :blk try self.builder.identifier(name);
    } else try self.expr(child);

    try body.append(self.allocator, .{ .discard_error = try self.call(try self.field(future, "cancel"), &.{try self.builder.identifier("io")}, false) });

    return @import("../aggregate.zig").finish(self, &body, try self.builder.expression(.unit));
}
