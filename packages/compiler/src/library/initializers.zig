const std = @import("std");
const frontend = @import("frontend");
const ir = @import("zx").ir;
const model = @import("root.zig");
const artifact = frontend.project.artifact;
const Types = artifact.type_link.Table;
const Entry = frontend.project.compiled.StoreInitializer;
const Self = @This();
pub const Error = Types.Error || artifact.Error || error{ InvalidInitializer, ConflictingInitializer };

allocator: std.mem.Allocator,
scratch: std.mem.Allocator,
types: *Types,
functions: *ir.FunctionStorage,
items: std.ArrayList(Entry) = .empty,
pub fn append(self: *Self, value: Entry) Error!void {
    for (self.items.items) |previous| {
        if (!std.mem.eql(u8, previous.identity, value.identity)) continue;
        if (previous.schema_version != value.schema_version) return error.ConflictingInitializer;

        const left = try std.json.Stringify.valueAlloc(self.scratch, self.functions.at(@backingInt(previous.function)), .{});
        const right = try std.json.Stringify.valueAlloc(self.scratch, self.functions.at(@backingInt(value.function)), .{});

        if (!std.mem.eql(u8, left, right)) return error.ConflictingInitializer;

        return;
    }

    var copied = value;
    copied.identity = try self.allocator.dupe(u8, value.identity);

    try self.items.append(self.allocator, copied);
}

pub fn source(self: *Self, initial: model.Initializer, origins: @FieldType(frontend.AnalysisResult, "nominal_types")) Error!void {
    const program = initial.program;

    if (program.type_only or program.functions.count() != 0 or program.native_modules.len != 0 or program.stores.count() != 0 or program.contracts.len != 0) return error.InvalidInitializer;
    if (try frontend.validateIr(self.scratch, program) != null) return error.InvalidInitializer;
    if (program.typeOf(program.input_type) != .scalar or program.typeOf(program.input_type).scalar != .void or program.typeOf(program.output_type) != .object) return error.InvalidInitializer;

    const mapping = try self.types.appendFrom(self.scratch, program.types, origins, 0);
    var nodes = frontend.ArtifactNodes{ .allocator = self.allocator, .types = .{ .mapped = mapping }, .functions = &.{}, .native_modules = &.{} };
    const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

    try self.functions.append(self.allocator, try nodes.function(.{
        .file_name = initial.identity,
        .input_type = program.input_type,
        .output_type = program.output_type,
        .output_ownership = program.output_ownership,
        .symbols = program.symbols,
        .expressions = program.expressions,
        .body = program.body,
    }));

    const count = self.items.items.len;

    try self.append(.{ .identity = initial.identity, .schema_version = initial.schema_version, .function = id });
    if (self.items.items.len == count) _ = self.functions.pop(self.allocator);
}
