from pathlib import Path

def save(name,s):
 p=Path(name);parts=p.parts[1:]
 if parts[1]=='src':parts=(parts[0],)+parts[2:]
 d=Path('docs/2026-10-06/统一语义类型表/草稿')/Path(*parts);d.parent.mkdir(parents=True,exist_ok=True);d.write_text(s);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s)

save('packages/compiler/src/zx/modules/native_context.zig','''const std = @import("std");
const ir = @import("zx").ir;

pub fn valid(types: ir.TypeTable, modules: []const ir.NativeModule) bool {
    return @import("../ir/native_modules.zig").validate(.{
        .file_name = "shared",
        .types = types,
        .native_modules = modules,
        .input_type = @fromBackingInt(0),
        .output_type = @fromBackingInt(0),
        .symbols = &.{},
        .expressions = &.{},
        .body = &.{},
        .type_only = true,
    });
}

pub fn copy(allocator: std.mem.Allocator, modules: []const ir.NativeModule) std.mem.Allocator.Error![]ir.NativeModule {
    const result = try allocator.dupe(ir.NativeModule, modules);

    for (result) |*module| {
        module.specifier = try allocator.dupe(u8, module.specifier);
        module.identity = if (module.identity) |identity| try allocator.dupe(u8, identity) else null;
        module.import_name = try allocator.dupe(u8, module.import_name);
        const namespace = try allocator.alloc([]const u8, module.type_namespace.len);

        for (module.type_namespace, namespace) |name, *owned| owned.* = try allocator.dupe(u8, name);

        module.type_namespace = namespace;
        const bindings = try allocator.dupe(ir.Export, module.types);

        for (bindings) |*binding| binding.name = try allocator.dupe(u8, binding.name);

        module.types = bindings;
    }

    return result;
}
''')
p=Path('packages/compiler/src/zx/frontend.zig');s=p.read_text();s=s.replace('pub const native_link =', 'pub const native_context = @import("modules/native_context.zig");\npub const native_link =');assert 'pub const native_context' in s;save(p,s)
p=Path('packages/compiler/src/zx/analysis/analyze.zig');s=p.read_text().replace('nominal_types: Origins.Table = .{}, stores:', 'nominal_types: Origins.Table = .{}, native_modules: []const zx.ir.NativeModule = &.{}, stores:');s=s.replace('    const copied_types =', '''    if (!@import("../modules/native_context.zig").valid(context.types, context.native_modules)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared native module table",
    } } };

    const copied_types =''',1).replace('    program.output_ownership =', '    program.native_modules = try @import("../modules/native_context.zig").copy(arena.allocator(), context.native_modules);\n\n    program.output_ownership =',1);save(p,s)
p=Path('packages/compiler/src/zx/modules/project.zig');s=p.read_text().replace('    const units = try temporary.alloc(Unit, sources.len);','''    if (!@import("native_context.zig").valid(options.context.types, options.context.native_modules)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared native module table",
    } } };

    const units = try temporary.alloc(Unit, sources.len);''',1).replace('    project.types = try', '    project.native_modules = .fromOwnedSlice(try @import("native_context.zig").copy(temporary, options.context.native_modules));\n\n    project.types = try',1);save(p,s)
p=Path('packages/compiler/src/rx/analysis/project/prepare.zig');s=p.read_text().replace('            self.project.context.nominal_types = function.nominal_types;', '            self.project.context.nominal_types = function.nominal_types;\n            self.project.context.native_modules = function.program.native_modules;');save(p,s)
p=Path('packages/compiler/src/rx/analysis/project/lower.zig');s=p.read_text().replace('            .nominal_types = loaded.project.context.nominal_types,','            .nominal_types = loaded.project.context.nominal_types,\n            .native_modules = loaded.project.context.native_modules,');save(p,s)
p=Path('packages/compiler/src/rx/analysis/module_compile.zig');s=p.read_text().replace('    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),','    nominal_types: @FieldType(frontend.AnalysisResult, "nominal_types"),\n    native_modules: []const zx.ir.NativeModule = &.{},').replace('.merge(allocator, calls.items, types)', '.merge(allocator, calls.items, types, options.native_modules)');save(p,s)
p=Path('packages/compiler/src/rx/analysis/module_native.zig');s=p.read_text().replace('types: zx.ir.TypeTable) !', 'types: zx.ir.TypeTable, shared: []const zx.ir.NativeModule) !').replace('var modules: std.ArrayList(zx.ir.NativeModule) = .empty;', 'var modules: std.ArrayList(zx.ir.NativeModule) = .fromOwnedSlice(try @import("frontend").native_context.copy(allocator, shared));');save(p,s)
p=Path('packages/compiler/src/rx/analysis/call/compiled.zig');s=p.read_text().replace('var native_modules: std.ArrayList(zx.ir.NativeModule) = .empty;', 'var native_modules: std.ArrayList(zx.ir.NativeModule) = .fromOwnedSlice(try frontend.native_context.copy(allocator, options.project.context.native_modules));');save(p,s)
p=Path('packages/compiler/build/generate_parser.zig');s=p.read_text().replace('interfaces[0..1]', '&interfaces').replace('interfaces[1..]', '&interfaces');save(p,s)
