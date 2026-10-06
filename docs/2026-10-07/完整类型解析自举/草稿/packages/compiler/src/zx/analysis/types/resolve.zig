const zx = @import("zx");
const ir = zx.ir;
const Types = @import("../types.zig");
const seed = @import("resolve_seed.zig");
const generated = @import("../semantic/resolution.zig");

pub fn initialize(self: *Types, view: anytype) zx.Error!void {
    if (!@import("parser_options").generated_parser) return seed.initialize(self, view);

    const first = self.items.count();
    var state: generated.State = .{};
    const workspace = generated.workspace(self, view, &state);

    defer workspace.deinit();

    try generated.execute(&workspace, true);
    if (self.shared) |shared| try @import("../shared_types.zig").resolve(self, first, shared);
}

pub fn named(self: *Types, view: anytype, name: zx.ast.Name) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.named(self, view, name);

    var state: generated.State = .{};
    const workspace = generated.workspace(self, view, &state);

    defer workspace.deinit();

    try workspace.push(.{ .operation = .name, .name = name });
    try generated.execute(&workspace, false);

    return state.result;
}

pub fn node(self: *Types, view: anytype, value: @TypeOf(view).Ref) zx.Error!ir.TypeId {
    if (!@import("parser_options").generated_parser) return seed.node(self, view, value);

    var state: generated.State = .{};
    const workspace = generated.workspace(self, view, &state);

    defer workspace.deinit();

    try workspace.push(.{ .operation = .node, .value = @TypeOf(workspace.reader).reference(value) });
    try generated.execute(&workspace, false);

    return state.result;
}
