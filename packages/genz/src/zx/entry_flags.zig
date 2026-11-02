const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const Flags = if (@import("genz_options").generated_analysis)
    std.meta.Child(@import("generated_entry_flags").Output)

else
    @import("entry_flags/seed.zig").Flags;

pub const Functions = struct {
    local: []const bool,
    pure: []const bool,
    io: []const bool,
    process: []const bool,
    tasks: []const bool,
};

pub fn analyze(workspace: std.mem.Allocator, program: ir.Program, functions: Functions) std.mem.Allocator.Error!Flags {
    if (!@import("genz_options").generated_analysis) return @import("entry_flags/seed.zig").analyze(program, functions);

    const generated = @import("generated_entry_flags");
    const Input = std.meta.Child(generated.Input);
    var scratch = std.heap.ArenaAllocator.init(workspace);

    defer scratch.deinit();

    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), program.types);

    const input = Input{
        .types = &types,
        .stores = zx.columns.pointer(@FieldType(Input, "stores"), &program.stores),
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &program.expressions),
        .contracts = zx.columns.pointer(@FieldType(Input, "contracts"), &program.contracts),
        .control = zx.columns.pointer(@FieldType(Input, "control"), program.body.control),
        .root = if (program.body.root) |root| @backingInt(root) else null,
        .output_type = @backingInt(program.output_type),
        .local = functions.local,
        .pure = functions.pure,
        .io = functions.io,
        .process = functions.process,
        .tasks = functions.tasks,
    };

    const output = generated.executeValue(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{
        .body_process = output.body_process,
        .io = output.io,
        .process = output.process,
        .scalar = output.scalar,
        .tasks = output.tasks,
        .value = output.value,
    };
}
