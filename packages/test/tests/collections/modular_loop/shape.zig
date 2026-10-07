const std = @import("std");
const ir = @import("compiler").ir;

fn helperCount(source: []const u8, program: ir.Program) !usize {
    var count: usize = 0;
    var buffer: [32]u8 = undefined;

    for (0..program.functions.count(), 0..) |function_row, index| {
        const function = program.functions.at(function_row);

        if (function.external != null) continue;

        const name = try std.fmt.bufPrint(&buffer, "function_{d}", .{index});
        var position: usize = 0;

        while (std.mem.indexOfPos(u8, source, position, name)) |found| {
            const end = found + name.len;

            if (end == source.len or !std.ascii.isDigit(source[end])) {
                count += 1;

                break;
            }

            position = end;
        }
    }

    return count;
}

pub fn check(source: []const u8, mode: []const u8, program: ir.Program) !void {
    const start = std.mem.indexOf(u8, source, "pub fn execute(") orelse return error.MissingExecute;
    const execute = source[start..];
    const loops = std.mem.count(u8, execute, "while (");
    const helpers = try helperCount(execute, program);
    const escaping = std.mem.eql(u8, mode, "escaping");
    const nested = std.mem.eql(u8, mode, "nested");

    if (loops == 0) return error.MissingLoop;

    if (escaping) {
        if (helpers == 0) return error.MissingEscapingHelper;

        return;
    }

    if (!nested and helpers != 0) return error.RemainingAggregateHelper;
    if (!std.mem.eql(u8, mode, "simple")) return;
    if (std.mem.count(u8, execute, ".ArrayList(state_type_") != 1) return error.MissingFrameValueBuffer;

    const loop = std.mem.indexOf(u8, execute, "while (").?;
    const open = std.mem.indexOfScalarPos(u8, execute, loop, '{') orelse return error.MissingLoopBody;
    var depth: usize = 1;
    var end = open + 1;

    while (end < execute.len and depth > 0) : (end += 1) {
        if (execute[end] == '{') depth += 1;
        if (execute[end] == '}') depth -= 1;
    }

    if (depth != 0) return error.UnclosedLoopBody;
    if (std.mem.indexOf(u8, execute[open + 1 .. end - 1], "(allocator).create(") != null) return error.PerIterationFrameBox;
}
