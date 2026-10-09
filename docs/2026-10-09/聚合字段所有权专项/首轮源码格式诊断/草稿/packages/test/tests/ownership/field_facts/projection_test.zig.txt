const h = @import("ownership_case");

const object =
    \\    const fresh: u64[] = []
    \\
    \\    const box: { fresh: u64[], view: u64[] } = { view: in, fresh: fresh }
    \\
;

const tuple =
    \\    const fresh: u64[] = []
    \\
    \\    const box: [u64[], u64[]] = [fresh, in]
    \\
;

test "mixed object projects owned field independently of borrowed sibling" {
    try h.run(.{ .body = object ++ "    return box.fresh" });
}

test "mixed object retains borrowed field provenance" {
    try h.run(.{ .body = object ++ "    return box.view", .ownership = "borrowed" });
}

test "mixed tuple projects owned field independently of borrowed sibling" {
    try h.run(.{ .body = tuple ++ "    return box[0]" });
}

test "mixed tuple retains borrowed field provenance" {
    try h.run(.{ .body = tuple ++ "    return box[1]", .ownership = "borrowed" });
}

test "nested object and tuple preserve owned projection through two products" {
    try h.run(.{ .body =
        \\    const fresh: u64[] = []
        \\
        \\    const box: { mixed: [u64[], u64[]], view: u64[] } = { mixed: [fresh, in], view: in }
        \\
        \\    return box.mixed[0]
    });
}

test "optional product preserves owned payload field after refinement" {
    try h.run(.{ .body =
        \\    const fresh: u64[] = []
        \\
        \\    const box: { fresh: u64[], view: u64[] }? = { fresh: fresh, view: in }
        \\
        \\    if (box != null) {
        \\        return box.fresh
        \\    }
        \\
        \\    return fresh
    });
}
