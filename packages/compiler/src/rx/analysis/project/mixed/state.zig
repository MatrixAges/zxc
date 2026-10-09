const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const ir = @import("zx").ir;
const target = @import("../../call/target.zig");
const SourceGraph = @import("../source_graph.zig").Graph;
const Types = frontend.project.artifact.type_link.Table;
const Source = frontend.project.artifact.source_link;
const Self = @This();
pub const Error = std.mem.Allocator.Error || error{InvalidSourceGraph};

allocator: std.mem.Allocator,
scratch: std.heap.ArenaAllocator,
options: frontend.project.Options,
graph: SourceGraph,
signatures: frontend.project.signature_project.Data,
types: Types,
functions: ir.FunctionStorage = .{},
native_modules: ir.NativeModuleStorage = .{},
initializers: std.ArrayList(frontend.project.compiled.StoreInitializer) = .empty,
libraries: std.AutoHashMapUnmanaged(usize, []const frontend.project.compiled.Export) = .empty,
finished: []?Source.Loaded,
owner: usize = 0,
issue: ?target.Diagnostic = null,
pub fn init(allocator: std.mem.Allocator, graph: SourceGraph, signatures: frontend.project.signature_project.Data, types: ir.TypeTable, options: frontend.project.Options) Error!Self {
    var self = Self{
        .allocator = allocator,
        .scratch = std.heap.ArenaAllocator.init(allocator),
        .options = options,
        .graph = graph,
        .signatures = signatures,
        .types = .{ .allocator = allocator, .items = try frontend.type_table.storage(allocator, types), .origins = .{ .allocator = allocator } },
        .native_modules = try frontend.native_context.storage(allocator, options.context.native_modules),
        .finished = try allocator.alloc(?Source.Loaded, graph.modules.len),
    };

    @memset(self.finished, null);

    self.types.origins.seed(self.types.items.view(), options.context.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return error.InvalidSourceGraph;
    };

    for (0..signatures.functions.count()) |index| try self.functions.append(allocator, signatures.functions.at(index));
    for (signatures.libraries) |library| try self.libraries.put(allocator, library.index, library.exports);
    try self.initializers.appendSlice(allocator, signatures.store_initializers);

    return self;
}

pub fn destination(self: *Self) frontend.project.artifact.program_link.Destination {
    return .{ .allocator = self.allocator, .temporary = self.allocator, .types = &self.types, .functions = &self.functions, .native_modules = &self.native_modules };
}

pub fn signature(self: *const Self, index: usize) ?frontend.project.signature_project.Module {
    for (self.signatures.modules) |module| {
        if (std.mem.eql(u8, module.path, self.graph.modules[index].path)) return module;
    }

    return null;
}

pub fn fail(self: *Self, location: rx.ast.Location, message: []const u8) Error {
    self.issue = .{ .path = self.graph.modules[self.owner].path, .location = location, .code = "module", .message = try self.allocator.dupe(u8, message) };

    return error.InvalidSourceGraph;
}
