const std = @import("std");
const allocation_testing = @import("allocation_testing");
const check = @import("check.zig").check;

test "lock workspace resolves or rejects plain name" {
    try check(std.testing.allocator, .{ .requirement = "workspace:*" });
}

test "lock workspace resolves or rejects compatible range" {
    try check(std.testing.allocator, .{ .requirement = "workspace:^1.0.0" });
}

test "lock workspace resolves or rejects named alias" {
    try check(std.testing.allocator, .{ .name = "alias", .requirement = "workspace:a@~1.2.0" });
}

test "lock workspace resolves or rejects scoped alias" {
    try check(std.testing.allocator, .{ .name = "alias", .requirement = "workspace:@scope/b@^2.0.0", .target = 2 });
}

test "lock workspace resolves or rejects scoped name shortcut" {
    try check(std.testing.allocator, .{ .name = "@scope/b", .requirement = "workspace:^", .target = 2 });
}

test "lock workspace resolves or rejects root relative member" {
    try check(std.testing.allocator, .{ .name = "alias", .requirement = "workspace:./apps/a" });
}

test "lock workspace resolves or rejects member relative other workspace" {
    try check(std.testing.allocator, .{ .owner = 1, .name = "alias", .requirement = "workspace:../../libs/b", .target = 2 });
}

test "lock workspace resolves or rejects member relative self resolution" {
    try check(std.testing.allocator, .{ .owner = 1, .requirement = "workspace:../a" });
}

test "lock workspace resolves or rejects missing name" {
    try check(std.testing.allocator, .{ .name = "absent", .requirement = "workspace:*", .failure = error.InvalidLockWorkspaceTarget });
}

test "lock workspace resolves or rejects missing relative path" {
    try check(std.testing.allocator, .{ .requirement = "workspace:./absent", .failure = error.InvalidLockWorkspaceTarget });
}

test "lock workspace resolves or rejects mismatched range" {
    try check(std.testing.allocator, .{ .requirement = "workspace:^2.0.0", .failure = error.LockVersionMismatch });
}

test "lock workspace resolves or rejects root parent escape" {
    try check(std.testing.allocator, .{ .requirement = "workspace:../apps/a", .failure = error.InvalidLockWorkspacePath });
}

test "lock workspace resolves or rejects member parent escape" {
    try check(std.testing.allocator, .{ .owner = 1, .requirement = "workspace:../../../libs/b", .failure = error.InvalidLockWorkspacePath });
}

test "lock workspace resolves or rejects relative path colon" {
    try check(std.testing.allocator, .{ .requirement = "workspace:./a:b", .failure = error.InvalidLockWorkspacePath });
}

test "lock workspace resolves or rejects nonworkspace requirement" {
    try check(std.testing.allocator, .{ .requirement = "^1.0.0", .failure = error.InvalidLockWorkspaceTarget });
}

test "lock workspace resolves or rejects owner index out of bounds" {
    try check(std.testing.allocator, .{ .owner = 3, .requirement = "workspace:*", .failure = error.InvalidLockWorkspaceTarget });
}

test "lock workspace resolves or rejects archive owner" {
    try check(std.testing.allocator, .{ .owner = 1, .archive_owner = true, .requirement = "workspace:*", .failure = error.InvalidLockWorkspaceTarget });
}

test "lock relative target lookup releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@import("check.zig").Case{ .owner = 1, .name = "alias", .requirement = "workspace:../../libs/b", .target = 2 }});
}

test "lock missing relative target releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@import("check.zig").Case{ .requirement = "workspace:./absent", .failure = error.InvalidLockWorkspaceTarget }});
}
