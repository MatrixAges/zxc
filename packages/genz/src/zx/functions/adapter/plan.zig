const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../../lower.zig");
const view = @import("../../../node/view.zig");
const generated = @import("genz_options").generated_analysis;

pub fn eligible(self: *const Lower, id: ir.FunctionId) bool {
    const program = self.program;
    const value = self.value_functions[@backingInt(id)];

    if (!generated) {
        if (!value or self.entry_flags.tasks or self.entry_flags.io or self.entry_flags.process) return false;
        if (program.stores.count() != 0 or program.contracts.count() != 0) return false;

        return self.state_plan.represented(program, program.output_type) or
            self.state_plan.represented(program, program.input_type) or
            self.state_plan.inlineRows(program, program.input_type);
    }

    const entry = @import("generated_function_adapter_eligible");
    const Input = std.meta.Child(entry.Input);
    const queries = self.state_plan.queries;

    const input: Input = .{
        .value = value,
        .tasks = self.entry_flags.tasks,
        .io = self.entry_flags.io,
        .process = self.entry_flags.process,
        .stores = program.stores.count() != 0,
        .contracts = program.contracts.count() != 0,
        .input = @fromBackingInt(@backingInt(queries[@backingInt(program.input_type)])),
        .output = @fromBackingInt(@backingInt(queries[@backingInt(program.output_type)])),
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return entry.executeIn(fixed.allocator(), &input) catch unreachable;
}

pub fn argument(self: *const Lower, errors: []const []const u8) ?ir.ExprId {
    const table = self.program.expressions;

    if (!generated) {
        for (errors) |name| {
            if (std.mem.eql(u8, name, "OutOfMemory")) break;
        } else return null;

        for (0..table.count()) |row| {
            const expression = table.at(@intCast(row));

            if (expression.value == .reference and @backingInt(expression.value.reference) == 0) return @fromBackingInt(@as(u32, @intCast(row)));
        }

        return null;
    }

    const entry = @import("generated_function_adapter_argument");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .kinds = view.slice(@FieldType(Input, "kinds"), table.kinds),
        .payloads = table.payloads,
        .references = table.references,
        .errors = errors,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const found = entry.executeIn(fixed.allocator(), &input) catch unreachable;

    return if (found) |row| @fromBackingInt(row) else null;
}
