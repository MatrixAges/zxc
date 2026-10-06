from pathlib import Path

def edit(name, pairs):
 p=Path('packages/compiler/src')/name;s=p.read_text()
 for old,new in pairs:
  assert old in s,(name,old)
  s=s.replace(old,new)
 d=Path('docs/2026-10-06/统一语义类型表/草稿/compiler')/name;d.parent.mkdir(parents=True,exist_ok=True);d.write_text(s);p.write_text(s)

edit('zx/analysis/expression.zig', [('pub const Options = struct { types: ir.TypeTable = .{},', 'pub const Options = struct { types: ir.TypeTable = .{}, native_modules: []const ir.NativeModule = &.{},')])
edit('zx/analysis/expression_program.zig', [('        .types = try analyzer.types.items.finish(allocator),','        .types = try analyzer.types.items.finish(allocator),\n        .native_modules = try @import("../modules/native_context.zig").copy(allocator, options.native_modules),')])
edit('rx/analysis/flow_compile.zig', [('types: zx.ir.TypeTable,','types: zx.ir.TypeTable,\nnative_modules: []const zx.ir.NativeModule = &.{},'), ('.{ .types = self.types, .bindings = self.bindings.items,', '.{ .types = self.types, .native_modules = self.native_modules, .bindings = self.bindings.items,')])
edit('rx/analysis/module_compile.zig', [('        .types = options.types,','        .types = options.types,\n        .native_modules = options.native_modules,')])
edit('rx/analysis/parallel_task.zig', [('.types = types.items.view(), .output_type = output_type.?', '.types = types.items.view(), .native_modules = parent.native_modules, .output_type = output_type.?'), ('.merge(allocator, nested.calls.items, parent.types)', '.merge(allocator, nested.calls.items, parent.types, parent.native_modules)')])
edit('rx/analysis/call.zig', [('        const argument = try @import("call/unit.zig").create(allocator, config.owner, callee.types, config.call.location);','        var argument = try @import("call/unit.zig").create(allocator, config.owner, callee.types, config.call.location);\n        argument.native_modules = callee.native_modules;'), ('.{ .types = callee.types, .bindings = options.bindings,', '.{ .types = callee.types, .native_modules = callee.native_modules, .bindings = options.bindings,')])
edit('rx/analysis/store.zig', [('nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types") = .{} };','nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types") = .{}, native_modules: []const zx.ir.NativeModule = &.{} };'), ('.{ .types = types, .nominal_types = options.nominal_types }', '.{ .types = types, .nominal_types = options.nominal_types, .native_modules = options.native_modules }'), ('.{ .types = types, .expected = resolved.resolved.id }', '.{ .types = types, .native_modules = options.native_modules, .expected = resolved.resolved.id }'), ('initializer.build(allocator, path, fields.items, types, &reporter)', 'initializer.build(allocator, path, fields.items, types, options.native_modules, &reporter)')])
edit('rx/analysis/store/registry.zig', [('.nominal_types = shared.nominal_types }', '.nominal_types = shared.nominal_types, .native_modules = shared.native_modules }')])
edit('rx/analysis/store/initializer.zig', [('types: zx.ir.TypeTable, reporter:', 'types: zx.ir.TypeTable, native_modules: []const zx.ir.NativeModule, reporter:'), ('    var builder = Builder{ .allocator = allocator, .types = table.items.view(), .native_modules = &.{} };', '    const owned_modules = try frontend.native_context.copy(allocator, native_modules);\n    var builder = Builder{ .allocator = allocator, .types = table.items.view(), .native_modules = owned_modules };'), ('        .types = table.items.view(),','        .types = table.items.view(),\n        .native_modules = owned_modules,')])
edit('rx/analysis/project.zig', [('        for (objects) |*object| object.initial.types = result.contract.types;', '''        for (objects) |*object| {
            object.initial.types = result.contract.types;
            object.initial.native_modules = result.contract.native_modules;
        }''')])
