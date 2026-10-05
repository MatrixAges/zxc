const std = @import("std");
const allocation_testing = @import("allocation_testing");
const h = @import("check.zig");

const scalar_read = h.Case{
    .body = "  const values = in.map(item => item)\n\n  return values.push(values.length)[0]",
};

test "consuming receiver permits scalar length argument before move" {
    try h.run(scalar_read);
}

test "consuming receiver permits scalar indexed argument before move" {
    try h.run(.{
        .body = "  const values: u64[] = [3]\n\n  return values.push(values[0])[0]",
    });
}

test "consuming receiver rejects nested consumption inside argument" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n\n  return values.push(values.reverse()[0].length)[0]",
        .marker = "values.reverse()",
    });
}

test "consuming receiver stays moved after scalar argument read" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n  const next = values.push(values.length)[0]\n\n  return values",
        .marker = "values",
    });
}

test "borrowed receiver is not made owned by scalar argument read" {
    try h.run(.{
        .body = "  return in.push(in.length)[0]",
        .marker = "in.push(in.length)",
    });
}

test "consuming receiver scalar argument cleans allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.allocated, .{scalar_read});
}

test "consuming receiver permits scalar reads through object owner" {
    try h.run(.{
        .body = "  const box: { values: u64[] } = {values: [3]}\n\n  return box.values.push(box.values.length)[0]",
    });
}

test "consuming receiver permits scalar reads through tuple owner" {
    try h.run(.{
        .body = "  const box: [u64[], u64] = [[3], 9]\n\n  return box[0].push(box[1])[0]",
    });
}

test "consuming receiver permits scalar reads through nested list owner" {
    try h.run(.{
        .body = "  const rows: u64[][] = [[3]]\n\n  return rows[0].push(rows.length)[0]",
    });
}

test "consuming nested list receiver also moves parent owner" {
    try h.run(.{
        .body = "  const rows: u64[][] = [[3]]\n  const result = rows[0].push(rows.length)[0]\n\n  return rows[0]",
        .marker = "rows[0]",
    });
}

test "temporary transform in argument preserves receiver reservation" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n\n  return values.push(values.map(item => item).length)[0]",
    });
}

test "receiver cannot escape as a reference argument during consumption" {
    try h.run(.{
        .body = "  const values = in.map(item => item)\n\n  return values.concat(values)[0]",
        .marker = "values.concat(values)",
    });
}
