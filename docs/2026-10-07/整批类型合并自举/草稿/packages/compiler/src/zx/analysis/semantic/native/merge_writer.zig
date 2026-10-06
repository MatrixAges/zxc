const std = @import("std");
const Origins = @import("nominal_data");
const References = @import("reference_view");
const View = @import("merge_writer_view");
pub const Writer = @import("zxc_abi").native.@"zig:merge_writer".Writer;

fn view(writer: Writer) *View {
    return @ptrCast(@alignCast(@constCast(writer)));
}

pub fn prepareReferences(writer: Writer, index: u64, count: u64, dynamic: bool) std.mem.Allocator.Error!void {
    const data = view(writer);

    data.references.mapping = .{ .dense = data.mapping[0..@intCast(index)] };
    data.references.target = if (dynamic) try data.temporary.alloc(u32, @intCast(count)) else &data.scalar;
}

pub fn references(writer: Writer) []const u32 {
    return view(writer).references.target;
}

pub fn hasOrigin(writer: Writer, index: u64) bool {
    return view(writer).origin_indices[@intCast(index)] != null;
}

pub fn originIndex(writer: Writer, index: u64) u64 {
    return view(writer).origin_indices[@intCast(index)].?;
}

pub fn setMapping(writer: Writer, index: u64, value: u64) void {
    view(writer).mapping[@intCast(index)] = @fromBackingInt(@intCast(value));
}

pub fn appendType(writer: Writer, index: u64) std.mem.Allocator.Error!u64 {
    const data = view(writer);
    const owned = try View.copy(data.allocator, References.borrow(data.source.at(@intCast(index)), data.references.target));
    const id = data.items.count();

    try data.items.append(data.allocator, owned);

    return id;
}

pub fn appendOrigin(writer: Writer, index: u64, origin: u64) std.mem.Allocator.Error!void {
    const data = view(writer);

    try data.nominal.append(data.allocator, .{
        .type_id = @fromBackingInt(@intCast(index)),
        .origin = try Origins.copy(data.allocator, data.origins.at(@intCast(origin)).origin),
        .name = data.items.view().labels[@intCast(index)],
    });
}

pub fn fieldNames(writer: Writer, index: u64) []const []const u8 {
    const source = view(writer).source;
    const offset = source.first[@intCast(index)];
    const count = source.second[@intCast(index)];

    return source.field_names[offset..][0..count];
}

pub fn memberNames(writer: Writer, index: u64) []const []const u8 {
    const source = view(writer).source;
    const offset = source.first[@intCast(index)];
    const count = source.second[@intCast(index)];

    return source.names[offset..][0..count];
}

pub const kinds = @import("merge_columns.zig").kinds;
pub const first = @import("merge_columns.zig").first;
pub const second = @import("merge_columns.zig").second;
pub const labels = @import("merge_columns.zig").labels;
pub const children = @import("merge_columns.zig").children;
pub const fieldTypes = @import("merge_columns.zig").fieldTypes;
pub const allFieldNames = @import("merge_columns.zig").allFieldNames;
pub const names = @import("merge_columns.zig").names;
pub const originIds = @import("merge_columns.zig").originIds;
pub const originKinds = @import("merge_columns.zig").originKinds;
pub const originOwners = @import("merge_columns.zig").originOwners;
pub const originMembers = @import("merge_columns.zig").originMembers;
