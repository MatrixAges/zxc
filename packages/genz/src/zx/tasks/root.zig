const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const emit = @import("emitting.zig");
const generated = @import("genz_options").generated_analysis;

pub fn start(self: *Lower, id: ir.ExprId, concurrent: bool) Lower.Error!node.ExpressionId {
    if (!generated) return @import("root_seed.zig").start(self, id, concurrent);

    const captures = self.program.expression(id).value.task.captures;
    const process = self.entry_flags.body_process;

    self.uses_allocator = true;
    self.uses_io = true;

    if (process) self.uses_process = true;

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const names = try scratch.allocator().alloc([]const u8, captures.len);
    const addresses = try scratch.allocator().alloc(bool, captures.len);

    for (captures, names, addresses) |symbol, *name, *address| {
        self.used[@backingInt(symbol)] = true;

        name.* = self.names[@backingInt(symbol)];
        address.* = self.stack_symbols.contains(symbol);
    }

    const worker = try @import("worker.zig").lower(self, id, process);

    return emit.start(self, worker, process, concurrent, names, addresses);
}

pub fn bind(self: *Lower, output: *std.ArrayList(node.Statement), name: []const u8, id: ir.ExprId, concurrent: bool) Lower.Error!void {
    if (!generated) return @import("root_seed.zig").bind(self, output, name, id, concurrent);

    return emit.bind(self, output, name, try start(self, id, concurrent));
}

pub fn wait(self: *Lower, child: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!generated) return @import("root_seed.zig").wait(self, child);

    self.uses_io = true;

    if (self.program.expression(child).value != .task) return emit.call(self, try self.expr(child), null, .Await, true);

    const name = try emit.fresh(self, .Future);
    var body: std.ArrayList(node.Statement) = .empty;

    try bind(self, &body, name, child, false);

    const value = try emit.call(self, null, name, .Await, true);

    return @import("../aggregate.zig").finish(self, &body, value);
}

pub fn parallel(self: *Lower, type_id: ir.TypeId, branches: @FieldType(@FieldType(ir.ExpressionRow, "value"), "parallel")) Lower.Error!node.ExpressionId {
    if (!generated) return @import("root_seed.zig").parallel(self, type_id, branches);

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const temporary = scratch.allocator();
    const futures = try temporary.alloc([]const u8, branches.len);
    const results = try temporary.alloc([]const u8, branches.len);
    const values = try temporary.alloc(?[]const u8, branches.len);
    const fields = try temporary.alloc(?[]const u8, branches.len);
    var body: std.ArrayList(node.Statement) = .empty;

    for (0..branches.len, futures) |index, *name| {
        name.* = try emit.fresh(self, .Future);

        try bind(self, &body, name.*, branches.at(index).task, true);
    }

    for (results) |*name| name.* = try emit.fresh(self, .Result);
    try @import("parallel.zig").awaitAll(self, &body, futures, results);

    for (0..branches.len, values, fields) |index, *name, *field| {
        if (branches.at(index).field) |selected| {
            name.* = try emit.fresh(self, .Value);
            field.* = self.program.typeOf(type_id).object.at(selected).name;
        } else {
            name.* = null;
            field.* = null;
        }
    }

    const object = self.program.typeOf(type_id) == .object;
    const raw = try @import("parallel.zig").result(self, &body, results, values, fields, object);
    const value = if (object) try self.construct(type_id, raw) else raw;

    return @import("../aggregate.zig").finish(self, &body, value);
}

pub fn cancel(self: *Lower, child: ir.ExprId) Lower.Error!node.ExpressionId {
    if (!generated) return @import("root_seed.zig").cancel(self, child);

    self.uses_io = true;

    var body: std.ArrayList(node.Statement) = .empty;
    var name: ?[]const u8 = null;
    var value: ?node.ExpressionId = null;

    if (self.program.expression(child).value == .task) {
        name = try emit.fresh(self, .Future);

        try bind(self, &body, name.?, child, false);
    } else value = try self.expr(child);

    const result = try emit.cancel(self, &body, value, name);

    return @import("../aggregate.zig").finish(self, &body, result);
}
