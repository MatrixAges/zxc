const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const target = @import("call/target.zig");
const SourceMap = @import("source_map.zig");

pub const Options = struct {
    owner: []const u8,
    module: rx.ast.Node,
    sources: []const frontend.project.Source,
    stores: []const rx.ModuleSource = &.{},
    project: frontend.project.Options = .{ .entry = "" },
};

pub const Call = struct { store_initializers: @FieldType(frontend.AnalysisResult, "store_initializers") = &.{}, getters: []const @import("store.zig").Binding = &.{}, callee: zx.ir.Program, argument: zx.ir.Program, input_omitted: bool = false, out: ?[]const u8 };

pub const Contract = struct {
    store_initializers: @FieldType(frontend.AnalysisResult, "store_initializers") = &.{},
    store_definitions: []const @import("store.zig").Definition = &.{},
    program: zx.ir.Program,
    types: zx.ir.TypeTable,
    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    calls: []const Call,
    result: ?zx.ir.Program,
    native_modules: []const zx.ir.NativeModule,
};

pub const Value = union(enum) { contract: Contract, diagnostic: target.Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub const Loaded = struct { getters: []const @import("store.zig").Binding = &.{}, node: rx.ast.Node, function: target.Function };
pub const Binding = struct { name: []const u8, type_id: zx.ir.TypeId };

pub fn infer(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    const sources = [_]rx.ModuleSource{.{ .path = options.owner, .node = options.module }};

    return @import("project.zig").infer(allocator, .{ .entry = options.owner, .modules = &sources, .stores = options.stores, .sources = options.sources, .project = options.project });
}

pub fn locate(node: rx.ast.Node, offset: usize) ?rx.ast.Location {
    return SourceMap.locateNode(node, offset);
}
