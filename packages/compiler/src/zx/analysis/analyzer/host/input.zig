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
imports: model.FunctionImports,
stores: model.StoreBindings,
pub fn init(allocator: std.mem.Allocator, analyzer: *const Context) std.mem.Allocator.Error!Self {
    const origin = analyzer.origin;

    return .{
        .types = ir.TypeTable.borrow(model.Types, analyzer.types.view()),
        .aliases = try bindings.aliases(allocator, analyzer.aliases),
        .origins = Origins.Table.borrow(model.Origins, analyzer.origins.items.view()),
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
        .imports = try bindings.imports(allocator, analyzer.function_imports),
        .stores = try bindings.stores(allocator, analyzer.store_bindings),
    };
}

pub fn context(self: *const Self, analyzer: *const Context) model.Context {
    return .{
        .type_base = &self.types,
        .aliases = &self.aliases,
        .nominal_base = &self.origins,
        .nominal_origin = &self.origin,
        .shared = true,
        .function_imports = &self.imports,
        .functions = &self.functions,
        .store_bindings = &self.stores,
        .store_type_count = analyzer.store_type_count,
    };
}
