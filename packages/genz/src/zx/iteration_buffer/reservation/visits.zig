const std = @import("std");
const ir = @import("zx").ir;
const Children = @import("../../inline_call/children.zig");
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
update: ir.ExprId,
cached: []bool,
pub fn once(allocator: std.mem.Allocator, program: ir.Program, body: ir.ExprId, update: ir.ExprId) std.mem.Allocator.Error!bool {
    const cached = try allocator.alloc(bool, program.expressions.count());

    defer allocator.free(cached);

    @memset(cached, false);

    var self = Self{ .allocator = allocator, .program = program, .update = update, .cached = cached };

    return try self.count(body) == 1;
}

fn count(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!u8 {
    if (self.cached[@backingInt(id)]) return 0;

    const value = self.program.expression(id).value;
    const own: u8 = @intFromBool(id == self.update);

    if (value == .conditional) {
        const branch = value.conditional;

        return @min(2, own + try self.count(branch.condition) + @max(try self.count(branch.yes), try self.count(branch.no)));
    }

    if (value == .object) {
        const previous = try self.allocator.dupe(bool, self.cached);

        defer self.allocator.free(previous);
        defer @memcpy(self.cached, previous);

        var total = own;

        for (value.object.evaluation) |child| {
            total = @min(2, total + try self.count(child));

            self.cached[@backingInt(child)] = true;
        }

        for (0..value.object.fields.len) |index| total = @min(2, total + try self.count(value.object.fields.at(index).value));

        return total;
    }

    const children = Children.init(value);
    var total = own;

    for (0..children.len) |index| total = @min(2, total + try self.count(children.at(index)));

    return switch (value) {
        .iteration, .transform, .task, .parallel => if (total == 0) 0 else 2,
        else => total,
    };
}
