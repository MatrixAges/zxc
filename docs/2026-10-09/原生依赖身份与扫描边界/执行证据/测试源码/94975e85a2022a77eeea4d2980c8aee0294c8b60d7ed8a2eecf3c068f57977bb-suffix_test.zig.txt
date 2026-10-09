const h = @import("suffix/check.zig");
const lifetime = @import("suffix/lifetime.zig");

test "source origin suffix selection covers every legal first boundary" {
    try h.boundaries(h.f.origin(.source), false);
}

test "native origin suffix selection covers enum reference and non nominal boundaries" {
    try h.boundaries(h.f.origin(.native), false);
}

test "external origin suffix selection covers every legal first boundary" {
    try h.boundaries(h.f.origin(.external), false);
}

test "source origin suffix append preserves an existing source prefix" {
    try h.boundaries(h.f.origin(.source), true);
}

test "native origin suffix append preserves an existing source prefix" {
    try h.boundaries(h.f.origin(.native), true);
}

test "external origin suffix append preserves an existing source prefix" {
    try h.boundaries(h.f.origin(.external), true);
}

test "source origin strings survive caller mutation and release" {
    try lifetime.run(h.f.origin(.source));
}

test "native origin strings survive caller mutation and release" {
    try lifetime.run(h.f.origin(.native));
}

test "external origin owner and member survive caller mutation and release" {
    try lifetime.run(h.f.origin(.external));
}
