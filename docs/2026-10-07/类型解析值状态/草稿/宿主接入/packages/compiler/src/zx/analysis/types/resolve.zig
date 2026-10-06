const zx = @import("zx");
const ir = zx.ir;
const Types = @import("../types.zig");
const seed = @import("resolve_seed.zig");
const generated = @import("../semantic/resolution.zig");

pub fn initialize(self: *Types, view: anytype) zx.Error!void {
    if (!@import("parser_options").generated_parser) return seed.initialize(self, view);

    const first = self.items.count();

    _ = try generated.execute(self, view, .{ .initialize = true });

    if (self.shared) |shared| try @import("../shared_types.zig").resolve(self, first, shared);
}

pub fn named(self: *Types, view: anytype, name: zx.ast.Name) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.named(self, view, name);

    return generated.execute(self, view, .{ .name = name });
}

pub fn node(self: *Types, view: anytype, value: @TypeOf(view).Ref) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.node(self, view, value);

    return generated.execute(self, view, .{ .node = value });
}
