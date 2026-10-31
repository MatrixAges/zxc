const std = @import("std");
const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Analyzer = @import("analyzer.zig");
const binding = @import("expression_binding.zig");

pub fn resolve(self: *const Analyzer, owner: anytype) ?zx.ir.TypeId {
    const value = syntax.value(owner);
    const root = if (value == .identifier) owner else if (value == .field and syntax.value(value.field.target) == .identifier) value.field.target else return null;
    const name = syntax.value(root).identifier.text;

    for (self.active.items) |id| {
        if (std.mem.eql(u8, self.symbols.at(@backingInt(id)).name, name)) return null;
    }

    if (binding.lookup(self, root) != null or binding.unit(self, root)) return null;

    if (value == .identifier) {
        if (self.types.resolved.get(name)) |id| return enumeration(self, id);

        for (self.types.aliases) |alias| {
            if (std.mem.eql(u8, alias.name, name)) return enumeration(self, alias.type_id);
        }

        return null;
    }

    if (self.types.aliases.len == 0 or binding.lookup(self, owner) != null or binding.unit(self, owner)) return null;

    for (self.types.aliases) |alias| {
        if (binding.matches(owner, alias.name)) return enumeration(self, alias.type_id);
    }

    return null;
}

fn enumeration(self: *const Analyzer, id: zx.ir.TypeId) ?zx.ir.TypeId {
    return if (self.types.get(id) == .enumeration) id else null;
}
