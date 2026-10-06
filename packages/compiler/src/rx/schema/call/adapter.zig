const enabled = @import("rx_options").generated_rules;

pub const Input = if (enabled) @import("generated_call_rule").Input else *const struct { has_function: bool, has_module: bool, has_input: bool, has_setter: bool };
pub const Issue = if (enabled) @import("generated_call_rule").Output else enum { None, Target, Input, Setter };

pub fn check(input: Input) Issue {
    if (enabled) return @import("../scalar.zig").execute(@import("generated_call_rule"), input);
    if (input.has_function == input.has_module) return .Target;
    if (!input.has_input and !input.has_module) return .Input;

    return if (input.has_module and input.has_setter) .Setter else .None;
}
