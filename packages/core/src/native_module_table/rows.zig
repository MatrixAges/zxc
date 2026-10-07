const Table = @import("root.zig");
const Bindings = @import("bindings.zig");

table: Table,
pub fn jsonStringify(self: @This(), writer: anytype) !void {
    try writer.beginArray();

    for (0..self.table.count()) |index| {
        const value = self.table.at(index);

        try writer.write(.{
            .specifier = value.specifier,
            .import_name = value.import_name,
            .identity = value.identity,
            .type_namespace = value.type_namespace,
            .types = BindingRows{ .bindings = value.types },
        });
    }

    try writer.endArray();
}

const BindingRows = struct {
    bindings: Bindings,
    pub fn jsonStringify(self: BindingRows, writer: anytype) !void {
        try writer.beginArray();
        for (0..self.bindings.count()) |index| try writer.write(self.bindings.at(index));
        try writer.endArray();
    }
};
