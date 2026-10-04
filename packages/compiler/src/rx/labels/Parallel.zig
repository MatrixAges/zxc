const dsl = @import("dsl");
const steps = @import("../steps.zig");
pub const Parallel = dsl.element("Parallel", struct {}, steps.children(.parallel));
