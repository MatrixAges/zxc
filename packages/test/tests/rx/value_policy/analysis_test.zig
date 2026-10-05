const std = @import("std");
const allocation_testing = @import("allocation_testing");
const check = @import("check.zig");

test "RX values reject function" {
    try check.run("function");
}

test "RX values reject method" {
    try check.run("method");
}

test "RX values reject map callback" {
    try check.run("map_callback");
}

test "RX values reject filter callback" {
    try check.run("filter_callback");
}

test "RX values reject reduce callback" {
    try check.run("reduce_callback");
}

test "RX values reject loop" {
    try check.run("loop");
}

test "RX values reject lambda" {
    try check.run("lambda");
}

test "RX values reject object" {
    try check.run("object");
}

test "RX values reject list" {
    try check.run("list");
}

test "RX values reject conditional condition" {
    try check.run("conditional_condition");
}

test "RX values reject conditional yes" {
    try check.run("conditional_yes");
}

test "RX values reject conditional no" {
    try check.run("conditional_no");
}

test "RX values reject binary left" {
    try check.run("binary_left");
}

test "RX values reject binary right" {
    try check.run("binary_right");
}

test "RX values reject unary" {
    try check.run("unary");
}

test "RX values reject field target" {
    try check.run("field_target");
}

test "RX values reject index target" {
    try check.run("index_target");
}

test "RX values reject index key" {
    try check.run("index_key");
}

test "RX values reject template" {
    try check.run("template");
}

test "RX values reject match condition" {
    try check.run("match_condition");
}

test "RX values reject match result" {
    try check.run("match_result");
}

test "RX values reject match fallback" {
    try check.run("match_fallback");
}

test "RX values reject logical dead branch" {
    try check.run("logical_dead_branch");
}

test "RX values reject call input" {
    try check.run("call_input");
}

test "RX values reject switch subject" {
    try check.run("switch_subject");
}

test "RX values reject case value" {
    try check.run("case_value");
}

test "RX values reject task result" {
    try check.run("task_result");
}

test "RX values reject parallel result" {
    try check.run("parallel_result");
}

test "RX values reject crlf" {
    try check.run("crlf");
}

test "RX values reject utf8" {
    try check.run("utf8");
}

test "RX value loop rejection releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"loop"});
}

test "RX value template rejection releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"template"});
}

test "RX value call input rejection releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"call_input"});
}

test "RX values reject store call" {
    try check.run("store_call");
}

test "RX values reject store callback" {
    try check.run("store_callback");
}

test "RX Store initializer rejection releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"store_call"});
}

test "RX values reject task out call" {
    try check.run("task_out_call");
}

test "RX values reject task out object" {
    try check.run("task_out_object");
}

test "RX values reject task out template" {
    try check.run("task_out_template");
}

test "RX values reject task out lambda" {
    try check.run("task_out_lambda");
}

test "RX values reject parallel out call" {
    try check.run("parallel_out_call");
}

test "RX Task out rejection releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check.allocated, .{"task_out_object"});
}
