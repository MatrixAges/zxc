const std = @import("std");
const dsl = @import("dsl");
const frontend = @import("frontend");
const checks = @import("../checks.zig");
const Base = dsl.element("Type", struct { from: []const u8, as: []const u8 }, dsl.empty);
pub const Type = dsl.refine(Base, check);

fn check(data: Base.Data, node: anytype, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (!@import("../paths.zig").isFunctionReference(data.attributes.from)) {
        return checks.fail(node, "from", "Type must reference a ZX source file", reporter);
    }

    if (!frontend.binding_path.valid(data.attributes.as) or std.mem.indexOfScalar(u8, data.attributes.as, '.') != null) {
        return checks.fail(node, "as", "Type alias must be one ZX identifier", reporter);
    }
}
