const zx = @import("zx");
const ir = zx.ir;
const Analyzer = @import("analyzer.zig");
const Types = @import("types.zig");

pub fn analyze(owner: *Analyzer, source: []const zx.ast.Contract, input_type: ir.TypeId, exports: []const ir.Export) zx.Error![]const ir.Contract {
    if (source.len == 0) return &.{};

    const aliases = try owner.allocator.alloc(ir.Export, owner.types.aliases.len + exports.len);

    @memcpy(aliases[0..owner.types.aliases.len], owner.types.aliases);
    @memcpy(aliases[owner.types.aliases.len..], exports);

    const contracts = try owner.allocator.alloc(ir.Contract, source.len);

    for (source, contracts) |item, *contract| {
        var analyzer = Analyzer{
            .allocator = owner.allocator,
            .reporter = owner.reporter,
            .types = .{ .allocator = owner.allocator, .reporter = owner.reporter, .declarations = &.{}, .aliases = aliases },
        };

        try analyzer.types.items.appendSlice(owner.allocator, owner.types.items.items);

        _ = try analyzer.bind(.{ .text = "in", .span = item.span }, input_type, 0);

        if (item.kind == .ensures) _ = try analyzer.bind(.{ .text = "out", .span = item.span }, owner.output_type, 0);

        const predicate = try analyzer.expression(item.predicate, Types.scalarId(.bool));

        for (analyzer.nodes.items) |expression| {
            switch (expression.value) {
                .call, .store_get, .list_operation, .transform, .scope, .iteration, .list_update, .capture, .optional_value, .task, .await_task, .cancel_task, .parallel => return owner.reporter.fail(.contract, expression.span, "contracts cannot call functions, transform collections, capture errors, run tasks, unwrap optionals or access injected capabilities"),
                else => {},
            }
        }

        owner.types.items = analyzer.types.items;

        contract.* = .{
            .kind = item.kind,
            .symbols = try analyzer.symbols.toOwnedSlice(owner.allocator),
            .expressions = try analyzer.nodes.toOwnedSlice(owner.allocator),
            .predicate = predicate,
            .span = item.span,
        };
    }

    return contracts;
}
