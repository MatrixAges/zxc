const std = @import("std");
pub const Names = @import("zxc_abi").native.@"zig:type_names".Names;
pub const View = struct { labels: []const []const u8, fields: []const []const u8, members: []const []const u8 };

fn view(names: Names) *const View {
    return @ptrCast(@alignCast(names));
}

pub fn validLabel(names: Names, index: u64) bool {
    return @import("lint").checkName(view(names).labels[@intCast(index)], .type_decl);
}

pub fn validMember(names: Names, index: u64) bool {
    return @import("lint").checkName(view(names).members[@intCast(index)], .type_decl);
}

pub fn fieldsAscending(names: Names, left: u64, right: u64) bool {
    return std.mem.lessThan(u8, view(names).fields[@intCast(left)], view(names).fields[@intCast(right)]);
}

pub fn membersAscending(names: Names, left: u64, right: u64) bool {
    return std.mem.lessThan(u8, view(names).members[@intCast(left)], view(names).members[@intCast(right)]);
}
