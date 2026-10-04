const h = @import("check.zig");

test "RX automatic contract empty module" {
    try h.run(.{ .source = "<Module/>" });
}

test "RX automatic contract constant return" {
    try h.run(.{ .source = "<Module><Return value='true'/></Module>", .output = .bool, .returned = true });
}

test "RX automatic contract input constrained by function" {
    try h.run(.{ .source = "<Module><Call fn='number' in='$in' out='ctx.value'/><Return value='ctx.value'/></Module>", .input = .u64, .output = .u64, .calls = 1, .returned = true });
}

test "RX automatic contract nested input fields" {
    try h.run(.{ .source = "<Module><Call fn='number' in='$in.user.id' out='ctx.value'/><Return value='ctx.value'/></Module>", .input = .u64, .input_path = &.{ "user", "id" }, .output = .u64, .calls = 1, .returned = true });
}

test "RX automatic contract sequential result binding" {
    try h.run(.{ .source = "<Module><Call fn='text' in='$in' out='ctx.text'/><Call fn='length' in='ctx.text' out='ctx.size'/><Return value='ctx.size'/></Module>", .input = .string, .output = .u64, .calls = 2, .returned = true });
}

test "RX automatic contract unresolved input" {
    try h.run(.{ .source = "<Module><Return value='$in'/></Module>", .code = "type_mismatch" });
}

test "RX automatic contract incompatible shared input" {
    try h.run(.{ .source = "<Module><Call fn='number' in='$in'/><Call fn='text' in='$in'/></Module>", .code = "type_mismatch" });
}

test "RX automatic contract unreachable after return" {
    try h.run(.{ .source = "<Module><Return value='true'/><Call fn='number' in='1'/></Module>", .code = "return_path" });
}
