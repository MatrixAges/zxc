const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const borrow = @import("../borrow.zig");

pub fn Storage(comptime Input: type) type {
    const Context = std.meta.Child(@FieldType(Input, "context"));
    const Unit = std.meta.Child(@FieldType(Input, "unit"));
    const Body = std.meta.Child(@FieldType(Unit, "body"));

    return struct {
        const Self = @This();

        table: std.meta.Child(@FieldType(Context, "table")),
        functions: std.meta.Child(@FieldType(Context, "functions")),
        body: Body,
        context: Context,
        unit: Unit,
        input: Input,
        pub fn init(self: *Self, allocator: std.mem.Allocator, program: *const ir.Program) std.mem.Allocator.Error!void {
            self.table = ir.TypeTable.borrow(@TypeOf(self.table), program.types);
            self.functions = @import("../functions/input.zig").view(@TypeOf(self.functions), program.functions);

            self.context = .{
                .table = &self.table,
                .functions = &self.functions,
                .modules = borrow.pointer(@FieldType(Context, "modules"), &program.native_modules),
                .max_offset = std.math.maxInt(usize),
                .scalar_count = std.enums.values(ir.Scalar).len,
                .maximum_count = std.math.maxInt(u32),
            };

            self.body = .{
                .stores = borrow.pointer(@FieldType(Body, "stores"), &program.stores),
                .symbols = borrow.pointer(@FieldType(Body, "symbols"), &program.symbols),
                .expressions = borrow.pointer(@FieldType(Body, "expressions"), &program.expressions),
                .control = borrow.pointer(@FieldType(Body, "control"), program.body.control),
                .root = if (program.body.root) |root| @backingInt(root) else null,
            };

            self.unit = .{
                .body = &self.body,
                .contracts = borrow.pointer(@FieldType(Unit, "contracts"), &program.contracts),
                .input_type = @backingInt(program.input_type),
                .output_type = @backingInt(program.output_type),
                .output_ownership = switch (program.output_ownership) {
                    .copy => .Copy,
                    .borrowed => .Borrowed,
                    .owned => .Owned,
                },
                .transaction = program.store_mode == .transaction,
                .type_only = program.type_only,
            };

            const names = try allocator.alloc([]const u8, program.exports.len);
            const ids = try allocator.alloc(u32, program.exports.len);

            for (program.exports, names, ids) |exported, *name, *id| {
                name.* = exported.name;
                id.* = @backingInt(exported.type_id);
            }

            self.input = .{
                .version = program.version,
                .expected_version = zx.ir_version,
                .context = &self.context,
                .unit = &self.unit,
                .export_names = names,
                .export_types = ids,
            };
        }
    };
}
