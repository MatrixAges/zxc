const Workspace = @import("workspace");
const views = @import("type_views");
const Program = views.Indexed(@import("program").Output);
const Expression = views.Indexed(@import("expression").Output);
const Declaration = views.Indexed(@import("declaration").Output);

export fn workspace(storage: *Workspace, frame: *const Workspace.Frame, count: usize) void {
    storage.push(frame.*) catch unreachable;
    storage.enter() catch unreachable;
    storage.leave();
    storage.allocateChildren(count) catch unreachable;
    storage.allocateFields(count) catch unreachable;
    storage.allocateMembers(count) catch unreachable;
    storage.pop();
    storage.deinit();
}

export fn sources(native: *const views.Native, program: *const Program, expression: *const Expression, declaration: *const Declaration) void {
    _ = Workspace.Source.from(native.*);
    _ = Workspace.Source.from(program.*);
    _ = Workspace.Source.from(expression.*);
    _ = Workspace.Source.from(declaration.*);
}
