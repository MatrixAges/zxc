const std = @import("std");
const ir = @import("zx").ir;
const Analyzer = @import("../analyzer.zig");

pub fn find(analyzer: *const Analyzer, name: []const u8) ?ir.Constant {
    if (analyzer.constants.len == 0) return null;

    for (analyzer.active.items) |id| {
        if (std.mem.eql(u8, analyzer.symbols.at(@backingInt(id)).name, name)) return null;
    }

    for (analyzer.constants) |constant| {
        if (std.mem.eql(u8, constant.name, name)) return constant;
    }

    return null;
}
