const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const paths = @import("../../../paths.zig");
pub const Method = enum { GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH };

const RouteBase = dsl.element("Route", struct {
    path: []const u8,
    service: []const u8,
    method: ?Method = null,
}, dsl.empty);

pub const Route = dsl.refine(RouteBase, checkRoute);

fn checkRoute(data: RouteBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (!paths.isModuleReference(data.attributes.service)) return checks.fail(node, "service", "Route service must reference a relative module file path", reporter);
}
