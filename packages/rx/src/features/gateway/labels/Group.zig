const dsl = @import("dsl");
const checks = @import("../../../checks.zig");
const Entry = @import("../entries.zig").Entry;
pub const Group = checks.nonEmptySchema(dsl.element("Group", struct { prefix: []const u8 }, dsl.list(Entry, .{ .min = 1 })));
