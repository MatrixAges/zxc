const ir = @import("zx").ir;

rows: u64,
children: u64,
fields: u64,
names: u64,
pub fn fromTable(table: ir.TypeTable) @This() {
    return .{
        .rows = table.count(),
        .children = table.children.len,
        .fields = table.field_types.len,
        .names = table.names.len,
    };
}
