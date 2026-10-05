const dsl = @import("dsl");
const checks = @import("../checks.zig");
const steps = @import("../steps.zig");
pub const Task = checks.nonEmptySchema(dsl.element("Task", struct { name: []const u8, out: ?[]const u8 = null }, steps.children(.task)));
pub const Sequential = Task;
