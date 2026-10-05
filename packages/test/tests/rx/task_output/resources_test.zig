const std = @import("std");
const allocation_testing = @import("allocation_testing");
const check = @import("check.zig");

test "RX sequential object output cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"sequential_object"});
}

test "RX parallel object output cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"parallel_objects"});
}

test "RX nested independent Return cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"nested_independent_return"});
}

test "RX conflicting task output cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"switch_double_output"});
}
