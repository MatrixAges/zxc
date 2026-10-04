const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
pub const ParseCache = @import("parse_cache.zig");
pub const artifact = @import("artifact.zig");
const Analyzer = @import("../analysis/analyzer.zig");
const Analysis = @import("../analysis/analyze.zig");
const NominalOrigins = @import("nominal_origins.zig");
const ModuleRecord = @import("module_record.zig");
pub const Source = struct { path: []const u8, source: []const u8 };
pub const External = @import("interface.zig").External;
pub const standard = @import("standard_interfaces").modules;
pub const NativeInterface = @import("interface.zig").Native;
pub const package_scope = @import("package_scope.zig");
pub const Package = package_scope.Package;
pub const PackageScope = package_scope.Scope;
pub const specifier = @import("specifier.zig");
pub const Options = struct { native_interfaces: []const NativeInterface = &.{}, externals: []const External = &.{}, packages: []const Package = &.{}, package_scopes: []const PackageScope = &.{}, entry: []const u8, root_dir: []const u8 = ".", context: Analysis.Context = .{} };
const Unit = struct { path: []const u8, state: enum { fresh, visiting, done } = .fresh, program: ?ir.Program = null, function: ?ir.FunctionId = null };
const NativeUnit = struct { exports: []const ir.Export, members: []const Analyzer.FunctionImport };

const Project = struct {
    allocator: std.mem.Allocator,
    sources: []const Source,
    parse_cache: *ParseCache,
    units: []Unit,
    options: Options,
    reporter: *zx.Reporter,
    types: []const ir.Type = &.{},
    nominal_origins: NominalOrigins,
    modules: std.ArrayList(ModuleRecord) = .empty,
    functions: std.ArrayList(ir.Function) = .empty,
    native_modules: std.ArrayList(ir.NativeModule) = .empty,
    native_units: std.StringHashMapUnmanaged(NativeUnit) = .empty,
    current_source: usize = 0,
    depth: usize = 0,
    fn load(self: *Project, index: usize) zx.Error!ir.Program {
        const unit = &self.units[index];

        if (unit.state == .done) return unit.program.?;
        if (unit.state == .visiting) return self.reporter.fail(.module, .{ .start = 0, .end = 0 }, "ZX module imports must be acyclic, including unused imports");
        if (self.depth >= 256) return self.reporter.fail(.module, .{ .start = 0, .end = 0 }, "module dependency depth exceeds 256");

        self.depth += 1;
        defer self.depth -= 1;
        unit.state = .visiting;
        self.current_source = index;

        const parsed = try self.parse_cache.get(self.sources[index].source, unit.path);

        if (parsed.value == .diagnostic) {
            self.reporter.diagnostic = parsed.value.diagnostic;

            return error.InvalidSource;
        }

        const input = parsed.value.parsed;
        var aliases: std.ArrayList(ir.Export) = .empty;
        var imported_names: std.StringHashMapUnmanaged(void) = .empty;
        var imports: std.ArrayList(Analyzer.FunctionImport) = .empty;
        var dependencies: std.ArrayList(ModuleRecord.Import) = .empty;

        for (input.ast.imports) |item| {
            for (item.names) |name| {
                const entry = try imported_names.getOrPut(self.allocator, name.text);

                if (entry.found_existing) return self.reporter.fail(.name, name.span, "duplicate import binding");
            }

            const kind = specifier.classify(item.path) catch return self.reporter.fail(.module, item.span, "invalid or unknown import specifier");

            if (kind != .file and kind != .package) {
                if (try self.importNative(item, &imports, &aliases)) {
                    try dependencies.append(self.allocator, try ModuleRecord.copyImport(self.allocator, item, .native));

                    continue;
                }

                if (item.kind != .function or item.names.len != 1) return self.reporter.fail(.module, item.span, "external interfaces require a default function import");
                try self.importExternal(item, &imports);
                try dependencies.append(self.allocator, try ModuleRecord.copyImport(self.allocator, item, .external));

                continue;
            }

            const path = try resolveImport(self.allocator, unit.path, item.path, self.options, self.reporter, item.span);
            const dependency = self.find(path) orelse return self.reporter.fail(.module, item.span, "import target is missing from the source set");
            const module = try self.load(dependency);

            self.current_source = index;

            if (item.kind == .function) {
                if (module.type_only or item.names.len != 1) return self.reporter.fail(.module, item.span, "default imports must refer to an executable ZX module");
                try imports.append(self.allocator, .{ .name = try self.allocator.dupe(u8, item.names[0].text), .id = self.units[dependency].function.?, .input_type = module.input_type, .output_type = module.output_type });
            } else {
                if (!module.type_only) return self.reporter.fail(.module, item.span, "type and enum imports must refer to a pure type module");

                for (item.names) |name| {
                    var found = false;

                    for (module.exports) |exported| {
                        if (!std.mem.eql(u8, name.text, exported.name)) continue;
                        if (item.kind == .enumeration and self.types[@intFromEnum(exported.type_id)] != .enumeration) return self.reporter.fail(.module, name.span, "value imports from a type module must name an enum");
                        try aliases.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = exported.type_id });

                        found = true;

                        break;
                    }

                    if (!found) return self.reporter.fail(.module, name.span, "the imported name is not exported by the module");
                }
            }

            try dependencies.append(self.allocator, try ModuleRecord.copyImport(self.allocator, item, .{ .source = path }));
        }

        var analyzer = Analyzer{
            .allocator = self.allocator,
            .reporter = self.reporter,
            .types = .{ .allocator = self.allocator, .reporter = self.reporter, .declarations = input.ast.declarations, .aliases = aliases.items },
            .function_imports = imports.items,
            .store_bindings = if (std.mem.eql(u8, unit.path, self.options.entry)) self.options.context.stores else &.{},
        };

        try analyzer.types.items.appendSlice(self.allocator, self.types);

        var program = try analyzer.run(input.ast, unit.path);

        program.functions = try self.allocator.dupe(ir.Function, self.functions.items);

        try self.nominal_origins.append(program.types, self.types.len, .{ .source = unit.path });

        self.types = program.types;
        program.output_ownership = try @import("../ownership/check.zig").analyze(self.allocator, program, self.reporter);

        if (!program.type_only) {
            unit.function = @enumFromInt(self.functions.items.len);

            try self.functions.append(self.allocator, .{ .output_ownership = program.output_ownership, .file_name = program.file_name, .input_type = program.input_type, .output_type = program.output_type, .symbols = program.symbols, .expressions = program.expressions, .body = program.body, .contracts = program.contracts });
        }

        var source_digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(input.source, &source_digest, .{});

        try self.modules.append(self.allocator, .{
            .path = unit.path,
            .source_digest = source_digest,
            .exports = program.exports,
            .imports = dependencies.items,
            .type_imports = aliases.items,
            .function_imports = imports.items,
            .body = if (program.type_only) .types else if (std.mem.eql(u8, unit.path, self.options.entry)) .entry else .{ .function = unit.function.? },
        });

        unit.program = program;
        unit.state = .done;

        return program;
    }
    fn find(self: *Project, path: []const u8) ?usize {
        for (self.units, 0..) |unit, index| if (std.mem.eql(u8, unit.path, path)) {
            return index;
        };

        return null;
    }
    fn nativeModule(self: *Project, source: []const u8, name: []const u8, span: zx.Span) zx.Error!ir.NativeModuleId {
        if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return self.reporter.fail(.module, span, "native import names must be nonempty UTF-8 strings");

        for (self.native_modules.items, 0..) |module, index| {
            if (std.mem.eql(u8, module.specifier, source) and std.mem.eql(u8, module.import_name, name)) return @enumFromInt(index);
        }

        const id: ir.NativeModuleId = @enumFromInt(self.native_modules.items.len);

        try self.native_modules.append(self.allocator, .{ .specifier = try self.allocator.dupe(u8, source), .import_name = try self.allocator.dupe(u8, name) });

        return id;
    }
    fn importNative(self: *Project, item: zx.ast.Import, imports: *std.ArrayList(Analyzer.FunctionImport), aliases: *std.ArrayList(ir.Export)) zx.Error!bool {
        var found: ?NativeInterface = null;

        for ([_][]const NativeInterface{ &@import("interface.zig").standard, self.options.native_interfaces }) |interfaces| {
            for (interfaces) |entry| {
                if (!std.mem.eql(u8, entry.specifier, item.path)) continue;
                if (found != null) return self.reporter.fail(.module, item.span, "duplicate native interface module");

                found = entry;
            }
        }

        const entry = found orelse return false;

        for (self.options.externals) |legacy| {
            if (std.mem.eql(u8, legacy.specifier, item.path)) return self.reporter.fail(.module, item.span, "native declarations conflict with legacy external signatures");
        }

        const unit = self.native_units.get(item.path) orelse blk: {
            const module_id = try self.nativeModule(entry.specifier, entry.module, item.span);
            const loaded = try @import("native.zig").load(self.allocator, entry, module_id, self.types, self.reporter, item.span);
            const namespace = try self.allocator.alloc([]const u8, entry.namespace.len);

            for (entry.namespace, namespace) |part, *owned| owned.* = try self.allocator.dupe(u8, part);

            self.native_modules.items[@intFromEnum(module_id)].type_namespace = namespace;
            self.native_modules.items[@intFromEnum(module_id)].types = loaded.exports;

            const members = try self.allocator.alloc(Analyzer.FunctionImport, loaded.members.len);

            try self.nominal_origins.append(loaded.types, self.types.len, .{ .native = entry.specifier });

            self.types = loaded.types;

            for (loaded.members, members) |member, *binding| {
                const id: ir.FunctionId = @enumFromInt(self.functions.items.len);

                try self.functions.append(self.allocator, member.function);

                binding.* = .{ .name = member.name, .id = id, .input_type = member.function.input_type, .output_type = member.function.output_type, .positional_types = if (member.function.external.?.expand_tuple) self.types[@intFromEnum(member.function.input_type)].tuple else null };
            }

            const result = NativeUnit{ .exports = loaded.exports, .members = members };

            try self.native_units.put(self.allocator, try self.allocator.dupe(u8, item.path), result);

            break :blk result;
        };

        if (item.kind == .function) {
            if (item.names.len != 1 or unit.members.len == 0) return self.reporter.fail(.module, item.span, "native namespaces require one binding and callable exports");

            for (unit.members) |member| {
                var binding = member;
                binding.namespace = try self.allocator.dupe(u8, item.names[0].text);

                try imports.append(self.allocator, binding);
            }
        } else for (item.names) |name| {
            var matched = false;

            for (unit.exports) |exported| {
                if (!std.mem.eql(u8, name.text, exported.name)) continue;
                if (item.kind == .enumeration and self.types[@intFromEnum(exported.type_id)] != .enumeration) return self.reporter.fail(.module, name.span, "native value imports must name an enum");
                try aliases.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = exported.type_id });

                matched = true;

                break;
            }

            if (!matched) return self.reporter.fail(.module, name.span, "native interface does not export this type");
        }

        return true;
    }
    fn importExternal(self: *Project, item: zx.ast.Import, imports: *std.ArrayList(Analyzer.FunctionImport)) zx.Error!void {
        const registry = self.options.externals;
        var exports: std.StringHashMapUnmanaged(void) = .empty;
        var count: usize = 0;
        var default_export = false;

        for (registry) |entry| {
            if (!std.mem.eql(u8, entry.specifier, item.path)) continue;

            const member = entry.export_name orelse "";
            const found = try exports.getOrPut(self.allocator, member);

            if (found.found_existing or (count != 0 and (default_export or entry.export_name == null))) return self.reporter.fail(.module, item.span, "external modules require unique members or one default function");

            default_export = entry.export_name == null;
            count += 1;
            const imported = try @import("external.zig").load(self.allocator, entry, try self.nativeModule(entry.specifier, entry.implementation.module, item.span), item.span, self.types, self.reporter);

            try self.nominal_origins.append(imported.types, self.types.len, .{ .external = .{
                .importer = self.units[self.current_source].path,
                .binding = item.names[0].text,
                .member = entry.export_name orelse "",
            } });

            self.types = imported.types;

            const function_id: ir.FunctionId = @enumFromInt(self.functions.items.len);

            try self.functions.append(self.allocator, imported.function);

            try imports.append(self.allocator, .{
                .namespace = if (entry.export_name != null) try self.allocator.dupe(u8, item.names[0].text) else null,
                .positional_types = if (imported.function.external.?.expand_tuple) self.types[@intFromEnum(imported.function.input_type)].tuple else null,
                .name = try self.allocator.dupe(u8, entry.export_name orelse item.names[0].text),
                .id = function_id,
                .input_type = imported.function.input_type,
                .output_type = imported.function.output_type,
            });
        }

        if (count == 0) return self.reporter.fail(.capability, item.span, "this module has no registered pure interfaces");
    }
};

pub fn analyze(allocator: std.mem.Allocator, sources: []const Source, options: Options) std.mem.Allocator.Error!Analysis.Result {
    var cache = ParseCache{ .allocator = allocator };

    defer cache.deinit();

    return analyzeWithCache(allocator, sources, options, &cache);
}

pub fn analyzeWithCache(allocator: std.mem.Allocator, sources: []const Source, options: Options, cache: *ParseCache) std.mem.Allocator.Error!Analysis.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const temporary = arena.allocator();
    var reporter: zx.Reporter = .{};

    if (options.context.types.len != 0 and !@import("../ir/type_rules.zig").validate(options.context.types)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared type table",
    } } };

    const units = try temporary.alloc(Unit, sources.len);

    for (sources, 0..) |source, index| units[index] = .{ .path = try std.fs.path.resolve(temporary, &.{ options.root_dir, source.path }) };

    var normalized = options;
    normalized.entry = try std.fs.path.resolve(temporary, &.{ options.root_dir, options.entry });
    var project = Project{ .allocator = temporary, .sources = sources, .parse_cache = cache, .units = units, .options = normalized, .reporter = &reporter, .nominal_origins = .{ .allocator = temporary } };

    project.types = try @import("../analysis/type_table.zig").copy(temporary, options.context.types);

    for (units, 0..) |unit, index| {
        for (units[0..index]) |previous| {
            if (std.mem.eql(u8, unit.path, previous.path)) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "source paths must be unique after normalization" } } };
        }
    }

    const root = project.find(normalized.entry) orelse return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "entry module is missing" } } };

    var program = project.load(root) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        var issue = reporter.diagnostic.?;
        issue.source_index = project.current_source;

        return .{ .arena = arena, .value = .{ .diagnostic = issue } };
    };

    program.types = project.types;
    program.native_modules = project.native_modules.items;
    program.functions = try temporary.dupe(ir.Function, project.functions.items[0 .. project.functions.items.len - @intFromBool(!program.type_only)]);

    return .{ .arena = arena, .value = .{ .ir = program }, .nominal_types = project.nominal_origins.items.items, .modules = project.modules.items };
}

pub fn resolvePath(allocator: std.mem.Allocator, from: []const u8, path: []const u8, root: []const u8, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    if (!std.mem.endsWith(u8, path, ".zx")) return reporter.fail(.module, span, "project imports must end in .zx; runtime and RX imports are forbidden");
    if (std.mem.startsWith(u8, path, "@/")) return std.fs.path.resolve(allocator, &.{ root, path[2..] });
    if (!std.mem.startsWith(u8, path, "./") and !std.mem.startsWith(u8, path, "../")) return reporter.fail(.module, span, "imports require ./, ../ or @/ paths; external interfaces require explicit registration");

    return std.fs.path.resolve(allocator, &.{ std.fs.path.dirname(from) orelse ".", path });
}

pub fn resolveImport(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    const kind = specifier.classify(path) catch return reporter.fail(.module, span, "invalid or unknown import specifier");
    const owner = package_scope.owner(options.package_scopes, from);
    const root = if (owner) |index| options.package_scopes[index].root else options.root_dir;

    if (options.package_scopes.len != 0 and owner == null) return reporter.fail(.module, span, "source file does not belong to a declared package");

    if (kind == .file) {
        const resolved = try resolvePath(allocator, from, path, root, reporter, span);

        if (owner != null and package_scope.owner(options.package_scopes, resolved) != owner) return reporter.fail(.module, span, "file import crosses a package boundary; declare and import the package dependency");

        return resolved;
    }

    if (kind != .package) return reporter.fail(.module, span, "native and standard imports must use the interface registry");

    var target: ?[]const u8 = null;
    const dependencies = if (owner) |index| options.package_scopes[index].packages else options.packages;

    for (dependencies) |package| {
        if (!std.mem.eql(u8, package.specifier, path)) continue;
        if (target != null) return reporter.fail(.module, span, "duplicate ZX package specifier");
        if (!std.mem.endsWith(u8, package.entry, ".zx")) return reporter.fail(.module, span, "ZX package entry must be a .zx source file");

        target = package.entry;
    }

    const entry = target orelse return reporter.fail(.module, span, "ZX package is not declared in the project dependencies");

    return std.fs.path.resolve(allocator, &.{ options.root_dir, entry });
}
