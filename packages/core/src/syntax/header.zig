const ast = @import("../ast.zig");
const Span = @import("../source.zig").Span;

pub const Import = struct {
    kind: @FieldType(ast.Import, "kind"),
    exported: bool = false,
    wildcard: bool = false,
    path: []const u8,
    span: Span,
};

pub const Declaration = struct { name: ast.Name, span: Span };

pub const Native = struct {
    program: ast.Program,
    pub fn importCount(self: Native) usize {
        return self.program.imports.len;
    }
    pub fn importAt(self: Native, index: usize) Import {
        const item = self.program.imports[index];

        return .{ .kind = item.kind, .exported = item.exported, .wildcard = item.wildcard, .path = item.path, .span = item.span };
    }
    pub fn importNameCount(self: Native, index: usize) usize {
        return self.program.imports[index].names.len;
    }

    pub fn importNameAt(self: Native, index: usize, name: usize) ast.Name {
        return self.program.imports[index].names[name];
    }

    pub fn importSourceAt(self: Native, index: usize, name: usize) ast.Name {
        const item = self.program.imports[index];

        return (if (item.source_names.len == 0) item.names else item.source_names)[name];
    }

    pub fn declarationCount(self: Native) usize {
        return self.program.declarations.len;
    }

    pub fn declarationAt(self: Native, index: usize) Declaration {
        const item = self.program.declarations[index];

        return .{ .name = item.name, .span = item.span };
    }

    pub fn constantCount(self: Native) usize {
        return self.program.constants.len;
    }
    pub fn constantAt(self: Native, index: usize) Declaration {
        const item = self.program.constants[index];

        return .{ .name = item.name, .span = item.span };
    }
    pub fn functionStart(self: Native) usize {
        return self.program.function_start;
    }
    pub fn functionName(self: Native) ?ast.Name {
        return self.program.function_name;
    }

    pub fn hasBody(self: Native) bool {
        return self.program.body != null;
    }
};

pub fn span(position: anytype) Span {
    return .{ .start = @intCast(position.start), .end = @intCast(position.end) };
}
