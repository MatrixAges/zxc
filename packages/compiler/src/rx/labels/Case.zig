const dsl = @import("dsl");
const checks = @import("../checks.zig");
const steps = @import("../steps.zig");

pub const Case = checks.nonEmptySchema(dsl.element("Case", struct { value: []const u8 }, steps.children(.body)));
