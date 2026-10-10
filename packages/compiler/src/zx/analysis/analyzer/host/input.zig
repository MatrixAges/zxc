const std = @import("std");
const ir = @import("zx").ir;
const Context = @import("context.zig");
const Origins = @import("../../../modules/nominal_origins.zig");
const bindings = @import("bindings.zig");
const model = @import("model.zig");
const Self = @This();

types: model.Types,
aliases: model.Aliases,
origins: model.Origins,
origin: model.Origin,
functions: model.Functions,
complete_functions: model.CompleteFunctions,
native_modules: model.NativeModules,
imports: model.FunctionImports,
stores: model.StoreBindings,
pub fn init(allocator: std.mem.Allocator, analyzer: *const Context) std.mem.Allocator.Error!Self {
    const origin = analyzer.origin;

    return .{
        .types = ir.TypeTable.borrow(model.Types, analyzer.base_types),
        .aliases = try bindings.aliases(allocator, analyzer.aliases),
        .origins = Origins.Table.borrow(model.Origins, analyzer.base_origins),
        .origin = .{
            .kind = switch (origin) {
                .source => 0,
                .native => 1,
                .external => 2,
            },
            .owner = switch (origin) {
                .source, .native => |name| name,
                .external => |value| value.module,
            },
            .member = if (origin == .external) origin.external.member else "",
        },
        .functions = @import("../../../ir/canonical/functions/input.zig").view(model.Functions, analyzer.functions),
        .complete_functions = @import("../../../ir/canonical/functions/input.zig").view(model.CompleteFunctions, analyzer.functions),
        .native_modules = @import("../../../ir/canonical/borrow.zig").columns(model.NativeModules, analyzer.native_modules),
        .imports = try bindings.imports(allocator, analyzer.function_imports),
        .stores = try bindings.stores(allocator, analyzer.store_bindings),
    };
}

pub fn context(self: *const Self, analyzer: *const Context) model.Context {
    return .{
        .mode = switch (analyzer.mode) {
            .standalone => .Standalone,
            .resolved => .Resolved,
            .project => .Project,
        },
        .type_base = &self.types,
        .aliases = &self.aliases,
        .nominal_base = &self.origins,
        .nominal_names = analyzer.base_origins.names,
        .nominal_origin = &self.origin,
        .shared = true,
        .function_imports = &self.imports,
        .functions = &self.functions,
        .complete_functions = &self.complete_functions,
        .native_modules = &self.native_modules,
        .scalar_count = std.enums.values(ir.Scalar).len,
        .maximum_count = std.math.maxInt(u32),
        .store_bindings = &self.stores,
        .store_type_count = analyzer.store_type_count,
    };
}
