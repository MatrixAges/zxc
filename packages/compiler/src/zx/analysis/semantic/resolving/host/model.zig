const generated = @import("generated_type_resolution");
pub const Request = child(generated.Input);
pub const Context = child(@FieldType(Request, "context"));
pub const Table = child(@FieldType(Context, "base"));
pub const Cache = child(@FieldType(Context, "resolved"));
pub const Source = child(@FieldType(Context, "source"));
pub const Indexed = child(@FieldType(Source, "indexed"));
pub const Tree = child(@FieldType(Indexed, "types"));
pub const Order = child(@FieldType(Indexed, "order"));
pub const Native = child(@typeInfo(@FieldType(Source, "native")).optional.child);
pub const Node = child(child(@FieldType(Native, "nodes")));
pub const Field = child(child(@FieldType(Native, "fields")));
pub const Item = child(child(@FieldType(Native, "items")));
pub const Entry = child(child(@FieldType(Native, "declarations")));
pub const Enumeration = child(child(@FieldType(Native, "enumerations")));
pub const Name = child(@FieldType(Request, "name"));
pub const Reference = child(@FieldType(Request, "reference"));
pub const empty_name: Name = .{ .text = "", .start = 0, .end = 0 };
pub const empty_reference: Reference = .{ .enumeration = false, .index = 0 };
pub const empty_tree: Tree = .{ .nodes = &.{}, .fields = &.{}, .items = &.{} };
pub const empty_order: Order = .{ .heads = &.{}, .fields = &.{}, .items = &.{} };
pub const empty_indexed: Indexed = .{ .bytes = &.{}, .types = &empty_tree, .order = &empty_order, .declarations = &.{}, .members = &.{} };

fn child(comptime T: type) type {
    return @typeInfo(T).pointer.child;
}
