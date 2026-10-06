const access = @import("access.zig");
const Writer = access.Writer;
const view = access.view;

pub fn kinds(writer: Writer) []const u8 {
    return view(writer).items.kinds.items;
}

pub fn first(writer: Writer) []const u32 {
    return view(writer).items.first.items;
}

pub fn second(writer: Writer) []const u32 {
    return view(writer).items.second.items;
}

pub fn labels(writer: Writer) []const []const u8 {
    return view(writer).items.labels.items;
}

pub fn children(writer: Writer) []const u32 {
    return view(writer).items.children.items;
}

pub fn allFieldTypes(writer: Writer) []const u32 {
    return view(writer).items.field_types.items;
}

pub fn allFieldNames(writer: Writer) []const []const u8 {
    return view(writer).items.field_names.items;
}

pub fn names(writer: Writer) []const []const u8 {
    return view(writer).items.names.items;
}
