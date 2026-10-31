const dsl = @import("dsl");
const checks = @import("../checks.zig");

pub const Args = checks.nonEmptySchema(dsl.element("Args", struct {
    in: []const u8,
    out: []const u8,
}, dsl.empty));
