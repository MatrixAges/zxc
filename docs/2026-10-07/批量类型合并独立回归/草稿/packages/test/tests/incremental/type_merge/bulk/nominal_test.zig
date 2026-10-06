const cases = @import("cases.zig");

test "different source owner separates enum and all containing types" {
    try cases.two(.{}, .{ .mode_origin = .{ .source = "/source/other.zx" } }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "different native owner separates reference and all containing types" {
    try cases.two(.{}, .{ .native_owner = "zig:other" }, .{ .node = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "same native owner with different type name remains distinct" {
    try cases.two(.{}, .{ .native_name = "OtherNode" }, .{ .node = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "same enum owner with different declaration label remains distinct" {
    try cases.two(.{}, .{ .mode_name = "OtherMode" }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "source and native enum origins with identical owner bytes are distinct" {
    try cases.two(.{ .mode_origin = .{ .source = "zig:shared" } }, .{ .mode_origin = .{ .native = "zig:shared" } }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "same native enum identity merges shifted graph" {
    try cases.two(.{ .mode_origin = .{ .native = "zig:shared" } }, .{ .noise = true, .mode_origin = .{ .native = "zig:shared" } }, .{}, cases.base_count + 2, 3);
}

test "same external module member and label merge shifted graph" {
    try cases.two(.{ .mode_origin = .{ .external = .{ .module = "library", .member = "types" } } }, .{ .noise = true, .mode_origin = .{ .external = .{ .module = "library", .member = "types" } } }, .{}, cases.base_count + 2, 3);
}

test "different external member separates enum and containing graph" {
    try cases.two(.{ .mode_origin = .{ .external = .{ .module = "library", .member = "left" } } }, .{ .mode_origin = .{ .external = .{ .module = "library", .member = "right" } } }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "different external module separates equal member and label" {
    try cases.two(.{ .mode_origin = .{ .external = .{ .module = "left", .member = "types" } } }, .{ .mode_origin = .{ .external = .{ .module = "right", .member = "types" } } }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "native and external origins with equal owner bytes remain distinct" {
    try cases.two(.{ .mode_origin = .{ .native = "library" } }, .{ .mode_origin = .{ .external = .{ .module = "library", .member = "types" } } }, .{ .mode = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 6, 3);
}

test "both nominal identities changed separate their common dependents" {
    try cases.two(.{}, .{ .mode_origin = .{ .source = "/source/other.zx" }, .native_owner = "zig:other" }, .{ .mode = false, .node = false, .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 7, 4);
}

test "same nominal identity rejects changed later member" {
    try cases.conflict(.{}, .{ .members = &.{ "First", "Third" } });
}

test "same nominal identity rejects changed member order" {
    try cases.conflict(.{}, .{ .members = &.{ "Second", "First" } });
}

test "same nominal identity rejects shortened member list" {
    try cases.conflict(.{}, .{ .members = &.{"First"} });
}

test "same native origin and label reject enum reference kind mismatch" {
    try cases.conflict(.{ .mode_origin = .{ .native = "zig:fixture" } }, .{ .mode_origin = .{ .native = "zig:fixture" }, .mode_native = true });
}
