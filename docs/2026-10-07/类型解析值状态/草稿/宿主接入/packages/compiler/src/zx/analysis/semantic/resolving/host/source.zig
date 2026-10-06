const std = @import("std");
const model = @import("model.zig");
const Native = @import("native.zig");
const layout = @import("layout.zig");
const Self = @This();

tree: model.Tree = model.empty_tree,
order: model.Order = model.empty_order,
indexed: model.Indexed = model.empty_indexed,
value: model.Source = undefined,
reference: model.Reference = model.empty_reference,
pub fn init(self: *Self, allocator: std.mem.Allocator, view: anytype, root: ?@TypeOf(view).Ref) std.mem.Allocator.Error!void {
    if (comptime @hasField(@TypeOf(view), "storage")) {
        inline for (@typeInfo(model.Tree).@"struct".field_names) |name| {
            @field(self.tree, name) = layout.borrow(@FieldType(model.Tree, name), @field(view.storage.types, name));
        }

        self.order = .{ .heads = view.storage.type_order.heads, .fields = view.storage.type_order.fields, .items = view.storage.type_order.items };
        self.indexed = .{ .bytes = view.source, .types = &self.tree, .order = &self.order, .declarations = &.{}, .members = &.{} };

        const Storage = @TypeOf(view.storage);
        const Data = if (@typeInfo(Storage) == .pointer) @typeInfo(Storage).pointer.child else Storage;

        if (comptime @hasField(Data, "declarations")) {
            self.indexed.declarations = layout.borrow(@FieldType(model.Indexed, "declarations"), view.storage.declarations);
            self.indexed.members = layout.borrow(@FieldType(model.Indexed, "members"), view.storage.members);
        }

        self.value = .{ .indexed = &self.indexed, .native = null };

        if (root) |selected| self.reference = switch (selected) {
            .node => |index| .{ .enumeration = false, .index = index },
            .enumeration => |index| .{ .enumeration = true, .index = index },
        };
    } else {
        var native: Native = .{ .allocator = allocator };
        const converted = try native.prepare(view.items, root);

        self.value = .{ .indexed = &self.indexed, .native = converted.source };
        self.reference = converted.reference;
    }
}
