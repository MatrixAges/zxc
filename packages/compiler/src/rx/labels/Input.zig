const dsl = @import("dsl");
const ports = @import("../schema/ports.zig");

pub const Input = dsl.refine(ports.schema("Input"), ports.check);
