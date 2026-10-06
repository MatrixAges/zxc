const View = @import("merge_writer_view");
const Writer = @import("zxc_abi").native.@"zig:merge_writer".Writer;

fn view(writer: Writer) *const View {
    return @ptrCast(@alignCast(writer));
}

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

pub fn fieldTypes(writer: Writer) []const u32 {
    return view(writer).items.field_types.items;
}

pub fn allFieldNames(writer: Writer) []const []const u8 {
    return view(writer).items.field_names.items;
}

pub fn names(writer: Writer) []const []const u8 {
    return view(writer).items.names.items;
}

pub fn originIds(writer: Writer) []const u32 {
    return view(writer).nominal.ids.items;
}

pub fn originKinds(writer: Writer) []const u8 {
    return view(writer).nominal.kinds.items;
}

pub fn originOwners(writer: Writer) []const []const u8 {
    return view(writer).nominal.owners.items;
}

pub fn originMembers(writer: Writer) []const []const u8 {
    return view(writer).nominal.members.items;
}
