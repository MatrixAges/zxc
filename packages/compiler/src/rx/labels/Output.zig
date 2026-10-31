const dsl = @import("dsl");
const ports = @import("../schema/ports.zig");
pub const Output = dsl.refine(ports.schema("Output"), ports.check);
