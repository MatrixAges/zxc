const std = @import("std");
pub const Alias = struct { name: []const u8, identity: []const u8 };

pub fn render(allocator: std.mem.Allocator, type_names: []const []const u8, aliases: []const Alias, imported: bool) std.mem.Allocator.Error![]u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    errdefer output.deinit();
    write(&output.writer, type_names, aliases, imported) catch return error.OutOfMemory;

    return output.toOwnedSlice();
}

fn write(writer: *std.Io.Writer, type_names: []const []const u8, aliases: []const Alias, imported: bool) std.Io.Writer.Error!void {
    if (imported) {
        try writer.writeAll("const canonical = @import(\"zxc_abi_canonical\");\n\n");
        for (type_names) |name| try writer.print("pub const {f} = canonical.{f};\n", .{ std.zig.fmtId(name), std.zig.fmtId(name) });
        try writer.writeByte('\n');
    }

    for ([_][]const u8{ "native", "layouts" }) |namespace| {
        try writer.print("pub const {s} = struct {{\n", .{namespace});
        for (aliases) |alias| try writer.print("    pub const {f} = {s}{s}_by_identity.{f};\n", .{ std.zig.fmtId(alias.name), if (imported) "canonical." else "", namespace, std.zig.fmtId(alias.identity) });
        try writer.writeAll("};\n\n");
    }
}
