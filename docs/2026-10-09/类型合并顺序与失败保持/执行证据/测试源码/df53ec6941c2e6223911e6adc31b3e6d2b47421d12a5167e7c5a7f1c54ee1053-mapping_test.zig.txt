const check = @import("check.zig");

test "in place compaction matches independent merge without a committed prefix" {
    try check.run(.empty, .repeated);
}

test "in place compaction matches independent merge after scalar prefix" {
    try check.run(.scalar, .repeated);
}

test "in place compaction retains tuple child payload prefix" {
    try check.run(.tuple, .repeated);
}

test "in place compaction retains object field payload prefix" {
    try check.run(.object, .repeated);
}

test "in place compaction retains error member payload prefix" {
    try check.run(.errors, .repeated);
}

test "in place compaction retains enumeration identity prefix" {
    try check.run(.enumeration, .repeated);
}

test "in place compaction retains native reference identity prefix" {
    try check.run(.native, .repeated);
}

test "in place compaction reuses full original prefix without cloning columns" {
    try check.run(.full, .repeated);
}

test "in place compaction keeps same named nominal types from distinct origins separate" {
    try check.run(.full, .distinct);
}

test "in place compaction keeps distinct nominal origins after partially committed prefix" {
    try check.run(.scalar, .distinct);
}

test "in place compaction rolls back same origin enumeration member conflict" {
    try check.run(.full, .conflict);
}

test "in place compaction rolls back conflict after partial payload prefix" {
    try check.run(.object, .conflict);
}
