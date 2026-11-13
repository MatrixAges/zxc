const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const columns = zx.columns;
const Artifact = @import("../artifact/model.zig");
const FunctionImport = @import("../function_import.zig");
const generated = @import("generated_semantic_cache_admit");
const Input = std.meta.Child(generated.Input);
const Header = child("header");
const Function = child("function_body");
const Bindings = std.meta.Child(@FieldType(Input, "bindings"));
const Row = std.meta.Child(std.meta.Elem(@FieldType(Bindings, "bindings")));
const batch_size = @import("../package_scope.zig").lookup_batch_size;
const Error = std.mem.Allocator.Error;

fn child(comptime field: []const u8) type {
    return std.meta.Child(@typeInfo(@FieldType(Input, field)).optional.child);
}

pub fn validate(allocator: std.mem.Allocator, module: *const Artifact.Module, expected: ?[]const u8) Error!bool {
    var arena = std.heap.ArenaAllocator.init(allocator);
    var buffer: [2048]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, arena.allocator());

    defer arena.deinit();

    const temporary = scratch.allocator();
    const Tables = std.meta.Child(@FieldType(Header, "tables"));
    const signatures = columns.columns(std.meta.Child(@FieldType(Tables, "signatures")), module.functions);
    const natives = columns.columns(std.meta.Child(@FieldType(Tables, "modules")), module.native_modules);
    const stores = columns.columns(std.meta.Child(@FieldType(Tables, "stores")), module.stores);
    const tables: Tables = .{ .signatures = &signatures, .modules = &natives, .stores = &stores };
    const Type = std.meta.Child(@FieldType(Header, "types"));
    const types = ir.TypeTable.borrow(Type, module.types);
    const empty = ir.TypeTable.borrow(Type, .{});
    const Constants = std.meta.Child(@typeInfo(@FieldType(Header, "constants")).optional.child);
    const TypeTables = std.meta.Child(@FieldType(Constants, "types"));
    const Values = std.meta.Child(@typeInfo(@FieldType(Constants, "imports")).optional.child);
    const type_tables: TypeTables = .{ .base = &types, .delta = &empty };
    const marshal = @import("../../analysis/constants/input.zig").marshal;

    const values: Constants = .{
        .types = &type_tables,
        .exports = try marshal(Values, temporary, module.constant_exports),
        .imports = try marshal(Values, temporary, module.constant_imports),
    };

    const header: Header = .{
        .tables = &tables,
        .types = &types,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
        .constants = if (values.exports != null or values.imports != null) &values else null,
    };

    const Body = std.meta.Child(@FieldType(Function, "body"));
    var body: Body = undefined;
    var function: Function = undefined;

    if (module.function) |*unit| {
        body = .{
            .stores = columns.pointer(@FieldType(Body, "stores"), &unit.stores),
            .symbols = columns.pointer(@FieldType(Body, "symbols"), &unit.symbols),
            .expressions = columns.pointer(@FieldType(Body, "expressions"), &unit.expressions),
            .control = columns.pointer(@FieldType(Body, "control"), unit.body.control),
            .root = if (unit.body.root) |root| @backingInt(root) else null,
        };

        function = .{
            .body = &body,
            .contracts = columns.pointer(@FieldType(Function, "contracts"), &unit.contracts),
            .max_offset = std.math.maxInt(usize),
        };
    }

    const walk: Walk = .{
        .temporary = temporary,
        .input_types = module.functions.input_types,
        .output_types = module.functions.output_types,
        .path = module.path,
        .expected = expected,
        .header = &header,
        .function = if (module.function != null) &function else null,
    };

    return walk.check(module.function_imports, module.members);
}

const Walk = struct {
    temporary: std.mem.Allocator,
    input_types: []const u32,
    output_types: []const u32,
    path: []const u8,
    expected: ?[]const u8,
    header: *const Header,
    function: ?*const Function,
    fn check(self: Walk, imports: []const FunctionImport, members: []const FunctionImport) Error!bool {
        var rows: [batch_size]Row = undefined;
        var pointers: [batch_size]*const Row = undefined;
        const sets = [_][]const FunctionImport{ imports, members };
        const first_set: usize = if (imports.len != 0) 0 else 1;
        var first = true;

        for (sets[first_set..], first_set..) |bindings, set| {
            var offset: usize = 0;

            while (true) {
                const end = offset + @min(rows.len, bindings.len - offset);
                const count = end - offset;

                for (bindings[offset..end], rows[0..count], pointers[0..count]) |*source, *row, *pointer| {
                    row.* = source.borrow(Row);
                    pointer.* = row;
                }

                const finished = end == bindings.len;
                const last = finished and (set == sets.len - 1 or members.len == 0);

                const batch: Bindings = .{
                    .bindings = pointers[0..count],
                    .input_types = self.input_types,
                    .output_types = self.output_types,
                };

                const input: Input = .{
                    .path = self.path,
                    .expected_path = self.expected,
                    .header = if (first) self.header else null,
                    .bindings = &batch,
                    .function_body = if (last) self.function else null,
                };

                const valid = columns.invoke(generated.executeValue, self.temporary, &input) catch |err| switch (@as(anyerror, err)) {
                    error.OutOfMemory => return error.OutOfMemory,
                    else => false,
                };

                if (!valid or last) return valid;
                if (finished) break;

                first = false;
                offset = end;
            }

            first = false;
        }

        unreachable;
    }
};
