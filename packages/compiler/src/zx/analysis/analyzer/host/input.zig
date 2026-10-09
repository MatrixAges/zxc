const std = @import("std");
const ir = @import("zx").ir;
const Analyzer = @import("../../analyzer.zig");
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
pub fn init(allocator: std.mem.Allocator, analyzer: *const Analyzer) std.mem.Allocator.Error!Self {
    const origin: Origins.Origin = if (analyzer.types.shared) |shared| shared.origin else .{ .source = "" };

    return .{
        .types = ir.TypeTable.borrow(model.Types, analyzer.types.items.view()),
        .aliases = try bindings.aliases(allocator, analyzer.types.aliases),
        .origins = Origins.Table.borrow(model.Origins, if (analyzer.types.shared) |shared| shared.origins.items.view() else .{}),
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

pub fn context(self: *const Self, analyzer: *const Analyzer) model.Context {
    return .{
        .type_base = &self.types,
        .aliases = &self.aliases,
        .nominal_base = &self.origins,
        .nominal_origin = &self.origin,
        .shared = analyzer.types.shared != null,
        .function_imports = &self.imports,
        .functions = &self.functions,
        .store_bindings = &self.stores,
        .store_type_count = analyzer.store_type_count,
    };
}
