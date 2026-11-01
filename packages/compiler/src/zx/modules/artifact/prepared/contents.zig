const ir = @import("zx").ir;
const Nodes = @import("../nodes.zig");
const Record = @import("../../module_record.zig");
const FunctionImport = @import("../../function_import.zig");
const Error = @import("../model.zig").Error;

pub fn exports(nodes: *Nodes, source: []const ir.Export) Error![]const ir.Export {
    const result = try nodes.allocator.alloc(ir.Export, source.len);

    for (source, result) |value, *owned| owned.* = .{ .name = try nodes.allocator.dupe(u8, value.name), .type_id = try nodes.types.include(value.type_id) };

    return result;
}

pub fn imports(nodes: *Nodes, source: []const FunctionImport) Error![]const FunctionImport {
    const result = try nodes.allocator.dupe(FunctionImport, source);

    for (result) |*value| {
        value.id = if (value.id) |id| try nodes.functionId(id) else null;
        value.name = try nodes.allocator.dupe(u8, value.name);
        value.namespace = if (value.namespace) |name| try nodes.allocator.dupe(u8, name) else null;
        value.input_type = if (value.input_type) |id| try nodes.types.include(id) else null;
        value.output_type = if (value.output_type) |id| try nodes.types.include(id) else null;
    }

    return result;
}

pub fn dependencies(nodes: *Nodes, source: []const Record.Import) Error![]const Record.Import {
    const result = try nodes.allocator.dupe(Record.Import, source);

    for (result) |*value| {
        value.specifier = try nodes.allocator.dupe(u8, value.specifier);
        value.identity = if (value.identity) |key| try nodes.allocator.dupe(u8, key) else null;
        value.names = try nodes.strings(value.names);
        value.source_names = try nodes.strings(value.source_names);

        value.target = switch (value.target) {
            .compiled => unreachable,
            .source => |path| .{ .source = try nodes.allocator.dupe(u8, path) },
            .native, .external, .intrinsic => value.target,
        };
    }

    return result;
}

pub fn function(nodes: *Nodes, program: ir.Program, record: Record) Error!?ir.Function {
    const value: ir.Function = switch (record.body) {
        .types => return null,
        .entry => .{ .stores = program.stores, .store_mode = program.store_mode, .file_name = program.file_name, .input_type = program.input_type, .output_type = program.output_type, .output_ownership = program.output_ownership, .symbols = program.symbols, .expressions = program.expressions, .body = program.body, .contracts = program.contracts },
        .function => |id| program.functions.at(@backingInt(id)),
    };

    return try nodes.function(value);
}
