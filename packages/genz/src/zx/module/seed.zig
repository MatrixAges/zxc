const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn standard(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    try output.append(self.allocator, .{ .constant = .{ .name = "std", .value = try self.builtin(.import, &.{try self.builder.string("std")}) } });
}

pub fn exports(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    for (self.program.exports) |item| try output.append(self.allocator, .{ .constant = .{ .name = item.name, .value = try self.typeExpr(item.type_id), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_io", .value = try self.builder.expression(.{ .boolean = self.entry_flags.io }), .exported = true } });
    try output.append(self.allocator, .{ .constant = .{ .name = "requires_process", .value = try self.builder.expression(.{ .boolean = self.entry_flags.process }), .exported = true } });
}

pub fn contracts(self: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    for ([_][]const u8{ "Input", "Output" }, [_]ir.TypeId{ self.program.input_type, self.program.output_type }) |name, type_id| {
        var exported = false;

        for (self.program.exports) |item| {
            if (std.mem.eql(u8, item.name, name)) exported = true;
        }

        if (!exported) try output.append(self.allocator, .{ .constant = .{ .name = name, .value = try self.typeExpr(type_id), .exported = true } });
    }
}
