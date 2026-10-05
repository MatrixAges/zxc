const h = @import("fixture.zig");

test "Store proof direct fresh_literals" {
    try h.run(.{
        .value = "{ count: 9, rows: [[1,2]], labels: [\"fresh\"] }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct scalar_read" {
    try h.run(.{
        .value = "{ count: in.count + 1, rows: [[1]], labels: [\"fresh\"] }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct whole_input" {
    try h.run(.{
        .value = "in",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct spread_shell" {
    try h.run(.{
        .value = "{...in, count: in.count + 1}",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct borrowed_rows" {
    try h.run(.{
        .value = "{ count: 9, rows: in.rows, labels: [\"fresh\"] }",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct shallow_rows" {
    try h.run(.{
        .value = "{ count: 9, rows: in.rows.map(row => row), labels: [\"fresh\"] }",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct deep_rows" {
    try h.run(.{
        .value = "{ count: 9, rows: in.rows.map(row => row.map(item => item)), labels: [\"fresh\"] }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct borrowed_labels" {
    try h.run(.{
        .value = "{ count: 9, rows: [[1]], labels: in.labels }",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct shallow_labels" {
    try h.run(.{
        .value = "{ count: 9, rows: [[1]], labels: in.labels.map(label => label) }",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct fresh_labels" {
    try h.run(.{
        .value = "{ count: 9, rows: [[1]], labels: in.labels.map(label => `${label}!`) }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct deep_both" {
    try h.run(.{
        .value = "{ count: in.count, rows: in.rows.map(row => row.map(item => item)), labels: in.labels.map(label => `${label}!`) }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct branch_fresh" {
    try h.run(.{
        .value = "in.count == 0 ? { count: 9, rows: [[1,2]], labels: [\"fresh\"] } : { count: 10, rows: [[3]], labels: [\"other\"] }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct branch_borrowed" {
    try h.run(.{
        .value = "in.count == 0 ? { count: 9, rows: [[1,2]], labels: [\"fresh\"] } : in",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct captured_row" {
    try h.run(.{
        .value = "{ count: 9, rows: [in.rows[0]], labels: [\"fresh\"] }",
        .expected = false,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct copied_element" {
    try h.run(.{
        .value = "{ count: 9, rows: [[in.rows[0][0]]], labels: [\"fresh\"] }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}

test "Store proof direct spread_replace_all" {
    try h.run(.{
        .value = "{ ...in, rows: in.rows.map(row => row.map(item => item)), labels: in.labels.map(label => `${label}!`) }",
        .expected = true,
        .helper = false,
        .service = false,
    });
}
