const std = @import("std");
pub const Scenario = struct { functions: usize, aliases: usize, invalid: bool = false, reverse: bool = false };
pub const Source = struct { main: []const u8, declaration: []const u8, alias: []const u8 };

pub fn create(allocator: std.mem.Allocator, scenario: Scenario) !Source {
    var declarations: std.Io.Writer.Allocating = .init(allocator);
    var main: std.Io.Writer.Allocating = .init(allocator);

    try declarations.writer.writeAll("export type Leaf = { value: u64 }\nexport type Packet = { right: Leaf[], left: Leaf? }\n");

    for (0..scenario.aliases) |index| {
        const target = if (index == 0) "Packet" else try std.fmt.allocPrint(allocator, "Alias{d}", .{index - 1});

        try declarations.writer.print("export type Alias{d} = {s}\n", .{ index, target });
    }

    const alias = if (scenario.aliases == 0) "Packet" else try std.fmt.allocPrint(allocator, "Alias{d}", .{scenario.aliases - 1});

    for (0..scenario.functions) |position| {
        const index = if (scenario.reverse) scenario.functions - position - 1 else position;

        const parameters = switch (index % 4) {
            0 => "",
            1 => "value: u64",
            2 => try std.fmt.allocPrint(allocator, "packet: {s}", .{alias}),
            else => try std.fmt.allocPrint(allocator, "value: u64, packet: {s}", .{alias}),
        };

        try declarations.writer.print("export declare function read{d}({s}): u64\n", .{ index, parameters });
    }

    if (scenario.invalid) try declarations.writer.writeAll("export declare function broken(value: u64): Missing\n");
    try main.writer.print("import host from \"zig:host\"\nimport type {{ {s} }} from \"zig:host\"\n\nexport type Input = {s}\n\nexport type Output = u64\n\nexport default function (in: Input): Output {{\n", .{ alias, alias });

    for (0..scenario.functions) |index| {
        const arguments = switch (index % 4) {
            0 => "",
            1 => "1",
            2 => "in",
            else => "1, in",
        };

        try main.writer.print("    const value{d} = host.read{d}({s})\n", .{ index, index, arguments });
    }

    try main.writer.writeAll("    return ");

    for (0..scenario.functions) |index| {
        if (index != 0) try main.writer.writeAll(" + ");
        try main.writer.print("value{d}", .{index});
    }

    try main.writer.writeAll("\n}\n");

    return .{ .main = try main.toOwnedSlice(), .declaration = try declarations.toOwnedSlice(), .alias = alias };
}
