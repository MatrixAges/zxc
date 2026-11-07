const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn reserve(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, count: node.ExpressionId, frontier: bool) Lower.Error!node.ExpressionId {
    const arguments = [_]node.ExpressionId{ element, try self.builder.identifier("allocator"), source, count, try self.builder.expression(.{ .boolean = frontier }) };

    return aggregate.bind(self, body, try self.call(try reference(self, "zxReserve"), &arguments, true));
}

pub fn reserveBounded(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, count: node.ExpressionId, minimum: node.ExpressionId) Lower.Error!node.ExpressionId {
    return aggregate.bind(self, body, try self.call(try reference(self, "zxReserveBounded"), &.{ element, try self.builder.identifier("allocator"), source, count, minimum }, true));
}

pub fn copy(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, exact: bool) Lower.Error!node.ExpressionId {
    return aggregate.bind(self, body, try self.call(try reference(self, "zxAllocate"), &.{ element, try self.builder.identifier("allocator"), source, try self.field(source, "len"), try self.builder.expression(.{ .boolean = exact }), try self.builder.integer(0) }, true));
}

pub fn retract(self: *Lower, body: *std.ArrayList(node.Statement), element: node.ExpressionId, source: node.ExpressionId, length: node.ExpressionId) Lower.Error!void {
    try body.append(self.allocator, .{ .expression = try self.call(try reference(self, "zxRetract"), &.{ element, source, length }, false) });
}

fn reference(self: *Lower, name: []const u8) Lower.Error!node.ExpressionId {
    if (self.shared_types) return self.field(try self.builder.identifier("zx_abi"), name);

    return self.builder.identifier(name);
}
