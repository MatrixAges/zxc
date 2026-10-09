const std = @import("std");
const compiler = @import("compiler");

pub const Case = struct { depth: usize, width: usize };

pub fn create(memory: std.mem.Allocator, args: Case) ![]const compiler.project.Source {
    var files: std.ArrayList(compiler.project.Source) = .empty;

    try files.append(memory, .{ .path = "leaf.zx", .source = "export enum Noise { Unused }\n\nexport enum Mode { First, Second, Third }\n\nexport type Leaf = { mode: Mode, value: u64 }\n" });

    for (0..args.depth) |index| {
        const previous = if (index == 0) "Leaf" else try std.fmt.allocPrint(memory, "Node{d}", .{index - 1});
        const path = if (index == 0) "../leaf" else try std.fmt.allocPrint(memory, "./n_{d}", .{index - 1});

        const value = switch (index % 4) {
            0 => try std.fmt.allocPrint(memory, "{s}?", .{previous}),
            1 => try std.fmt.allocPrint(memory, "{s}[]", .{previous}),
            2 => try std.fmt.allocPrint(memory, "[{s}, {s}, u64]", .{ previous, previous }),
            else => try std.fmt.allocPrint(memory, "{{ left: {s}, mode: Mode, right: {s} }}", .{ previous, previous }),
        };

        try files.append(memory, .{
            .path = try std.fmt.allocPrint(memory, "nodes/n_{d}.zx", .{index}),
            .source = try std.fmt.allocPrint(memory, "import type {{ Mode }} from \"../leaf\"\nimport type {{ {s} }} from \"{s}\"\n\nexport type Node{d} = {s}\n", .{ previous, path, index, value }),
        });
    }

    const endpoint = if (args.depth == 0) "Leaf" else try std.fmt.allocPrint(memory, "Node{d}", .{args.depth - 1});
    const path = if (args.depth == 0) "./leaf" else try std.fmt.allocPrint(memory, "./nodes/n_{d}", .{args.depth - 1});
    var text: std.Io.Writer.Allocating = .init(memory);

    try text.writer.print("import type {{ Mode }} from \"./leaf\"\nimport type {{ {s} }} from \"{s}\"\n\nexport type ScalarZero = void\n\nexport type Root = {{\n", .{ endpoint, path });
    for (0..args.width) |index| try text.writer.print("    f{d:0>3}: {s}\n", .{ index, endpoint });
    try text.writer.writeAll("}\n");
    try files.append(memory, .{ .path = "main.zx", .source = try text.toOwnedSlice() });

    for (files.items) |file| {
        var count: usize = 0;

        for (file.source) |byte| if (byte == '\n') {
            count += 1;
        };

        try std.testing.expect(count <= 120);
    }

    return files.toOwnedSlice(memory);
}
