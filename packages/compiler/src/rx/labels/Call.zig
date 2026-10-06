const dsl = @import("dsl");
const checks = @import("../checks.zig");
const paths = @import("../paths.zig");

const Base = dsl.element("Call", struct {
    @"fn": ?[]const u8 = null,
    module: ?[]const u8 = null,
    in: ?[]const u8 = null,
    setter: ?[]const u8 = null,
}, dsl.empty);

pub const Call = dsl.refine(Base, check);

fn check(data: Base.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    switch (@import("../schema/call/adapter.zig").check(&.{
        .has_function = data.attributes.@"fn" != null,
        .has_module = data.attributes.module != null,
        .has_input = data.attributes.in != null,
        .has_setter = data.attributes.setter != null,
    })) {
        .None => {},
        .Target => return checks.fail(node, "module", "Call requires exactly one of fn or module", reporter),
        .Input => return reporter.fail(.{ .code = .missing_attribute, .location = node.location, .element = node.name, .attribute = "in", .message = "Missing required attribute" }),
        .Setter => return checks.fail(node, "setter", "Store authorization belongs inside the called RX module", reporter),
    }

    if (data.attributes.module) |module| {
        if (!paths.isModuleReference(module)) return checks.fail(node, "module", "Module must reference a local RX path or a declared package module", reporter);
    }
}
