const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn build(self: *Lower, id: ir.FunctionId) Lower.Error!?node.Declaration {
    const index = @backingInt(id);

    if (!self.value_functions[index]) return null;
    if (self.entry_flags.tasks or self.entry_flags.io or self.entry_flags.process) return null;
    if (self.program.stores.count() != 0 or self.program.contracts.count() != 0) return null;
    if (!self.state_plan.represented(self.program, self.program.output_type) and !self.state_plan.represented(self.program, self.program.input_type) and !self.state_plan.inlineRows(self.program, self.program.input_type)) return null;

    const errors = try @import("../error_effects.zig").program(self);

    const allocating = if (errors) |names| for (names) |name| {
        if (std.mem.eql(u8, name, "OutOfMemory")) break true;
    } else false else false;

    if (!allocating) return null;

    const argument: ir.ExprId = for (0..self.program.expressions.count()) |row| {
        const expression = self.program.expressions.at(@intCast(row));

        if (expression.value == .reference and @backingInt(expression.value.reference) == 0) break @fromBackingInt(@as(u32, @intCast(row)));
    } else return null;

    const saved_cache = self.cache;
    const saved_plan = self.plan;

    self.cache = .empty;
    self.plan = .{ .flags = &.{} };

    defer {
        self.cache = saved_cache;
        self.plan = saved_plan;
    }

    self.reference_storage = .empty;
    self.uses_allocator = false;
    self.uses_context = false;
    self.uses_io = false;
    self.uses_process = false;
    self.allows_allocation = true;

    @memset(self.used, false);
    @memset(self.cache_reads, 0);

    self.used[0] = true;

    try self.cache.put(self.allocator, argument, try self.builder.identifier("in"));

    const result = try @import("../value_call/root.zig").pointerInvocation(self, .{
        .function = id,
        .argument = argument,
        .stores = &.{},
    });

    var body: std.ArrayList(node.Statement) = .empty;

    try @import("prelude/build.zig").append(self, &body, .{ .exported = false, .io = false, .process = false });
    try body.appendSlice(self.allocator, self.reference_storage.items);
    try body.append(self.allocator, .{ .result = result });

    var function = try self.prototype("call", false);
    function.body = try self.builder.statements(body.items);

    return .{ .function = function };
}
