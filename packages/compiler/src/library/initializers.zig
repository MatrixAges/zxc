const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
const artifact = frontend.project.artifact;
const Types = artifact.type_link.Table;
const Entry = frontend.project.compiled.StoreInitializer;
const Index = @import("index.zig");
const equality = @import("initializers/function_equal.zig");
const generated = @import("parser_options").generated_parser;
const Self = @This();
pub const Error = Types.Error || artifact.Error || error{ InvalidInitializer, ConflictingInitializer };

allocator: std.mem.Allocator,
scratch: std.mem.Allocator,
types: *Types,
functions: *ir.FunctionStorage,
items: std.ArrayList(Entry) = .empty,
index: Index = .{},
pub fn append(self: *Self, value: Entry) Error!void {
    if (try self.register(value.identity)) |previous| {
        const left = self.functions.at(@backingInt(previous.function));
        const right = self.functions.at(@backingInt(value.function));

        if (!equality.matches(&left, &right, previous.schema_version, value.schema_version, null)) return error.ConflictingInitializer;

        return;
    }

    try self.publish(value);
}

fn register(self: *Self, identity: []const u8) Error!?Entry {
    const row = (try self.index.register(self.scratch, identity, self.items.items.len)) orelse return null;

    return self.items.items[row];
}

fn publish(self: *Self, value: Entry) Error!void {
    var copied = value;
    copied.identity = try self.allocator.dupe(u8, value.identity);

    try self.items.append(self.allocator, copied);
}

pub fn source(self: *Self, initial: model.Initializer, origins: @FieldType(frontend.AnalysisResult, "nominal_types")) Error!void {
    const program = initial.program;

    if (!try valid(self.scratch, program)) return error.InvalidInitializer;

    const mapping = try self.types.appendFrom(self.scratch, program.types, origins, 0);

    const candidate: ir.Function = .{
        .file_name = initial.identity,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .output_ownership = program.output_ownership,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
    };

    if (try self.register(initial.identity)) |previous| {
        const linked = self.functions.at(@backingInt(previous.function));

        if (!equality.matches(&linked, &candidate, previous.schema_version, initial.schema_version, mapping)) return error.ConflictingInitializer;

        return;
    }

    var nodes = frontend.ArtifactNodes{ .allocator = self.allocator, .types = .{ .mapped = mapping }, .functions = .{ .indexed = &.{} }, .native_modules = .{ .indexed = &.{} } };
    const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

    try self.functions.append(self.allocator, try nodes.function(candidate));
    try self.publish(.{ .identity = initial.identity, .schema_version = initial.schema_version, .function = id });
}

fn valid(scratch: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (generated) return @import("../backends/zig/store_initializers/validation.zig").validate(scratch, program, .forbidden);
    if (program.type_only or program.functions.count() != 0 or program.native_modules.count() != 0 or program.stores.count() != 0 or program.contracts.count() != 0) return false;
    if (try frontend.validateIr(scratch, program) != null) return false;

    return program.typeOf(program.input_type) == .scalar and
        program.typeOf(program.input_type).scalar == .void and
        program.typeOf(program.output_type) == .object;
}
