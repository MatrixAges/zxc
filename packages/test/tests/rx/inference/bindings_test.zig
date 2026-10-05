const h = @import("check.zig");

test "RX result binding duplicate" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='ctx.a'/><Call fn='number' in={$in} out='ctx.a'/></Module>", .code = "name" });
}

test "RX result binding parent before child" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='ctx.a'/><Call fn='number' in={$in} out='ctx.a.b'/></Module>", .code = "name" });
}

test "RX result binding child before parent" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='ctx.a.b'/><Call fn='number' in={$in} out='ctx.a'/></Module>", .code = "name" });
}

test "RX result binding cannot overwrite input" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='$in'/></Module>", .code = "name" });
}

test "RX result binding cannot overwrite input child" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='$in.child'/></Module>", .code = "name" });
}

test "RX result binding rejects empty path segment" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='ctx..a'/></Module>", .code = "name" });
}

test "RX result binding lexical prefix siblings are distinct" {
    try h.run(.{ .source = "<Module><Call fn='text' in={$in} out='ctx.a'/><Call fn='length' in={$in} out='ctx.ab'/><Return value={`${ctx.a}${ctx.ab}`}/></Module>", .input = .string, .output = .string, .calls = 2, .returned = true, .outs = &.{ "ctx.a", "ctx.ab" } });
}

test "RX result binding input prefix is not an ancestor" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in} out='$input'/><Return value={$input}/></Module>", .input = .u64, .output = .u64, .calls = 1, .returned = true, .outs = &.{"$input"} });
}

test "RX result binding may discard nonvoid output" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in}/></Module>", .input = .u64, .calls = 1, .outs = &.{null} });
}

test "RX result binding rejects void output" {
    try h.run(.{ .source = "<Module><Call fn='discard' in={$in} out='ctx.value'/></Module>", .code = "type_mismatch" });
}
