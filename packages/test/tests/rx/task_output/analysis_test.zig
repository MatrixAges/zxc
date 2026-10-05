const check = @import("check.zig");

test "RX task output sequential scalar" {
    try check.run("sequential_scalar");
}

test "RX task output sequential string" {
    try check.run("sequential_string");
}

test "RX task output sequential object" {
    try check.run("sequential_object");
}

test "RX task output sequential siblings" {
    try check.run("sequential_siblings");
}

test "RX task output parallel objects" {
    try check.run("parallel_objects");
}

test "RX task output parallel mixed" {
    try check.run("parallel_mixed");
}

test "RX task output nested independent return" {
    try check.run("nested_independent_return");
}

test "RX task output switch then out" {
    try check.run("switch_then_out");
}

test "RX task output sequential return" {
    try check.run("sequential_return");
}

test "RX task output void task" {
    try check.run("void_task");
}

test "RX task output void parallel task" {
    try check.run("void_parallel_task");
}

test "RX task output call and task same name" {
    try check.run("call_and_task_same_name");
}

test "RX task output explicit source suffix" {
    try check.run("explicit_source_suffix");
}

test "RX task output module target name" {
    try check.run("module_target_name");
}

test "RX task output sequential double output" {
    try check.run("sequential_double_output");
}

test "RX task output parallel double output" {
    try check.run("parallel_double_output");
}

test "RX task output switch double output" {
    try check.run("switch_double_output");
}

test "RX task output nested sequential double output" {
    try check.run("nested_sequential_double_output");
}

test "RX task output task private call escape" {
    try check.run("task_private_call_escape");
}

test "RX task output branch private call in out" {
    try check.run("branch_private_call_in_out");
}

test "RX task output missing out name" {
    try check.run("missing_out_name");
}

test "RX task output quoted path out" {
    try check.run("quoted_path_out");
}

test "RX task output quoted literal out" {
    try check.run("quoted_literal_out");
}

test "RX task output empty out" {
    try check.run("empty_out");
}

test "RX task output void task read" {
    try check.run("void_task_read");
}

test "RX task output duplicate task name" {
    try check.run("duplicate_task_name");
}

test "RX task output removed call name" {
    try check.run("removed_call_name");
}

test "RX task output removed call out" {
    try check.run("removed_call_out");
}

test "RX task output removed call args" {
    try check.run("removed_call_args");
}

test "RX task output duplicate target name" {
    try check.run("duplicate_target_name");
}

test "RX task output reserved target name" {
    try check.run("reserved_target_name");
}

test "RX task output removed call service" {
    try check.run("removed_call_service");
}
