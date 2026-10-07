const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
pub const ParseCache = @import("parse_cache.zig");
pub const SemanticCache = @import("semantic_cache.zig");
pub const artifact = @import("artifact.zig");
const Analyzer = @import("../analysis/analyzer.zig");
const Analysis = @import("../analysis/analyze.zig");
const NominalOrigins = @import("nominal_origins.zig");
const ModuleRecord = @import("module_record.zig");
const Input = @import("module_input.zig");
pub const Source = struct { path: []const u8, source: []const u8 };
pub const compiled = @import("compiled.zig");
pub const External = @import("interface.zig").External;
pub const standard = @import("standard_interfaces").modules;
pub const NativeInterface = @import("interface.zig").Native;
pub const package_scope = @import("package_scope.zig");
pub const Package = package_scope.Package;
pub const PackageScope = package_scope.Scope;
pub const specifier = @import("specifier.zig");
pub const Options = struct { native_interfaces: []const NativeInterface = &.{}, externals: []const External = &.{}, packages: []const Package = &.{}, package_scopes: []const PackageScope = &.{}, compiled_libraries: []const compiled.Library = &.{}, entry: []const u8, root_dir: []const u8 = ".", context: Analysis.Context = .{} };

const Unit = struct {
    path: []const u8,
    state: enum { fresh, visiting, done } = .fresh,
    program: ?ir.Program = null,
    function: ?ir.FunctionId = null,
    context_digest: [32]u8 = undefined,
    reused: bool = false,
};

const NativeUnit = struct { exports: []const ir.Export, members: []const Analyzer.FunctionImport };
const Imported = struct { type_only: bool, function: ?ir.FunctionId, input_type: ir.TypeId, output_type: ir.TypeId, exports: []const ir.Export };

pub const ImportTarget = union(enum) { source: []const u8, compiled: compiled.Target };

const Project = struct {
    arena: *std.heap.ArenaAllocator,
    allocator: std.mem.Allocator,
    sources: []const Source,
    parse_cache: *ParseCache,
    semantic_cache: ?*SemanticCache = null,
    units: []Unit,
    options: Options,
    reporter: *zx.Reporter,
    types: ir.TypeTable = .{},
    nominal_origins: NominalOrigins,
    modules: std.ArrayList(ModuleRecord) = .empty,
    functions: ir.FunctionStorage = .{},
    native_modules: ir.NativeModuleStorage = .{},
    native_units: std.StringHashMapUnmanaged(NativeUnit) = .empty,
    store_initializers: std.ArrayList(compiled.StoreInitializer) = .empty,
    compiled_units: std.AutoHashMapUnmanaged(usize, compiled.Loaded) = .empty,
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

        const parsed = try self.parse_cache.getModule(self.sources[index].source, unit.path);

        if (parsed.diagnostic()) |diagnostic| {
            var issue = diagnostic;
            issue.message = try self.allocator.dupe(u8, issue.message);
            issue.message_allocator = null;
            self.reporter.diagnostic = issue;

            return error.InvalidSource;
        }

        return switch (parsed.*) {
            .native => |result| self.loadInput(index, Input.Native{ .value = result.value.parsed }),
            .indexed => |*result| if (ParseCache.indexed_enabled) self.loadInput(index, Input.Indexed{ .value = result }) else unreachable,
        };
    }
    fn loadInput(self: *Project, index: usize, input: anytype) zx.Error!ir.Program {
        const unit = &self.units[index];
        const header = input.header();
        var aliases: std.ArrayList(ir.Export) = .empty;
        var imported_names: std.StringHashMapUnmanaged(void) = .empty;
        var imports: std.ArrayList(Analyzer.FunctionImport) = .empty;
        var dependencies: std.ArrayList(ModuleRecord.Import) = .empty;

        for (0..header.importCount()) |import_index| {
            const item = @import("import_view.zig").get(header, import_index);

            for (0..item.nameCount()) |name_index| {
                const name = item.nameAt(name_index);
                const entry = try imported_names.getOrPut(self.allocator, name.text);

                if (entry.found_existing) return self.reporter.fail(.name, name.span, "duplicate import binding");
            }

            const kind = specifier.classify(item.path) catch return self.reporter.fail(.module, item.span, "invalid or unknown import specifier");

            if (kind != .file and kind != .package) {
                if (try self.importNative(item, &imports, &aliases)) |identity| {
                    var dependency = try ModuleRecord.copyImport(self.allocator, item, .native);
                    dependency.identity = try self.allocator.dupe(u8, identity);

                    try dependencies.append(self.allocator, dependency);

                    continue;
                }

                if (item.kind != .function or item.nameCount() != 1) return self.reporter.fail(.module, item.span, "external interfaces require a default function import");
                try self.importExternal(item, &imports);
                try dependencies.append(self.allocator, try ModuleRecord.copyImport(self.allocator, item, .external));

                continue;
            }

            const target = try resolveTarget(self.allocator, unit.path, item.path, self.options, self.reporter, item.span);

            const imported = switch (target) {
                .source => |path| block: {
                    const dependency = self.find(path) orelse return self.reporter.fail(.module, item.span, "import target is missing from the source set");
                    const program = try self.load(dependency);

                    break :block Imported{ .type_only = program.type_only, .function = self.units[dependency].function, .input_type = program.input_type, .output_type = program.output_type, .exports = program.exports };
                },
                .compiled => |value| try self.loadCompiled(value, item.span),
            };

            const module = imported;

            self.current_source = index;

            if (item.kind == .function) {
                if (module.type_only or item.nameCount() != 1) return self.reporter.fail(.module, item.span, "default imports must refer to an executable module");
                try imports.append(self.allocator, .{ .name = try self.allocator.dupe(u8, item.nameAt(0).text), .id = imported.function.?, .input_type = module.input_type, .output_type = module.output_type });
            } else {
                if (!module.type_only and target == .source) return self.reporter.fail(.module, item.span, "type and enum imports must refer to a pure type module");

                for (0..item.nameCount()) |name_index| {
                    const name = item.nameAt(name_index);
                    var found = false;

                    for (module.exports) |exported| {
                        if (!std.mem.eql(u8, name.text, exported.name)) continue;
                        if (item.kind == .enumeration and self.types.at(@backingInt(exported.type_id)) != .enumeration) return self.reporter.fail(.module, name.span, "value imports from a type module must name an enum");
                        try aliases.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = exported.type_id });

                        found = true;

                        break;
                    }

                    if (!found) return self.reporter.fail(.module, name.span, "the imported name is not exported by the module");
                }
            }

            try dependencies.append(self.allocator, try ModuleRecord.copyImport(self.allocator, item, switch (target) {
                .source => |path| .{ .source = path },
                .compiled => |value| .{ .compiled = value },
            }));
        }

        var source_digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(input.source(), &source_digest, .{});

        const first_type = self.types.count();
        var restored: ?ir.Program = null;

        if (self.semantic_cache) |cache| {
            unit.context_digest = try SemanticCache.contextDigest(self.allocator, if (std.mem.eql(u8, unit.path, self.options.entry)) self.options.context else .{});

            if (cache.get(unit.path, source_digest, unit.context_digest)) |cached| {
                if (try @import("semantic_cache/restore.zig").restore(cached.*, .{
                    .allocator = self.allocator,
                    .types = self.types,
                    .nominal_types = self.nominal_origins.items.view(),
                    .functions = self.functions.view(),
                    .native_modules = self.native_modules.view(),
                    .aliases = aliases.items,
                    .imports = imports.items,
                    .dependencies = dependencies.items,
                })) |result| {
                    restored = result.program;

                    self.nominal_origins.items.clearRetainingCapacity();

                    try self.nominal_origins.items.appendTable(self.allocator, result.nominal_types);

                    unit.reused = true;
                    cache.reused += 1;
                }
            }

            if (restored == null) cache.analyzed += 1;
        }

        const program = restored orelse analyze_block: {
            var analyzer = Analyzer{
                .allocator = self.allocator,
                .reporter = self.reporter,
                .types = .{ .allocator = self.allocator, .reporter = self.reporter, .declarations = &.{}, .aliases = aliases.items, .shared = .{ .origins = &self.nominal_origins, .origin = .{ .source = unit.path } } },
                .function_imports = imports.items,
                .functions = self.functions.view(),
                .store_bindings = if (std.mem.eql(u8, unit.path, self.options.entry)) self.options.context.stores else &.{},
                .store_type_count = self.options.context.types.count(),
            };

            try analyzer.types.items.appendDelta(self.allocator, self.types);

            var analyzed = try input.analyze(&analyzer, unit.path);
            analyzed.functions = try self.functions.view().snapshot(self.allocator);
            analyzed.output_ownership = try @import("../ownership/check.zig").analyze(self.allocator, analyzed, self.reporter);

            break :analyze_block analyzed;
        };

        self.types = program.types;

        if (!program.type_only) {
            unit.function = @fromBackingInt(@intCast(self.functions.count()));

            try self.functions.append(self.allocator, .{ .stores = program.stores, .store_mode = program.store_mode, .output_ownership = program.output_ownership, .file_name = program.file_name, .input_type = program.input_type, .output_type = program.output_type, .symbols = program.symbols, .expressions = program.expressions, .body = program.body, .contracts = program.contracts });
        }

        try self.modules.append(self.allocator, .{
            .path = unit.path,
            .source_digest = source_digest,
            .type_range = .{ .start = first_type, .end = program.types.count() },
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
    fn loadCompiled(self: *Project, target: compiled.Target, span: zx.Span) zx.Error!Imported {
        var selected: ?usize = null;

        for (self.options.compiled_libraries, 0..) |library, index| {
            if (!std.mem.eql(u8, library.instance, target.instance)) continue;

            const path = try std.fs.path.resolve(self.allocator, &.{ self.options.root_dir, library.artifact });

            if (selected != null or !std.mem.eql(u8, path, target.artifact)) return self.reporter.fail(.module, span, "compiled package instance has conflicting artifacts");

            selected = index;
        }

        const index = selected orelse return self.reporter.fail(.module, span, "compiled library is missing from the input set");

        const loaded = self.compiled_units.get(index) orelse block: {
            const value = compiled.load(self.allocator, .{
                .library = self.options.compiled_libraries[index],
                .types = self.types,
                .nominal_types = self.nominal_origins.items.view(),
                .functions = &self.functions,
                .native_modules = &self.native_modules,
            }) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return self.reporter.fail(.module, span, "compiled library has invalid IR or conflicting identities");
            };

            self.types = value.types;
            self.nominal_origins.items = .{};

            try self.nominal_origins.items.appendTable(self.allocator, value.nominal_types);
            try self.store_initializers.appendSlice(self.allocator, value.store_initializers);
            try self.compiled_units.put(self.allocator, index, value);

            break :block value;
        };

        for (loaded.exports) |exported| {
            if (!std.mem.eql(u8, exported.name, target.name)) continue;

            const function = if (exported.function) |id| self.functions.at(@backingInt(id)) else null;

            return .{
                .function = exported.function,
                .input_type = if (function) |value| value.input_type else @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
                .output_type = if (function) |value| value.output_type else @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))),
                .exports = exported.types,
                .type_only = function == null,
            };
        }

        return self.reporter.fail(.module, span, "compiled library does not export this public module");
    }
    fn find(self: *Project, path: []const u8) ?usize {
        for (self.units, 0..) |unit, index| if (std.mem.eql(u8, unit.path, path)) {
            return index;
        };

        return null;
    }
    fn nativeModule(self: *Project, source: []const u8, identity: ?[]const u8, name: []const u8, span: zx.Span) zx.Error!ir.NativeModuleId {
        if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return self.reporter.fail(.module, span, "native import names must be nonempty UTF-8 strings");

        for (0..self.native_modules.count()) |index| {
            const module = self.native_modules.at(index);

            if (std.mem.eql(u8, module.key(), identity orelse source) and std.mem.eql(u8, module.import_name, name)) return @fromBackingInt(@intCast(index));
        }

        const id: ir.NativeModuleId = @fromBackingInt(@intCast(self.native_modules.count()));

        try self.native_modules.append(self.allocator, .{ .specifier = try self.allocator.dupe(u8, source), .identity = if (identity) |key| try self.allocator.dupe(u8, key) else null, .import_name = try self.allocator.dupe(u8, name) });

        return id;
    }
    fn importNative(self: *Project, item: anytype, imports: *std.ArrayList(Analyzer.FunctionImport), aliases: *std.ArrayList(ir.Export)) zx.Error!?[]const u8 {
        var found: ?NativeInterface = null;
        const path = self.units[self.current_source].path;
        const registry = package_scope.nativeInterfaces(self.options.package_scopes, path, self.options.native_interfaces);

        for ([_][]const NativeInterface{ &@import("interface.zig").standard, registry }) |interfaces| {
            for (interfaces) |entry| {
                if (!std.mem.eql(u8, entry.specifier, item.path)) continue;
                if (found != null) return self.reporter.fail(.module, item.span, "duplicate native interface module");

                found = entry;
            }
        }

        const entry = found orelse return null;

        for (package_scope.externals(self.options.package_scopes, path, self.options.externals)) |legacy| {
            if (std.mem.eql(u8, legacy.specifier, item.path)) return self.reporter.fail(.module, item.span, "native declarations conflict with legacy external signatures");
        }

        const unit = self.native_units.get(entry.key()) orelse blk: {
            const module_id = try self.nativeModule(entry.specifier, entry.identity, entry.module, item.span);

            const loaded = if (self.semantic_cache) |cache|
                try cache.native.load(self.allocator, entry, .{ .module = module_id, .types = self.types, .nominal_types = self.nominal_origins.items.view() }, self.reporter, item.span)
            else
                try @import("native.zig").load(self.arena, entry, module_id, self.types, &self.nominal_origins, self.reporter, item.span);

            const namespace = try self.allocator.alloc([]const u8, entry.namespace.len);

            for (entry.namespace, namespace) |part, *owned| owned.* = try self.allocator.dupe(u8, part);

            const bindings = try ir.NativeBindings.fromValues(self.allocator, loaded.exports);
            const native_index = @backingInt(module_id);

            self.native_modules.type_namespaces.items[native_index] = namespace;
            self.native_modules.type_names.items[native_index] = bindings.names;
            self.native_modules.type_ids.items[native_index] = bindings.type_ids;

            const members = try self.allocator.alloc(Analyzer.FunctionImport, loaded.members.len);

            if (self.semantic_cache != null) try self.nominal_origins.append(loaded.types, self.types.count(), .{ .native = entry.key() });

            self.types = loaded.types;

            for (loaded.members, members) |member, *binding| {
                const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

                try self.functions.append(self.allocator, member.function);

                binding.* = .{ .name = member.name, .id = id, .input_type = member.function.input_type, .output_type = member.function.output_type, .positional_types = if (member.function.external.?.expand_tuple) self.types.at(@backingInt(member.function.input_type)).tuple else null };
            }

            const result = NativeUnit{ .exports = loaded.exports, .members = members };

            try self.native_units.put(self.allocator, try self.allocator.dupe(u8, entry.key()), result);

            break :blk result;
        };

        if (item.kind == .function) {
            if (item.nameCount() != 1 or unit.members.len == 0) return self.reporter.fail(.module, item.span, "native namespaces require one binding and callable exports");

            for (unit.members) |member| {
                var binding = member;
                binding.namespace = try self.allocator.dupe(u8, item.nameAt(0).text);

                try imports.append(self.allocator, binding);
            }
        } else for (0..item.nameCount()) |name_index| {
            const name = item.nameAt(name_index);
            var matched = false;

            for (unit.exports) |exported| {
                if (!std.mem.eql(u8, name.text, exported.name)) continue;
                if (item.kind == .enumeration and self.types.at(@backingInt(exported.type_id)) != .enumeration) return self.reporter.fail(.module, name.span, "native value imports must name an enum");
                try aliases.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name.text), .type_id = exported.type_id });

                matched = true;

                break;
            }

            if (!matched) return self.reporter.fail(.module, name.span, "native interface does not export this type");
        }

        return entry.key();
    }
    fn importExternal(self: *Project, item: anytype, imports: *std.ArrayList(Analyzer.FunctionImport)) zx.Error!void {
        const registry = package_scope.externals(self.options.package_scopes, self.units[self.current_source].path, self.options.externals);
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

            const shared = @import("../analysis/types.zig").Shared{ .origins = &self.nominal_origins, .origin = .{ .external = .{
                .module = entry.key(),
                .member = entry.exportName(),
            } } };

            const imported = try @import("external.zig").load(self.allocator, entry, try self.nativeModule(entry.specifier, entry.identity, entry.implementation.module, item.span), item.span, self.types, shared, self.reporter);

            self.types = imported.types;

            const function_id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

            try self.functions.append(self.allocator, imported.function);

            try imports.append(self.allocator, .{
                .namespace = if (entry.export_name != null) try self.allocator.dupe(u8, item.nameAt(0).text) else null,
                .positional_types = if (imported.function.external.?.expand_tuple) self.types.at(@backingInt(imported.function.input_type)).tuple else null,
                .name = try self.allocator.dupe(u8, entry.export_name orelse item.nameAt(0).text),
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
    return analyzeWithCaches(allocator, sources, options, cache, null);
}

pub fn analyzeIncremental(allocator: std.mem.Allocator, sources: []const Source, options: Options, cache: *SemanticCache) std.mem.Allocator.Error!Analysis.Result {
    return analyzeWithCaches(allocator, sources, options, &cache.parse_cache, cache);
}

fn analyzeWithCaches(allocator: std.mem.Allocator, sources: []const Source, options: Options, cache: *ParseCache, semantic_cache: ?*SemanticCache) std.mem.Allocator.Error!Analysis.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const temporary = arena.allocator();
    var reporter: zx.Reporter = .{};

    if (options.context.types.count() != 0 and !@import("../ir/type_rules.zig").validate(options.context.types)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared type table",
    } } };

    if (!@import("native_context.zig").valid(options.context.types, options.context.native_modules)) return .{ .arena = arena, .value = .{ .diagnostic = .{
        .code = .contract,
        .span = .{ .start = 0, .end = 0 },
        .message = "invalid shared native module table",
    } } };

    const units = try temporary.alloc(Unit, sources.len);

    for (sources, 0..) |source, index| units[index] = .{ .path = try std.fs.path.resolve(temporary, &.{ options.root_dir, source.path }) };

    var normalized = options;
    normalized.entry = try std.fs.path.resolve(temporary, &.{ options.root_dir, options.entry });
    var project = Project{ .arena = &arena, .allocator = temporary, .sources = sources, .parse_cache = cache, .semantic_cache = if (options.compiled_libraries.len == 0) semantic_cache else null, .units = units, .options = normalized, .reporter = &reporter, .nominal_origins = .{ .allocator = temporary } };
    project.native_modules = try @import("native_context.zig").storage(temporary, options.context.native_modules);
    project.types = try @import("../analysis/type_table.zig").copy(temporary, options.context.types);

    project.nominal_origins.seed(project.types, options.context.nominal_types) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "invalid shared nominal type table" } } };
    };

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
    program.native_modules = project.native_modules.view();
    program.functions = try project.functions.view().prefix(project.functions.count() - @intFromBool(!program.type_only)).snapshot(temporary);

    if (try @import("../ir/validate.zig").validate(allocator, program)) |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } };

    var result = Analysis.Result{ .arena = arena, .value = .{ .ir = program }, .nominal_types = project.nominal_origins.items.view(), .modules = project.modules.items, .store_initializers = project.store_initializers.items };

    if (project.semantic_cache) |semantic| {
        for (result.modules, 0..) |module, index| {
            const unit = project.units[project.find(module.path).?];

            if (unit.reused) continue;

            var extracted = artifact.extract(semantic.allocator, &result, index) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                if (err == error.MissingNominalOrigin) {
                    semantic.uncacheable += 1;

                    continue;
                }

                return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .contract, .span = .{ .start = 0, .end = 0 }, .message = "module artifact extraction requires valid project IR and module metadata" } } };
            };

            semantic.put(extracted, unit.context_digest) catch |err| {
                extracted.deinit();

                return err;
            };
        }
    }

    return result;
}

pub fn resolvePath(allocator: std.mem.Allocator, from: []const u8, path: []const u8, root: []const u8, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    const extension = std.fs.path.extension(path);
    const basename = std.fs.path.basename(path);

    if (basename.len == 0 or std.mem.endsWith(u8, path, "/") or std.mem.eql(u8, basename, ".") or std.mem.eql(u8, basename, "..")) return reporter.fail(.module, span, "project imports must name a ZX module");
    if (extension.len != 0) return reporter.fail(.module, span, "project imports must omit the .zx extension; runtime and RX imports are forbidden");

    const source_path = try std.fmt.allocPrint(allocator, "{s}.zx", .{path});

    defer allocator.free(source_path);

    if (std.mem.startsWith(u8, path, "@/")) return std.fs.path.resolve(allocator, &.{ root, source_path[2..] });
    if (!std.mem.startsWith(u8, path, "./") and !std.mem.startsWith(u8, path, "../")) return reporter.fail(.module, span, "imports require ./, ../ or @/ paths; external interfaces require explicit registration");

    return std.fs.path.resolve(allocator, &.{ std.fs.path.dirname(from) orelse ".", source_path });
}

pub fn resolveImport(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    return switch (try resolveTarget(allocator, from, path, options, reporter, span)) {
        .source => |source| source,
        .compiled => reporter.fail(.module, span, "compiled package imports require structured target loading"),
    };
}

pub fn resolveTarget(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error!ImportTarget {
    const kind = specifier.classify(path) catch return reporter.fail(.module, span, "invalid or unknown import specifier");
    const owner = package_scope.owner(options.package_scopes, from);
    const root = if (owner) |index| options.package_scopes[index].root else options.root_dir;

    if (options.package_scopes.len != 0 and owner == null) return reporter.fail(.module, span, "source file does not belong to a declared package");

    if (kind == .file) {
        const resolved = try resolvePath(allocator, from, path, root, reporter, span);

        if (owner != null and package_scope.owner(options.package_scopes, resolved) != owner) return reporter.fail(.module, span, "file import crosses a package boundary; declare and import the package dependency");

        return .{ .source = resolved };
    }

    if (kind != .package) return reporter.fail(.module, span, "native and standard imports must use the interface registry");

    var target: ?ImportTarget = null;
    const dependencies = if (owner) |index| options.package_scopes[index].packages else options.packages;

    for (dependencies) |package| {
        if (!std.mem.eql(u8, package.specifier, path)) continue;
        if (target != null) return reporter.fail(.module, span, "duplicate ZX package specifier");

        if (package.compiled) |value| {
            if (package.entry.len != 0 or value.instance.len == 0 or value.artifact.len == 0 or value.name.len == 0) return reporter.fail(.module, span, "compiled package target must identify one instance, artifact and public module");

            target = .{ .compiled = .{
                .instance = try allocator.dupe(u8, value.instance),
                .artifact = try std.fs.path.resolve(allocator, &.{ options.root_dir, value.artifact }),
                .name = try allocator.dupe(u8, value.name),
            } };
        } else {
            if (!std.mem.endsWith(u8, package.entry, ".zx")) return reporter.fail(.module, span, "ZX package entry must be a .zx source file");

            target = .{ .source = try std.fs.path.resolve(allocator, &.{ options.root_dir, package.entry }) };
        }
    }

    return target orelse return reporter.fail(.module, span, "ZX package is not declared in the project dependencies");
}
