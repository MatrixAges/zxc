const dsl = @import("dsl");
const checks = @import("../checks.zig");

pub const Return = checks.nonEmptySchema(dsl.element("Return", struct { value: []const u8 }, dsl.empty));
