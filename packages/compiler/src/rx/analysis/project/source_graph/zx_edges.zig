const zx = @import("zx");
const Collector = @import("collect.zig");

pub fn collect(collector: *Collector, header: anytype, source: []const u8) Collector.Error!void {
    for (0..header.importCount()) |index| {
        const item = header.importAt(index);
        const location = zx.source.locate(source, item.span.start);

        try collector.import(item.path, .{
            .offset = item.span.start,
            .line = location.line,
            .column = location.column,
        });
    }
}
