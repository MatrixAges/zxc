const std = @import("std");
const ir = @import("zx").ir;
const Names = @import("genz").zx.modules.Names;
const Hash = std.crypto.hash.sha2.Sha256;
const Self = @This();
pub const Unit = union(enum) { entry, function: ir.FunctionId, types };

hash: Hash = .init(.{}),
program: ir.Program,
names: Names,
value_functions: []const bool,
buffer_functions: []const []const @import("genz").zx.buffer_call.Lane,
pub fn create(allocator: std.mem.Allocator, program: ir.Program, names: Names, unit: Unit) std.mem.Allocator.Error![32]u8 {
    const value_functions = try @import("genz").zx.value_call.functions(allocator, program);

    defer allocator.free(value_functions);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const buffer_functions = try @import("genz").zx.buffer_call.analysis.functions(arena.allocator(), program, value_functions);
    var self = Self{ .program = program, .names = names, .value_functions = value_functions, .buffer_functions = buffer_functions };

    self.bytes("zxc.zig.input.v5");
    self.bytes(@tagName(unit));
    self.write(program.version);

    switch (unit) {
        .function => |id| {
            self.write(value_functions[@intFromEnum(id)]);
            self.write(buffer_functions[@intFromEnum(id)]);
            self.write(program.functions[@intFromEnum(id)]);
        },
        .entry => self.write(.{
            .consumes_input = program.consumes_input,
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
            self.write(names.types);
            self.write(program.types);
            self.write(program.native_modules);

            var count: usize = 0;

            for (program.functions) |function| if (function.external != null) {
                count += 1;
            };

            self.write(count);

            for (program.functions) |function| if (function.external) |external| {
                self.write(.{ .input_type = function.input_type, .output_type = function.output_type, .external = external });
            };
        },
    }

    var result: [32]u8 = undefined;

    self.hash.final(&result);

    return result;
}

fn write(self: *Self, value: anytype) void {
    const T = @TypeOf(value);

    if (T == @FieldType(ir.Expression, "span")) return;
    if (T == ir.TypeId) return self.bytes(self.names.types[@intFromEnum(value)]);

    if (T == ir.FunctionId) {
        self.bytes(self.names.functions[@intFromEnum(value)]);
        self.write(self.program.functions[@intFromEnum(value)].stores);
        self.write(self.value_functions[@intFromEnum(value)]);
        self.write(self.buffer_functions[@intFromEnum(value)]);

        const function = self.program.functions[@intFromEnum(value)];

        self.write(!@import("genz").zx.value_call.containsDescendant(self.program, function.output_type, function.input_type));

        return;
    }

    if (T == ir.NativeModuleId) {
        const module = self.program.native_modules[@intFromEnum(value)];

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
        .@"enum" => self.write(@intFromEnum(value)),
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
