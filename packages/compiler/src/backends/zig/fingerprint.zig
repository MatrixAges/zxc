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
buffer_functions: []const []const @import("genz").zx.buffer_call.Lane,
fresh_outputs: []const @import("genz").zx.buffer_call.fresh.Paths,
transfer_functions: []const []const @import("genz").zx.buffer_call.transfer_analysis.Capability,
state_plan: @import("genz").zx.state_value.Analysis,
pub fn create(allocator: std.mem.Allocator, source: ir.Program, names: Names, unit: Unit) std.mem.Allocator.Error![32]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    return createPrepared(allocator, try @import("genz").zx.prepare(arena.allocator(), source), names, unit);
}

pub fn createPrepared(allocator: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit) std.mem.Allocator.Error![32]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const facts = try @import("genz").zx.value_call.analysis.analyze(arena.allocator(), program);
    const value_functions = facts.values;
    const buffer_functions = try @import("genz").zx.buffer_call.analysis.functions(arena.allocator(), program, value_functions, facts.pure);
    const fresh_outputs = try @import("genz").zx.buffer_call.fresh.outputs(arena.allocator(), program, facts.pure);
    const transfer_functions = try @import("genz").zx.buffer_call.transfer_analysis.functions(arena.allocator(), program, buffer_functions, facts.pure);
    const state_plan = facts.state;
    var self = Self{ .program = program, .names = names, .value_functions = value_functions, .pure_functions = facts.pure, .local_functions = facts.local, .buffer_functions = buffer_functions, .fresh_outputs = fresh_outputs, .transfer_functions = transfer_functions, .state_plan = state_plan };

    self.bytes("zxc.zig.input.v42");
    self.bytes(@tagName(unit));
    self.write(program.version);

    if (unit == .entry) self.write(try @import("genz").zx.tasks.required(allocator, program));

    switch (unit) {
        .function => |id| {
            self.write(value_functions[@backingInt(id)]);
            self.write(buffer_functions[@backingInt(id)]);
            self.write(program.functions.at(@backingInt(id)));
        },
        .entry => self.write(.{
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
        }),
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
        self.write(self.buffer_functions[@backingInt(value)]);
        self.write(self.fresh_outputs[@backingInt(value)]);
        self.write(self.transfer_functions[@backingInt(value)]);

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
