const std = @import("std");
const ir = @import("zx").ir;
const Names = @import("genz").zx.modules.Names;
const Hash = std.crypto.hash.sha2.Sha256;
const Self = @This();
pub const Unit = @import("genz").zx.modules.Unit;

hash: Hash = .init(.{}),
program: ir.Program,
names: Names,
value_functions: []const bool,
pure_functions: []const bool,
local_functions: []const bool,
uniqueness: @import("genz").zx.function_analysis.Uniqueness.Result,
state_plan: @import("genz").zx.state_value.Analysis,
pub fn createAnalyzed(allocator: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit, facts: @import("genz").zx.modules.Analysis) std.mem.Allocator.Error![32]u8 {
    var self = Self{
        .program = program,
        .names = names,
        .value_functions = facts.value.values,
        .pure_functions = facts.value.pure,
        .local_functions = facts.value.local,
        .uniqueness = facts.uniqueness,
        .state_plan = facts.value.state,
    };

    return self.finish(allocator, unit);
}

fn finish(self: *Self, allocator: std.mem.Allocator, unit: Unit) std.mem.Allocator.Error![32]u8 {
    const program = self.program;
    const names = self.names;
    const value_functions = self.value_functions;
    const state_plan = self.state_plan;

    self.bytes("zxc.zig.input.v43");
    self.bytes(@tagName(unit));
    self.write(program.version);

    if (unit == .entry) self.write(try @import("genz").zx.tasks.required(allocator, program));

    switch (unit) {
        .function => |id| {
            self.write(value_functions[@backingInt(id)]);
            self.plan(self.uniqueness.functions[@backingInt(id)]);
            self.write(program.functions.at(@backingInt(id)));
        },
        .entry => {
            self.plan(self.uniqueness.entry);
            self.write(.{
                .file_name = program.file_name,
                .input_type = program.input_type,
                .output_type = program.output_type,
                .symbols = program.symbols,
                .expressions = program.expressions,
                .body = program.body,
                .exports = program.exports,
                .contracts = program.contracts,
                .stores = program.stores,
                .store_mode = program.store_mode,
                .type_only = program.type_only,
            });
        },
        .types => {
            self.write(state_plan.keys.len);

            for (state_plan.keys) |key| self.hash.update(&key);

            self.write(names.types);
            self.write(program.types);
            self.write(program.native_modules);

            var count: usize = 0;

            for (0..program.functions.count()) |function_row| {
                const function = program.functions.at(function_row);

                if (function.external != null) {
                    count += 1;
                }
            }

            self.write(count);

            for (0..program.functions.count()) |function_row| {
                const function = program.functions.at(function_row);

                if (function.external) |external| {
                    self.write(.{ .input_type = function.input_type, .output_type = function.output_type, .external = external });
                }
            }
        },
    }

    var result: [32]u8 = undefined;

    self.hash.final(&result);

    return result;
}

fn plan(self: *Self, value: @import("genz").zx.function_analysis.Uniqueness.Plan) void {
    self.hash.update(std.mem.sliceAsBytes(value.flags));
    self.write(value.renewals.len);

    for (value.renewals) |renewal| {
        self.write(@backingInt(renewal.owner));
        self.write(renewal.path);
    }
}

fn write(self: *Self, value: anytype) void {
    const T = @TypeOf(value);

    if (T == @FieldType(ir.ExpressionRow, "span")) return;
    if (T == ir.ControlBody) return self.write(value.block());

    if (T == ir.Block or T == @FieldType(ir.StatementRow, "parallel") or T == @FieldType(@FieldType(ir.StatementRow, "destructure"), "symbols") or T == @FieldType(@FieldType(ir.StatementRow, "switch_stmt"), "cases")) {
        self.write(value.len);

        for (0..value.len) |index| self.write(value.at(index));

        return;
    }

    if (T == ir.ExpressionTable or T == ir.SymbolTable or T == ir.ContractTable or T == ir.NativeModuleTable or T == ir.NativeBindings) {
        self.write(value.count());

        for (0..value.count()) |index| self.write(value.at(index));

        return;
    }

    if (T == ir.TypeId) {
        self.bytes(self.names.types[@backingInt(value)]);
        self.hash.update(&self.state_plan.keys[@backingInt(value)]);

        return;
    }

    if (T == ir.FunctionId) {
        self.bytes(self.names.functions[@backingInt(value)]);
        self.write(self.program.functions.at(@backingInt(value)).stores);
        self.write(self.value_functions[@backingInt(value)]);
        self.write(self.pure_functions[@backingInt(value)]);
        self.write(self.local_functions[@backingInt(value)]);

        const function = self.program.functions.at(@backingInt(value));

        self.write(function.input_type);
        self.write(function.output_type);
        self.write(!@import("genz").zx.value_call.containsDescendant(self.program, function.output_type, function.input_type));

        return;
    }

    if (T == ir.NativeModuleId) {
        const module = self.program.native_modules.at(@backingInt(value));

        return self.write(.{ .specifier = module.specifier, .identity = module.identity, .import_name = module.import_name, .type_namespace = module.type_namespace });
    }

    switch (@typeInfo(T)) {
        .@"struct" => |info| inline for (info.field_names) |field| {
            self.bytes(field);
            self.write(@field(value, field));
        },
        .@"union" => |info| {
            self.bytes(@tagName(value));

            inline for (info.field_names) |field| if (std.mem.eql(u8, @tagName(value), field)) {
                self.write(@field(value, field));
            };
        },
        .@"enum" => self.write(@backingInt(value)),
        .optional => {
            self.write(value != null);

            if (value) |child| self.write(child);
        },
        .pointer => |info| {
            if (info.size != .slice) @compileError("generation fingerprints require value data");
            if (info.child == u8) return self.bytes(value);

            self.write(value.len);

            for (value) |item| self.write(item);
        },
        .bool => self.hash.update(&.{@intFromBool(value)}),
        .int => |info| {
            const Wide = if (info.signedness == .signed) i64 else u64;
            var encoded: [8]u8 = undefined;

            std.mem.writeInt(u64, &encoded, @bitCast(@as(Wide, value)), .little);
            self.hash.update(&encoded);
        },
        .float => self.write(@as(@Int(.unsigned, @bitSizeOf(T)), @bitCast(value))),
        .void => {},
        else => @compileError("unsupported generation fingerprint field"),
    }
}

fn bytes(self: *Self, value: []const u8) void {
    self.write(value.len);
    self.hash.update(value);
}
