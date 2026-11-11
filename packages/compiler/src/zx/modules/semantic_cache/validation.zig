const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const Artifact = @import("../artifact/model.zig");
const constants = @import("../../analysis/constants/check.zig");
const header = @import("generated_semantic_cache_header");
const binding = @import("generated_semantic_cache_binding");
const function = @import("generated_semantic_cache_function");
const Error = std.mem.Allocator.Error;

pub fn validate(allocator: std.mem.Allocator, artifact_allocator: std.mem.Allocator, module: *const Artifact.Module) Error!bool {
    if (!validHeader(module)) return false;
    if (!try constants.validate(artifact_allocator, module.types, module.constant_exports)) return false;
    if (!try constants.validate(artifact_allocator, module.types, module.constant_imports)) return false;
    if (!validBindings(module)) return false;

    return if (module.function) |*body| validFunction(allocator, body) else true;
}

fn validHeader(module: *const Artifact.Module) bool {
    const Input = std.meta.Child(header.Input);
    const Tables = std.meta.Child(@FieldType(Input, "tables"));
    const signatures = columns.columns(std.meta.Child(@FieldType(Tables, "signatures")), module.functions);
    const modules = columns.columns(std.meta.Child(@FieldType(Tables, "modules")), module.native_modules);
    const stores = columns.columns(std.meta.Child(@FieldType(Tables, "stores")), module.stores);
    const tables: Tables = .{ .signatures = &signatures, .modules = &modules, .stores = &stores };
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), module.types);

    const input: Input = .{
        .tables = &tables,
        .types = &types,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return columns.invoke(header.executeValue, empty.allocator(), &input) catch unreachable;
}

fn validBindings(module: *const Artifact.Module) bool {
    const Input = std.meta.Child(binding.Input);
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const memory = empty.allocator();

    for ([_][]const @import("../function_import.zig"){ module.function_imports, module.members }) |bindings| {
        for (bindings) |item| {
            const input: Input = .{
                .intrinsic = item.intrinsic != null,
                .id = if (item.id) |id| @backingInt(id) else null,
                .input_type = if (item.input_type) |id| @backingInt(id) else null,
                .output_type = if (item.output_type) |id| @backingInt(id) else null,
                .input_types = module.functions.input_types,
                .output_types = module.functions.output_types,
            };

            if (!(columns.invoke(binding.executeValue, memory, &input) catch unreachable)) return false;
        }
    }

    return true;
}

fn validFunction(allocator: std.mem.Allocator, unit: *const ir.Function) Error!bool {
    const Input = std.meta.Child(function.Input);
    const Body = std.meta.Child(@FieldType(Input, "body"));

    const body: Body = .{
        .stores = columns.pointer(@FieldType(Body, "stores"), &unit.stores),
        .symbols = columns.pointer(@FieldType(Body, "symbols"), &unit.symbols),
        .expressions = columns.pointer(@FieldType(Body, "expressions"), &unit.expressions),
        .control = columns.pointer(@FieldType(Body, "control"), unit.body.control),
        .root = if (unit.body.root) |root| @backingInt(root) else null,
    };

    const input: Input = .{
        .body = &body,
        .contracts = columns.pointer(@FieldType(Input, "contracts"), &unit.contracts),
        .max_offset = std.math.maxInt(usize),
    };

    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [1024]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    return columns.invoke(function.executeValue, memory.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory => error.OutOfMemory,
        else => false,
    };
}
