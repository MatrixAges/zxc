    const child_path_gate = b.step("child-path-regression", "Run existing child fixture gates from the root build");

    child_path_gate.dependOn(&conformance.builder.top_level_steps.get("test-child-process").?.step);
    child_path_gate.dependOn(&conformance.builder.top_level_steps.get("test-child-input").?.step);
