const dsl = @import("dsl");
const checks = @import("../checks.zig");
const paths = @import("../paths.zig");

const Base = dsl.element("Call", struct {
    @"fn": ?[]const u8 = null,
    service: ?[]const u8 = null,
    module: ?[]const u8 = null,
    name: ?[]const u8 = null,
    args: ?[]const u8 = null,
    setter: ?[]const u8 = null,
}, dsl.empty);

pub const Call = dsl.refine(Base, check);

fn check(data: Base.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (@as(u8, @intFromBool(data.attributes.@"fn" != null)) + @intFromBool(data.attributes.service != null) + @intFromBool(data.attributes.module != null) != 1) {
        return checks.fail(node, "service", "Call requires exactly one of fn, service or module", reporter);
    }

    if (data.attributes.args == null and data.attributes.module == null) return reporter.fail(.{ .code = .missing_attribute, .location = node.location, .element = node.name, .attribute = "args", .message = "Missing required attribute" });
    if (data.attributes.module != null and data.attributes.setter != null) return checks.fail(node, "setter", "Store authorization belongs inside the published RX module", reporter);

    if (data.attributes.service) |service| {
        if (!paths.isModuleReference(service)) return checks.fail(node, "service", "Service must reference a relative module file path", reporter);
        if (data.attributes.setter != null) return checks.fail(node, "setter", "Store setters belong to fn calls inside the target module", reporter);
    }
}
