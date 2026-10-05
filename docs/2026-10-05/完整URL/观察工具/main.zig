const std = @import("std");
const ipv4 = @import("ipv4");
const ipv6 = @import("ipv6");
const percent = @import("percent");
const model = @import("model");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedOperationAndInput;

    const output = if (std.mem.eql(u8, args[1], "ipv4"))
        try ipv4.serialize(allocator, try ipv4.parse(args[2]))

    else if (std.mem.eql(u8, args[1], "ipv6"))
        try ipv6.serialize(allocator, try ipv6.parse(args[2]))
    else if (std.mem.eql(u8, args[1], "numeric"))
        if (ipv4.endsInNumber(args[2])) "true" else "false"
    else if (std.mem.eql(u8, args[1], "decode"))
        try percent.decode(allocator, args[2])
    else if (std.mem.eql(u8, args[1], "scheme"))
        try std.fmt.allocPrint(allocator, "{any}:{any}", .{ model.special(args[2]), model.defaultPort(args[2]) })
    else
        try percent.encode(allocator, args[2], std.meta.stringToEnum(percent.Set, args[1]) orelse return error.InvalidOperation);
    try std.Io.File.stdout().writeStreamingAll(init.io, output);
}
