const std = @import("std");
const ir = @import("compiler").ir;
const GeneratedLoop = @import("generated_loop");

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

pub fn check(allocator: std.mem.Allocator, source: []const u8, mode: []const u8, program: ir.Program) !void {
    var generated = try GeneratedLoop.parse(allocator, source);

    defer generated.deinit();

    const execute = generated.entrySource();
    const loops = std.mem.count(u8, source, "while (");
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
    if (generated.owners() != 1) return error.MissingFrameValueBuffer;
    if (generated.loop == null) return error.MissingLoop;
    if (std.mem.count(u8, execute, ").deinit(allocator)") != generated.totalOwners()) return error.InvalidBufferCleanupCount;
    if (std.mem.count(u8, generated.before(), ").ensureTotalCapacity(") != 1) return error.InvalidInitialConversionCount;
    if (std.mem.count(u8, generated.before(), "for (") != 1) return error.InvalidInitialFillCount;
    if (std.mem.indexOf(u8, generated.body(), "(allocator).create(") != null) return error.PerIterationFrameBox;
    if (std.mem.indexOf(u8, generated.body(), "(allocator).dupe(") != null) return error.PerIterationListCopy;
}
