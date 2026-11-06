pub fn check(terms: u64, list: bool, branch: bool) bool {
    return if (branch) terms > 2 else !list and terms > 3;
}

pub fn checkPipeline(steps: u64, width: u64, multiline: bool) ?[]const u8 {
    if (steps < 3) return "pipeline requires at least three processing steps";
    if (multiline) return "pipeline expressions must stay on one line; extract a function or use named bindings";

    return if (width > 30) "pipeline expressions must fit in 30 columns; extract a function or use named bindings" else null;
}

pub fn checkItem(terms: u64, width: u64, multiline: bool, nested: bool) ?[]const u8 {
    if (nested) return "condition lists cannot be nested; reference a named condition";
    if (multiline) return "condition items must stay on one line; extract a named condition";
    if (width > 30) return "condition items must fit in 30 columns; extract a named condition";

    return if (terms > 3) "condition items may contain at most three logical terms" else null;
}

pub fn checkTernary(multiline: bool, complex: bool) ?[]const u8 {
    return if (multiline or complex) "ternary expressions must be simple and single-line; use match or named steps" else null;
}
