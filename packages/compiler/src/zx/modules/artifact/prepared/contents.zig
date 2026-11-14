const ir = @import("zx").ir;
const Nodes = @import("../nodes.zig");
const Record = @import("../../module_record.zig");
const Error = @import("../model.zig").Error;

pub fn dependencies(nodes: *Nodes, source: []const Record.Import) Error![]const Record.Import {
    const result = try nodes.allocator.dupe(Record.Import, source);

    for (result) |*value| {
        value.specifier = try nodes.allocator.dupe(u8, value.specifier);
        value.identity = if (value.identity) |key| try nodes.allocator.dupe(u8, key) else null;
        value.names = try nodes.strings(value.names);
        value.source_names = try nodes.strings(value.source_names);

        value.target = switch (value.target) {
            .compiled => unreachable,
            .source => |path| .{ .source = try nodes.allocator.dupe(u8, path) },
            .native, .external, .intrinsic => value.target,
        };
    }

    return result;
}
