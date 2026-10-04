const dsl = @import("dsl");
const steps = @import("../steps.zig");
pub const Default = dsl.element("Default", struct {}, steps.children(.body));
