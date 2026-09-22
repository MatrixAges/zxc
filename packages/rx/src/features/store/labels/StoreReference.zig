const dsl = @import("dsl");
const checks = @import("../../../checks.zig");

pub const StoreReference = checks.nonEmptySchema(dsl.element("Store", struct {
    from: []const u8,
    as: ?[]const u8 = null,
}, dsl.empty));
