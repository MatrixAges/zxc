const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), transform: ir.Transform) Lower.Error!void {
    if (transform.kind == .reduce) return;

    const initial = transform.initial orelse return;
    const value = try self.expr(initial);
    const symbol = @backingInt(transform.parameters[1]);

    if (self.used[symbol]) {
        try body.append(self.allocator, .{ .constant = .{
            .name = self.names[symbol],
            .type_expr = self.types[@backingInt(self.program.symbols.at(symbol).type_id)],
            .value = value,
        } });
    } else {
        try body.append(self.allocator, .{ .discard = value });
    }
}
