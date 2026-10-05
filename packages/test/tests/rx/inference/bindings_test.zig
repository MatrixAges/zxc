const h = @import("check.zig");

test "RX result binding duplicate" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in}/><Call fn='number' in={$in}/></Module>", .code = "name" });
}

test "RX result binding rejects dotted name after valid name" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in}/><Call fn='a.b.zx' in={$in}/></Module>", .code = "name" });
}

test "RX result binding rejects dotted name before valid name" {
    try h.run(.{ .source = "<Module><Call fn='a.b.zx' in={$in}/><Call fn='number' in={$in}/></Module>", .code = "name" });
}

test "RX result binding keeps input separate from context result" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in}/><Return value={$ctx.number + $in}/></Module>", .input = .u64, .output = .u64, .calls = 1, .returned = true, .outs = &.{"$ctx.number"} });
}

test "RX result binding rejects dotted input-like name" {
    try h.run(.{ .source = "<Module><Call fn='$in.child.zx' in={$in}/></Module>", .code = "name" });
}

test "RX result binding rejects empty path segment" {
    try h.run(.{ .source = "<Module><Call fn='.a.zx' in={$in}/></Module>", .code = "name" });
}

test "RX result binding lexical prefix siblings are distinct" {
    try h.run(.{ .source = "<Module><Call fn='text' in={$in}/><Call fn='text_length' in={$in}/><Return value={`${$ctx.text}${$ctx.text_length}`}/></Module>", .input = .string, .output = .string, .calls = 2, .returned = true, .outs = &.{ "$ctx.text", "$ctx.text_length" } });
}

test "RX result binding input prefix is not an ancestor" {
    try h.run(.{ .source = "<Module><Call fn='$input' in={$in}/><Return value={$ctx.$input}/></Module>", .input = .u64, .output = .u64, .calls = 1, .returned = true, .outs = &.{"$ctx.$input"} });
}

test "RX result binding defaults to target filename" {
    try h.run(.{ .source = "<Module><Call fn='number' in={$in}/></Module>", .input = .u64, .calls = 1, .outs = &.{"$ctx.number"} });
}

test "RX result void call executes without a value binding" {
    try h.run(.{ .source = "<Module><Call fn='discard' in={$in}/></Module>", .input = .u64, .calls = 1, .outs = &.{null} });
}
