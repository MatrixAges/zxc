const dsl = @import("dsl");
const checks = @import("../checks.zig");
const paths = @import("../paths.zig");

const Base = dsl.element("Call", struct {
    @"fn": ?[]const u8 = null,
    service: ?[]const u8 = null,
    in: []const u8,
    out: ?[]const u8 = null,
    setter: ?[]const u8 = null,
}, dsl.empty);

pub const Call = dsl.refine(Base, check);

fn check(data: Base.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if ((data.attributes.@"fn" == null) == (data.attributes.service == null)) {
        return checks.fail(node, "service", "Call requires exactly one of fn or service", reporter);
    }

    if (data.attributes.service) |service| {
        if (!paths.isModuleReference(service)) return checks.fail(node, "service", "Service must reference a relative module file path", reporter);
        if (data.attributes.setter != null) return checks.fail(node, "setter", "Store setters belong to fn calls inside the target module", reporter);
    }
}
