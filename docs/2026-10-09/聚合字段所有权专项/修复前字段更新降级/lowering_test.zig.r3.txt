const h = @import("ownership_case");

test "scalar field update preserves independent owned sibling" {
    try h.run(.{ .body =
        \\    const result = loop({fresh: [1], view: in, index: 0}, {
        \\        while: state => state.index < state.view.length,
        \\        next: state => {
        \\            state.index += 1
        \\        }
        \\    })
        \\
        \\    return result.fresh
    });
}

test "postcondition fresh assignment retains ownership after earlier scalar update" {
    try h.run(.{ .body =
        \\    const result = loop({fresh: in, view: in, index: 0}, {
        \\        while: state => state.index < state.view.length,
        \\        do: state => {
        \\            state.index += 1
        \\            state.fresh = state.fresh.map(value => value)
        \\        }
        \\    })
        \\
        \\    return result.fresh
    });
}

test "postcondition root replacement preserves fresh field before every exit" {
    try h.run(.{ .body =
        \\    const result = loop({fresh: in, view: in, index: 0}, {
        \\        while: state => state.index < state.view.length,
        \\        do: state => {
        \\            state = {fresh: state.fresh.map(value => value), view: state.view, index: state.index + 1}
        \\        }
        \\    })
        \\
        \\    return result.fresh
    });
}
