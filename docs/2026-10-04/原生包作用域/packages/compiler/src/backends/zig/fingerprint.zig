const std = @import("std");
const ir = @import("zx").ir;
const Names = @import("genz").zx.modules.Names;
const Hash = std.crypto.hash.sha2.Sha256;
const Self = @This();
pub const Unit = union(enum) { entry, function: ir.FunctionId, types };

hash: Hash = .init(.{}),
program: ir.Program,
names: Names,
pub fn create(program: ir.Program, names: Names, unit: Unit) [32]u8 {
    var self = Self{ .program = program, .names = names };

    self.bytes("zxc.zig.input.v1");
    self.bytes(@tagName(unit));
    self.write(program.version);

    switch (unit) {
        .function => |id| self.write(program.functions[@intFromEnum(id)]),
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
            .contexts = program.contexts,
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

    if (T == ir.TypeId) return self.bytes(self.names.types[@intFromEnum(value)]);
    if (T == ir.FunctionId) return self.bytes(self.names.functions[@intFromEnum(value)]);

    if (T == ir.NativeModuleId) {
        const module = self.program.native_modules[@intFromEnum(value)];

        return self.write(.{ .specifier = module.specifier, .identity = module.identity, .import_name = module.import_name, .type_namespace = module.type_namespace });
    }

    switch (@typeInfo(T)) {
        .@"struct" => |info| inline for (info.fields) |field| {
            self.bytes(field.name);
            self.write(@field(value, field.name));
        },
        .@"union" => |info| {
            self.bytes(@tagName(value));

            inline for (info.fields) |field| if (std.mem.eql(u8, @tagName(value), field.name)) {
                self.write(@field(value, field.name));
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
        .float => self.write(@as(std.meta.Int(.unsigned, @bitSizeOf(T)), @bitCast(value))),
        .void => {},
        else => @compileError("unsupported generation fingerprint field"),
    }
}

fn bytes(self: *Self, value: []const u8) void {
    self.write(value.len);
    self.hash.update(value);
}
