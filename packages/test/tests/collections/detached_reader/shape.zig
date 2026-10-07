const std = @import("std");
const ir = @import("compiler").ir;

pub fn check(source: []const u8, program: ir.Program) !void {
    if (std.mem.indexOf(u8, source, "pub fn execute(") == null) return error.MissingExecute;
    if (std.mem.count(u8, source, "for (") < 2) return error.MissingReduce;

    var found = false;
    var buffer: [48]u8 = undefined;

    for (0..program.functions.count(), 0..) |function_row, index| {
        const function = program.functions.at(function_row);

        if (function.external != null or !std.mem.endsWith(u8, function.file_name, "read.zx")) continue;

        found = true;

        const ordinary = try std.fmt.bufPrint(&buffer, "function_{d}(", .{index});
        const ordinary_calls = std.mem.count(u8, source, ordinary);
        const value = try std.fmt.bufPrint(&buffer, "function_{d}_value(", .{index});
        const value_calls = std.mem.count(u8, source, value);

        if (ordinary_calls < 2 and value_calls < 3) return error.MissingReaderCall;
    }

    if (!found) return error.MissingReader;
}
