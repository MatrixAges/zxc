const h = @import("ownership_case");
const input = "{ choice: bool, items: u64[] }";
const beginning = "    const fresh: u64[] = []\n\n";

test "conditional mixed products join each field in either branch order" {
    inline for (.{
        "in.choice ? {fresh: fresh, view: in.items} : {fresh: fresh, view: fresh}",
        "in.choice ? {fresh: fresh, view: fresh} : {fresh: fresh, view: in.items}",
    }) |expression| {
        try h.run(.{ .input = input, .body = beginning ++ "    const box = " ++ expression ++ "\n\n    return box.fresh" });
        try h.run(.{ .input = input, .body = beginning ++ "    const box = " ++ expression ++ "\n\n    return box.view", .ownership = "borrowed" });
    }
}

test "match mixed products preserve independent owned and borrowed fields" {
    const expression = "match in.choice { true => {fresh: fresh, view: in.items}, _ => {fresh: fresh, view: fresh} }";

    try h.run(.{ .input = input, .body = beginning ++ "    const box = " ++ expression ++ "\n\n    return box.fresh" });
    try h.run(.{ .input = input, .body = beginning ++ "    const box = " ++ expression ++ "\n\n    return box.view", .ownership = "borrowed" });
}

test "conditional mixed tuples preserve positional field facts" {
    const expression = "in.choice ? [fresh, in.items] : [fresh, fresh]";

    try h.run(.{ .input = input, .body = beginning ++ "    const box: [u64[], u64[]] = " ++ expression ++ "\n\n    return box[0]" });
    try h.run(.{ .input = input, .body = beginning ++ "    const box: [u64[], u64[]] = " ++ expression ++ "\n\n    return box[1]", .ownership = "borrowed" });
}

test "one borrowed branch prevents an unsound owned projection" {
    try h.run(.{ .input = input, .ownership = "borrowed", .body = beginning ++
        \\    const box = in.choice ? {fresh: fresh, view: in.items} : {fresh: in.items, view: fresh}
        \\
        \\    return box.fresh
    });
}

test "scalar projection remains copy in a mixed aggregate" {
    try h.run(.{ .input = input, .output = "bool", .ownership = "copy", .body = beginning ++
        \\    const box = in.choice ? {flag: true, fresh: fresh, view: in.items} : {flag: false, fresh: fresh, view: fresh}
        \\
        \\    return box.flag
    });
}
