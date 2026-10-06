const zx = @import("zx");
const Header = zx.syntax.header;

pub fn View(comptime Storage: type) type {
    return struct {
        const Self = @This();
        source: []const u8,
        storage: Storage,
        pub fn importCount(self: Self) usize {
            return self.storage.imports.len;
        }
        pub fn importAt(self: Self, index: usize) Header.Import {
            const item = self.storage.imports[index];

            return .{
                .kind = switch (item.kind) {
                    .Function => .function,
                    .Enumeration => .enumeration,
                    .TypeOnly => .type_only,
                },
                .path = self.source[@intCast(item.path.start + 1)..@intCast(item.path.end - 1)],
                .span = Header.span(item.span),
            };
        }

        pub fn importNameCount(self: Self, index: usize) usize {
            return @intCast(self.storage.imports[index].count);
        }
        pub fn importNameAt(self: Self, index: usize, name: usize) zx.ast.Name {
            const first: usize = @intCast(self.storage.imports[index].first);

            return self.named(self.storage.import_names[first + name]);
        }
        pub fn declarationCount(self: Self) usize {
            return self.storage.declarations.len;
        }
        pub fn declarationAt(self: Self, index: usize) Header.Declaration {
            const item = self.storage.declarations[index];

            return .{ .name = self.named(item.name), .span = Header.span(item.span) };
        }
        pub fn functionStart(self: Self) usize {
            return @intCast(self.storage.function_start);
        }

        pub fn hasBody(self: Self) bool {
            return self.storage.body != null;
        }
        fn named(self: Self, position: anytype) zx.ast.Name {
            const span = Header.span(position);

            return .{ .text = self.source[span.start..span.end], .span = span };
        }
    };
}
