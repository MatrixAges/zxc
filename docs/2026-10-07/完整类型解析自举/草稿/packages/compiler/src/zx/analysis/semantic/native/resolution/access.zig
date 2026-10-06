pub const Workspace = @import("zxc_abi").native.@"zig:resolution".Workspace;
pub const View = @import("resolution_workspace");

pub fn view(workspace: Workspace) *const View {
    return @ptrCast(@alignCast(workspace));
}
