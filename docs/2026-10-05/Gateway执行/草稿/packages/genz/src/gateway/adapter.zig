const std = @import("std");
const Service = @import("root.zig").Service;

pub fn write(writer: *std.Io.Writer, service: Service, index: usize) std.Io.Writer.Error!void {
    if (service.slots.len == 0) return;
    try writer.print("const Context_{d} = struct {{\n    request: *State.Request,\n", .{index});
    for (service.slots, 0..) |slot, local| try writer.print("    store_{d}: @FieldType(State.Request, \"store_{d}\"),\n", .{ local, slot.index });
    try writer.writeAll("\n    fn init(request: *State.Request) @This() {\n        return .{ .request = request,\n");
    for (service.slots, 0..) |slot, local| try writer.print("            .store_{d} = request.store_{d},\n", .{ local, slot.index });
    try writer.writeAll("        };\n    }\n");
    try writer.print("\n    pub fn commit(self: *@This(), changes: service_{d}.zx_pending) !void {{\n", .{index});

    for (service.slots, 0..) |slot, local| {
        if (!slot.writable) try writer.print("        if (changes.store_{d} != null) return error.StoreNotWritable;\n", .{local});
    }

    try writer.writeAll("        try self.request.commit(.{\n");
    for (service.slots, 0..) |slot, local| try writer.print("            .store_{d} = changes.store_{d},\n", .{ slot.index, local });
    try writer.writeAll("        });\n    }\n};\n\n");
}
