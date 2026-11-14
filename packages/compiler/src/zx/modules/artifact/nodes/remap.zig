const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const generated = @import("generated_artifact_remap");
const functions = @import("generated_artifact_function_remap");
const Nodes = @import("../nodes.zig");
const Error = @import("../model.zig").Error;
const Input = std.meta.Child(generated.Input);
const Mapping = std.meta.Child(@FieldType(Input, "type_mapping"));
const Output = @typeInfo(@TypeOf(generated.executeValue(undefined, undefined))).error_union.payload;
const FunctionInput = std.meta.Child(functions.Input);
const FunctionOutput = @typeInfo(@TypeOf(functions.executeValue(undefined, undefined))).error_union.payload;

pub fn columns(allocator: std.mem.Allocator, nodes: *const Nodes, types: []const u32, calls: []const u32) Error!Output {
    if (types.len == 0 and calls.len == 0) return .{ .types = &.{}, .functions = &.{} };

    const types_view = typeMapping(Mapping, nodes.types);
    const functions_view = idMapping(Mapping, nodes.functions);

    const input: Input = .{
        .types = types,
        .type_mapping = &types_view,
        .functions = calls,
        .function_mapping = &functions_view,
    };

    return zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| return failure(err);
}

pub fn function(nodes: *const Nodes, value: *const ir.Function, candidate: ?ir.FunctionId, structure: Nodes.Structure) Error!FunctionOutput {
    if (structure == .unchecked and !validFunctionColumns(value)) return error.InvalidModule;

    var view: FunctionView(FunctionInput) = undefined;

    view.init(nodes, value, candidate);

    return zx.columns.invoke(functions.executeValue, nodes.allocator, @as(*const FunctionInput, &view.input)) catch |err| return failure(err);
}

pub fn FunctionView(comptime T: type) type {
    const FunctionMapping = std.meta.Child(@FieldType(T, "types"));
    const Ports = std.meta.Child(@FieldType(T, "ports"));
    const Contracts = std.meta.Child(@FieldType(T, "contracts"));

    return struct {
        const Self = @This();
        types: FunctionMapping,
        functions: FunctionMapping,
        natives: FunctionMapping,
        ports: Ports,
        contracts: Contracts,
        input: T,
        pub fn init(self: *Self, nodes: *const Nodes, value: *const ir.Function, candidate: ?ir.FunctionId) void {
            self.types = typeMapping(FunctionMapping, nodes.types);
            self.functions = idMapping(FunctionMapping, nodes.functions);
            self.natives = idMapping(FunctionMapping, nodes.native_modules);
            self.contracts = zx.columns.columns(Contracts, value.contracts);

            self.ports = .{
                .input = @backingInt(value.input_type),
                .output = @backingInt(value.output_type),
                .native_module = if (value.external) |external| @backingInt(external.module) else null,
            };

            self.input = .{
                .types = &self.types,
                .functions = &self.functions,
                .natives = &self.natives,
                .ports = &self.ports,
                .contracts = &self.contracts,
                .symbols = value.symbols.types,
                .expressions = value.expressions.types,
                .calls = value.expressions.call_functions,
                .stores = value.stores.types,
                .candidate = if (candidate) |id| @backingInt(id) else null,
            };
        }
    };
}

pub fn validFunctionColumns(value: *const ir.Function) bool {
    if (!value.symbols.validStructure() or !value.expressions.validStructure() or !value.stores.validStructure() or !value.contracts.validStructure()) return false;

    for (value.contracts.symbols, value.contracts.expressions) |symbols, expressions| {
        if (!symbols.validStructure() or !expressions.validStructure()) return false;
    }

    return true;
}

pub fn typeMapping(comptime Target: type, mapping: Nodes.TypeMap) Target {
    return switch (mapping) {
        .collect => unreachable,
        .mapped => |ids| .{ .kind = .Dense, .dense = @ptrCast(ids), .sparse = &.{}, .planned = &.{}, .first = 0, .prefix = 0, .count = 0 },
        .planned => |ids| .{ .kind = .Planned, .dense = &.{}, .sparse = &.{}, .planned = ids, .first = 0, .prefix = 0, .count = 0 },
        .identity => |count| .{ .kind = .Range, .dense = &.{}, .sparse = &.{}, .planned = &.{}, .first = 0, .prefix = 0, .count = count },
    };
}

pub fn idMapping(comptime Target: type, mapping: anytype) Target {
    return switch (mapping) {
        .indexed => |ids| .{ .kind = .Sparse, .dense = &.{}, .sparse = @ptrCast(ids), .planned = &.{}, .first = 0, .prefix = 0, .count = 0 },
        .planned => |ids| .{ .kind = .Planned, .dense = &.{}, .sparse = &.{}, .planned = ids, .first = 0, .prefix = 0, .count = 0 },
        .range => |range| .{ .kind = .Range, .dense = &.{}, .sparse = &.{}, .planned = &.{}, .first = range.first, .prefix = range.prefix, .count = range.count },
    };
}

fn failure(err: anyerror) Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => error.InvalidModule,
    };
}
