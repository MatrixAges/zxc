const std = @import("std");
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Flags = @import("build.zig").Flags;

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), flags: Flags) Lower.Error!void {
    try body.append(self.allocator, .{ .expression = try self.builtin(.setRuntimeSafety, &.{try self.builder.expression(.{ .boolean = true })}) });

    if (flags.exported and self.uses_allocator) {
        if (self.entry_flags.tasks) {
            self.uses_io = true;

            try @import("../../tasks/allocator.zig").initialize(self, body);
        } else try body.append(self.allocator, .{ .constant = .{ .name = "allocator", .value = try self.call(try self.field(try self.builder.identifier("arena"), "allocator"), &.{}, false) } });
    } else if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = try self.builder.identifier(if (flags.exported) "arena" else "allocator") });

    if (self.program.stores.count() > 0 and !self.transaction() and !self.uses_context) try body.append(self.allocator, .{ .discard = try self.builder.identifier("context") });
    if (flags.io and !self.uses_io) try body.append(self.allocator, .{ .discard = try self.builder.identifier("io") });
    if (flags.process and !self.uses_process) try body.append(self.allocator, .{ .discard = try self.builder.identifier("process") });
    if (!self.used[0]) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });
}
