const zx = @import("zx");

pub fn get(header: anytype, index: usize) View(@TypeOf(header)) {
    const item = header.importAt(index);

    return .{ .header = header, .index = index, .kind = item.kind, .path = item.path, .span = item.span };
}

fn View(comptime Header: type) type {
    return struct {
        const Self = @This();

        header: Header,
        index: usize,
        kind: @FieldType(zx.ast.Import, "kind"),
        path: []const u8,
        span: zx.Span,
        pub fn nameCount(self: Self) usize {
            return self.header.importNameCount(self.index);
        }
        pub fn nameAt(self: Self, index: usize) zx.ast.Name {
            return self.header.importNameAt(self.index, index);
        }
    };
}
