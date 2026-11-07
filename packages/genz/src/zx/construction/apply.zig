const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const view = @import("../../node/view.zig");

pub fn expressions(self: *Lower, output: anytype) Lower.Error!void {
    const source = view.join(output.expressions.*, output.forms.*);

    try rows(self, &self.builder.nodes.expressions, &source);
}

pub fn storage(self: *Lower, output: anytype) Lower.Error!void {
    const source = view.join(output.storage.*, output.variables.*);

    try flat(self, &self.reference_storage, &source);
}

pub fn flat(self: *Lower, target: *std.ArrayList(node.Statement), source: anytype) Lower.Error!void {
    @import("../../node/import_statements.zig").append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}

pub fn rows(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
