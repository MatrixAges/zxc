const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const columns = @import("zx").columns;
const Nodes = frontend.ArtifactNodes;
const Error = frontend.project.artifact.Error;
const generated = @import("parser_options").generated_parser;

pub fn bind(functions: *ir.FunctionStorage, nodes: *Nodes, program: ir.Program, requested: ?ir.FunctionId) Error!?ir.FunctionId {
    if (!generated) {
        if (requested) |id| return try nodes.functionId(id);
        if (program.type_only) return null;
        if (functions.count() == std.math.maxInt(u32)) return error.OutOfMemory;

        const id: ir.FunctionId = @fromBackingInt(@as(u32, @intCast(functions.count())));

        try append(functions, nodes, program);

        return id;
    }

    const entry = @import("generated_library_public_entry");
    const range = nodes.functions.range;

    const input: std.meta.Child(entry.Input) = .{
        .requested = if (requested) |id| @backingInt(id) else null,
        .first = range.first,
        .count = range.count,
        .next = functions.count(),
        .type_only = program.type_only,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const plan = columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    switch (plan.kind) {
        .Invalid => return error.InvalidModule,
        .Full => return error.OutOfMemory,
        .Declaration => return null,
        .Existing => {},
        .Body => try append(functions, nodes, program),
    }

    return @fromBackingInt(plan.id.?);
}

fn append(functions: *ir.FunctionStorage, nodes: *Nodes, program: ir.Program) Error!void {
    try functions.append(nodes.allocator, try nodes.function(.{
        .file_name = program.file_name,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .output_ownership = program.output_ownership,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
        .contracts = program.contracts,
        .stores = program.stores,
        .store_mode = program.store_mode,
    }));
}
