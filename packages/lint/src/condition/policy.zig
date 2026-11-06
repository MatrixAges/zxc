const std = @import("std");
const generated = @import("generated");
const Input = std.meta.Child(generated.Input);

pub fn check(terms: u64, list: bool, branch: bool) bool {
    return run(.{ .mode = if (branch) .Branch else .Shortcut, .terms = terms, .list = list, .steps = 0, .width = 0, .multiline = false, .nested = false }) != null;
}

pub fn checkPipeline(steps: u64, width: u64, multiline: bool) ?[]const u8 {
    return run(.{ .mode = .Pipeline, .terms = 0, .list = false, .steps = steps, .width = width, .multiline = multiline, .nested = false });
}

pub fn checkItem(terms: u64, width: u64, multiline: bool, nested: bool) ?[]const u8 {
    return run(.{ .mode = .Item, .terms = terms, .list = true, .steps = 0, .width = width, .multiline = multiline, .nested = nested });
}

pub fn checkTernary(multiline: bool, complex: bool) ?[]const u8 {
    return run(.{ .mode = .Ternary, .terms = 0, .list = false, .steps = 0, .width = 0, .multiline = multiline, .nested = complex });
}

fn run(input: Input) ?[]const u8 {
    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return generated.executeValue(memory.allocator(), &input) catch unreachable;
}
