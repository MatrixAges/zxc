const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn view(self: *Context, id: ir.TypeId, owner: node.ExpressionId, items: node.ExpressionId, owned: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("buffer_seed.zig").view(self, id, owner, items, owned);

    return @import("buffer_emission.zig").view(self, id, owner, items, owned);
}

pub fn prepare(self: *Context, body: *std.ArrayList(node.Statement), source: node.ExpressionId) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("buffer_seed.zig").prepare(self, body, source);

    return @import("buffer_emission.zig").prepare(self, body, source);
}
