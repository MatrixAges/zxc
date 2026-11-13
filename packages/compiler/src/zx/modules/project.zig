const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Validate = @import("../ir/validate.zig");
pub const ParseCache = @import("parse_cache.zig");
pub const SemanticCache = @import("semantic_cache.zig");
pub const artifact = @import("artifact.zig");
const HostContext = @import("../analysis/analyzer/host/context.zig");
pub const FunctionImport = @import("function_import.zig");
const Signature = @import("source_signature.zig");
const PublicExports = @import("public_exports.zig");
const Analysis = @import("../analysis/analyze.zig");
const NominalOrigins = @import("nominal_origins.zig");
const ModuleRecord = @import("module_record.zig");
const Input = @import("module_input.zig");
const Loading = @import("project/load/host.zig");
const State = @import("project/state/host.zig");
const Target = @import("project/target/host.zig");
const target_registry = @import("project/target/registry.zig");
pub const signature_project = @import("signature_project.zig");
pub const import_binding = @import("binding.zig");
pub const import_view = @import("import_view.zig");
pub const source_index = @import("source_index.zig");
pub const module_path = @import("module_path.zig");
pub const Resource = struct { path: []const u8, source: []const u8 };
pub const Source = struct { path: []const u8, source: []const u8, templates: []const Resource = &.{}, original: ?[]const u8 = null, template_origins: []const @import("../frontend/resources/root.zig").Origin = &.{} };
pub const resources = @import("../frontend/resources/root.zig");
pub const prepareSources = @import("../frontend/resources/prepare.zig").sources;
pub const compiled = @import("compiled.zig");
pub const External = @import("interface.zig").External;
pub const standard = @import("standard_interfaces").modules;
pub const NativeInterface = @import("interface.zig").Native;
pub const package_scope = @import("package_scope.zig");
pub const Package = package_scope.Package;
pub const PackageScope = package_scope.Scope;
pub const specifier = @import("specifier.zig");

pub const Options = struct {
    source_index: ?*const source_index.Map = null,
    native_interfaces: []const NativeInterface = &.{},
    externals: []const External = &.{},
    packages: []const Package = &.{},
    package_scopes: []const PackageScope = &.{},
    compiled_libraries: []const compiled.Library = &.{},
    entry: []const u8,
    root_dir: []const u8 = ".",
    context: Analysis.Context = .{},
    pub fn jsonStringify(self: Options, writer: anytype) !void {
        try writer.beginObject();

        inline for (@typeInfo(Options).@"struct".field_names) |name| {
            if (comptime !std.mem.eql(u8, name, "source_index")) {
                try writer.objectField(name);
                try writer.write(@field(self, name));
            }
        }

        try writer.endObject();
    }
};

const Unit = struct {
    path: []const u8,
    state: Loading.State = .Fresh,
    signature: ?@import("source_signature.zig").Result = null,
    signature_aliases: []const ir.Export = &.{},
    signature_imports: []const FunctionImport = &.{},
    signature_reexports: []const FunctionImport = &.{},
    signature_constant_imports: []const ir.Constant = &.{},
    function: ?ir.FunctionId = null,
    exports: []const ir.Export = &.{},
    constants: []const ir.Constant = &.{},
    members: []const FunctionImport = &.{},
    context_digest: [32]u8 = undefined,
    reused: bool = false,
};

const NativeUnit = struct { exports: []const ir.Export, members: []const FunctionImport };
const Imported = struct { exports: []const ir.Export, constant_exports: []const ir.Constant = &.{}, members: []const FunctionImport = &.{}, signatures: []const Signature.Member = &.{} };
pub const ImportTarget = Target.Target;

const LoadFrame = struct {
    index: usize,
    parsed: ParseCache.Version,
    next_import: usize = 0,
    pending: ?struct { path: []const u8, index: usize } = null,
    aliases: std.ArrayList(ir.Export) = .empty,
    imported_names: std.StringHashMapUnmanaged(void) = .empty,
    imports: std.ArrayList(FunctionImport) = .empty,
    constant_imports: std.ArrayList(ir.Constant) = .empty,
    dependencies: std.ArrayList(ModuleRecord.Import) = .empty,
    export_aliases: std.ArrayList(ir.Export) = .empty,
    export_constants: std.ArrayList(ir.Constant) = .empty,
    export_functions: std.ArrayList(FunctionImport) = .empty,
    signature_members: std.ArrayList(Signature.Member) = .empty,
};

const Project = struct {
    arena: *std.heap.ArenaAllocator,
    allocator: std.mem.Allocator,
    binding_scratch: std.heap.ArenaAllocator,
    sources: []const Source,
    parse_cache: *ParseCache,
    semantic_cache: ?*SemanticCache = null,
    phase: Loading.Phase = .body,
    load_frames: std.ArrayList(LoadFrame) = .empty,
    entry_program: ?ir.Program = null,
    empty_context_digest: ?[32]u8 = null,
    units: []Unit,
    /// Each unit path to the first unit with it.
    unit_indices: source_index.Map = .empty,
    options: Options,
    reporter: *zx.Reporter,
    types: ir.TypeStorage = .{},
    nominal_origins: NominalOrigins,
    modules: std.ArrayList(ModuleRecord) = .empty,
    functions: ir.FunctionStorage = .{},
    verified_functions: usize = 0,
    verified_types: ?Validate.TypePrefix = null,
    native_modules: ir.NativeModuleStorage = .{},
    native_units: std.StringHashMapUnmanaged(NativeUnit) = .empty,
    store_initializers: std.ArrayList(compiled.StoreInitializer) = .empty,
    compiled_units: std.AutoHashMapUnmanaged(usize, []const compiled.Export) = .empty,
    current_source: usize = 0,
    fn bindingAllocator(self: *Project) std.mem.Allocator {
        _ = self.binding_scratch.reset(.retain_capacity);

        return self.binding_scratch.allocator();
    }
    fn load(self: *Project, index: usize) zx.Error!ir.Program {
        try self.loadFrames(index);

        var program = self.entry_program.?;
        const unit = &self.units[index];
        program.types = self.types.view();
        program.exports = unit.exports;
        program.constant_exports = unit.constants;

        if (program.type_only) if (unit.function) |id| {
            const function = self.functions.at(@backingInt(id));

            program.type_only = false;
            program.input_type = function.input_type;
            program.output_type = function.output_type;
            program.output_ownership = function.output_ownership;
            program.symbols = function.symbols;
            program.expressions = function.expressions;
            program.body = function.body;
            program.contracts = function.contracts;
            program.stores = function.stores;
            program.store_mode = function.store_mode;

            if (function.external != null) try @import("function_body.zig").externalEntry(self.allocator, &program, id);
        };

        return program;
    }
    fn loadFrames(self: *Project, index: usize) zx.Error!void {
        const frames = &self.load_frames;

        try self.pushFrame(index);

        while (frames.items.len != 0) {
            const frame = &frames.items[frames.items.len - 1];
            self.current_source = frame.index;

            const dependency = switch (frame.parsed.result.*) {
                .native => |result| try self.loadInput(frame, Input.Native{ .value = result.value.parsed }),
                .indexed => |*result| if (ParseCache.indexed_enabled) try self.loadInput(frame, Input.Indexed{ .value = result }) else unreachable,
            };

            if (dependency) |child| {
                try self.pushFrame(child);
            } else {
                frame.imported_names.deinit(self.arena.child_allocator);

                _ = frames.pop();
            }
        }
    }

    fn deinitScratch(self: *Project) void {
        const allocator = self.arena.child_allocator;

        self.unit_indices.deinit(allocator);
        for (self.load_frames.items) |*frame| frame.imported_names.deinit(allocator);

        self.load_frames.deinit(allocator);
        self.binding_scratch.deinit();
    }

    fn pushFrame(self: *Project, index: usize) zx.Error!void {
        const unit = &self.units[index];
        const frames = &self.load_frames;

        switch (Loading.admit(unit.state, frames.items.len)) {
            .Skip => return,
            .Cycle => return self.reporter.fail(.module, .{ .start = 0, .end = 0 }, "ZX module imports must be acyclic, including unused imports"),
            .Depth => return self.reporter.fail(.module, .{ .start = 0, .end = 0 }, "module dependency depth exceeds 256"),
            .Push => {},
        }

        unit.state = .Visiting;
        self.current_source = index;

        const parsed = try self.parse_cache.getModuleVersion(self.sources[index].source, unit.path);

        if (parsed.result.diagnostic()) |diagnostic| {
            var issue = diagnostic;
            issue.message = try self.allocator.dupe(u8, issue.message);
            issue.message_allocator = null;
            self.reporter.diagnostic = issue;

            return error.InvalidSource;
        }

        try frames.append(self.arena.child_allocator, .{ .index = index, .parsed = parsed });
    }
    fn loadInput(self: *Project, frame: *LoadFrame, input: anytype) zx.Error!?usize {
        const index = frame.index;
        const unit = &self.units[index];
        const header = input.header();
        const aliases = &frame.aliases;
        const imported_names = &frame.imported_names;
        const imports = &frame.imports;
        const constants = &frame.constant_imports;

        while (frame.next_import < header.importCount()) : (frame.next_import += 1) {
            const item = @import("import_view.zig").get(header, frame.next_import);
            const selected_aliases = if (item.exported) &frame.export_aliases else aliases;
            const selected_imports = if (item.exported) &frame.export_functions else imports;
            const selected_constants = if (item.exported) &frame.export_constants else constants;
            const pending = frame.pending;

            const target: ImportTarget = if (pending) |resumed| .{ .source = resumed.path } else target_block: {
                if (!item.exported) for (0..item.nameCount()) |name_index| {
                    const name = item.nameAt(name_index);
                    const entry = try imported_names.getOrPut(self.arena.child_allocator, name.text);

                    if (entry.found_existing) return self.reporter.fail(.name, name.span, "duplicate import binding");
                };

                const route = Target.classify(item.path);

                switch (route) {
                    .Invalid => return self.reporter.fail(.module, item.span, "invalid or unknown import specifier"),
                    .Intrinsic => {
                        try import_binding.apply(self.allocator, self.bindingAllocator(), item, .{
                            .target = .native,
                            .types = self.types.view(),
                            .exports = &.{},
                            .members = &@import("intrinsic.zig").exports,
                        }, self.reporter, selected_aliases, selected_imports, selected_constants);

                        try self.rememberImport(frame, item, .intrinsic, null);

                        continue;
                    },
                    .Interface => {
                        if (try self.importNative(item, selected_imports, selected_aliases, selected_constants)) |identity| {
                            try self.rememberImport(frame, item, .native, identity);

                            continue;
                        }

                        if (item.kind != .function or item.nameCount() != 1) return self.reporter.fail(.module, item.span, "external interfaces require a default function import");
                        try self.importExternal(item, imports);
                        try self.rememberImport(frame, item, .external, null);

                        continue;
                    },
                    .File, .Package => break :target_block try Target.resolve(self.allocator, unit.path, item.path, route, self.options, self.reporter, item.span),
                }
            };

            const imported = switch (target) {
                .source => |path| block: {
                    if (pending == null) switch (Loading.source(path, self.phase, item.kind == .function, item.exported)) {
                        .Load => {},
                        .SkipSignature => continue,
                        .DeferSignature => break :block Imported{ .exports = &.{}, .signatures = &.{.{ .name = "", .ports = null, .source = path }} },
                        .RejectRx => return self.reporter.fail(.module, item.span, "ZX package entry must be a .zx source file"),
                    };

                    const dependency = if (pending) |resumed| resumed.index else self.find(path) orelse return self.reporter.fail(.module, item.span, "import target is missing from the source set");

                    if (self.units[dependency].state != .Done) {
                        frame.pending = .{ .path = path, .index = dependency };

                        return dependency;
                    }

                    if (self.phase == .signature) {
                        const signature = self.units[dependency].signature.?;

                        break :block Imported{ .exports = signature.exports, .constant_exports = signature.constant_exports, .signatures = signature.members };
                    }

                    const loaded = &self.units[dependency];

                    break :block Imported{ .exports = loaded.exports, .constant_exports = loaded.constants, .members = loaded.members };
                },
                .compiled => |value| try self.loadCompiled(value, item.span),
            };

            frame.pending = null;
            self.current_source = index;

            if (self.phase == .signature) {
                try self.bindSignature(frame, item, imported);
            } else try @import("binding.zig").apply(self.allocator, self.bindingAllocator(), item, .{
                .target = if (target == .source) .source else .compiled,
                .types = self.types.view(),
                .exports = imported.exports,
                .constant_exports = imported.constant_exports,
                .members = imported.members,
            }, self.reporter, selected_aliases, selected_imports, selected_constants);

            try self.rememberImport(frame, item, switch (target) {
                .source => |path| .{ .source = path },
                .compiled => |value| .{ .compiled = value },
            }, null);
        }

        if (self.phase == .signature) {
            var types = @import("../analysis/types.zig"){
                .allocator = self.allocator,
                .reporter = self.reporter,
                .declarations = &.{},
                .aliases = aliases.items,
                .shared = .{ .origins = &self.nominal_origins, .origin = .{ .source = unit.path } },
                .items = self.types,
                .native_modules = self.native_modules.view(),
            };

            self.types = .{};
            defer self.types = types.items;
            unit.signature = try input.signature(&types, constants.items);

            try self.publishSignature(frame, &unit.signature.?);

            unit.signature_aliases = aliases.items;
            unit.signature_imports = imports.items;
            unit.signature_reexports = frame.export_functions.items;
            unit.signature_constant_imports = constants.items;
            unit.state = .Done;
        } else try self.finishInput(frame, input);

        return null;
    }
    fn rememberImport(self: *Project, frame: *LoadFrame, item: anytype, target: ModuleRecord.Target, identity: ?[]const u8) zx.Error!void {
        if (self.phase == .signature) return;

        var dependency = try ModuleRecord.copyImport(self.allocator, item, target);

        if (identity) |name| dependency.identity = try self.allocator.dupe(u8, name);
        try frame.dependencies.append(self.allocator, dependency);
    }
    fn bindSignature(self: *Project, frame: *LoadFrame, item: anytype, imported: Imported) zx.Error!void {
        const temporary = self.bindingAllocator();
        const signatures = if (imported.signatures.len != 0) imported.signatures else try self.memberSignatures(temporary, imported.members);
        const names = try temporary.alloc([]const u8, signatures.len);

        for (signatures, names) |member, *name| name.* = member.name;

        const symbols = import_binding.Symbols{ .target = .source, .types = self.types.view(), .exports = imported.exports, .constants = imported.constant_exports, .functions = names };
        const selected = try import_binding.select(temporary, self.allocator, item, &symbols, self.reporter);
        const aliases = if (item.exported) &frame.export_aliases else &frame.aliases;
        const constants = if (item.exported) &frame.export_constants else &frame.constant_imports;

        for (selected.aliases.names, selected.aliases.indices) |name, index| {
            try aliases.append(self.allocator, .{ .name = try self.allocator.dupe(u8, name), .type_id = imported.exports[@intCast(index)].type_id });
        }

        for (selected.constants.names, selected.constants.indices) |name, index| {
            var value = try @import("../analysis/constants/copy.zig").copy(self.allocator, imported.constant_exports[@intCast(index)]);

            value.name = try self.allocator.dupe(u8, name);

            try constants.append(self.allocator, value);
        }

        if (item.exported) for (selected.functions.names, selected.functions.indices) |name, index| {
            var member = signatures[@intCast(index)];

            member.name = try self.allocator.dupe(u8, name);

            try frame.signature_members.append(self.allocator, member);
        };
    }

    fn memberSignatures(self: *Project, allocator: std.mem.Allocator, members: []const FunctionImport) std.mem.Allocator.Error![]const Signature.Member {
        const result = try allocator.alloc(Signature.Member, members.len);

        self.writeMemberSignatures(members, result);

        return result;
    }

    fn writeMemberSignatures(self: *const Project, members: []const FunctionImport, result: []Signature.Member) void {
        for (members, result) |member, *signature| {
            if (member.intrinsic) |operation| {
                signature.* = .{ .name = member.name, .ports = null, .intrinsic = operation };
            } else {
                const function = self.functions.at(@backingInt(member.id.?));
                signature.* = .{ .name = member.name, .ports = .{ .input_type = member.input_type.?, .output_type = member.output_type.? }, .has_store = function.stores.count() != 0 };
            }
        }
    }
    fn publishSignature(self: *Project, frame: *LoadFrame, signature: *Signature.Result) zx.Error!void {
        const own: usize = @intFromBool(!signature.type_only);
        const forwarded = frame.signature_members.items;
        const native = frame.export_functions.items;
        const members = try self.allocator.alloc(Signature.Member, own + forwarded.len + native.len);

        if (own != 0) members[0] = .{ .name = "", .ports = signature.ports, .has_store = signature.has_store };

        @memcpy(members[own..][0..forwarded.len], forwarded);
        self.writeMemberSignatures(native, members[own + forwarded.len ..]);

        signature.exports = try PublicExports.merge(ir.Export, self.allocator, signature.exports, frame.export_aliases.items);
        signature.constant_exports = try PublicExports.merge(ir.Constant, self.allocator, signature.constant_exports, frame.export_constants.items);
        signature.members = members;

        if (frame.export_aliases.items.len + frame.export_constants.items.len + forwarded.len + native.len == 0) return;

        const selected = try PublicExports.plan(self.allocator, self.arena.child_allocator, signature.exports, signature.constant_exports, members, self.reporter) orelse return;
        const member = members[selected];

        const ports = member.ports orelse {
            if (member.source != null or member.intrinsic != null) return;

            return self.reporter.fail(.module, .{ .start = 0, .end = 0 }, "a default re-export requires a callable source");
        };

        signature.ports = ports;
        signature.has_store = member.has_store;
        signature.type_only = false;
    }

    fn finishInput(self: *Project, frame: *LoadFrame, input: anytype) zx.Error!void {
        const unit = &self.units[frame.index];
        const aliases = frame.aliases;
        const imports = frame.imports;
        const dependencies = frame.dependencies;
        const source_digest = frame.parsed.digest;
        const entry = std.mem.eql(u8, unit.path, self.options.entry);
        const first_type = self.types.count();
        var restored: ?@import("semantic_cache/restore.zig").Restored = null;

        if (self.semantic_cache) |cache| {
            unit.context_digest = try self.contextDigest(entry);

            if (SemanticCache.entry_store.find(&cache.entries, unit.path, source_digest, unit.context_digest)) |cached| {
                if (try @import("semantic_cache/restore.zig").restore(cached, .{
                    .allocator = self.allocator,
                    .backing = self.arena.child_allocator,
                    .types = &self.types,
                    .origins = &self.nominal_origins,
                    .functions = &self.functions,
                    .verified_functions = self.verified_functions,
                    .verified_types = self.verified_types,
                    .native_modules = self.native_modules.view(),
                    .aliases = aliases.items,
                    .imports = imports.items,
                    .constant_imports = frame.constant_imports.items,
                    .dependencies = dependencies.items,
                })) |program| {
                    restored = program;

                    if (comptime @import("parser_options").generated_parser) {
                        self.verified_functions = program.program.functions.count();
                        self.verified_types = Validate.TypePrefix.fromTable(program.program.types);
                    }

                    unit.reused = true;
                    cache.reused += 1;
                }
            }

            if (restored == null) cache.analyzed += 1;
        }

        var program = if (restored) |result| result.program else analyze_block: {
            var analyzer = HostContext{
                .allocator = self.allocator,
                .reporter = self.reporter,
                .mode = .project,
                .base_types = self.types.view(),
                .base_origins = self.nominal_origins.items.view(),
                .native_modules = self.native_modules.view(),
                .types = &self.types,
                .aliases = aliases.items,
                .origins = &self.nominal_origins,
                .origin = .{ .source = unit.path },
                .function_imports = imports.items,
                .constant_imports = frame.constant_imports.items,
                .functions = self.functions.view(),
                .store_bindings = if (entry) self.options.context.stores else &.{},
                .store_type_count = self.options.context.types.count(),
            };

            break :analyze_block try input.analyze(&analyzer, unit.path);
        };

        const publication = try @import("project/publication/host.zig").module(&program, entry, input.header().functionName() != null, self.functions.count(), if (restored) |*value| value else null);

        unit.function = publication.id;

        if (publication.append) try self.functions.append(self.allocator, @import("function_body.zig").value(program));

        if (restored == null and !@TypeOf(input).completes_ownership) {
            const recursive = publication.publication == .RecursiveEntry or publication.publication == .RecursiveDependency;
            const count = self.functions.count() - @intFromBool(!program.type_only and !recursive);

            program.functions = self.functions.view().prefix(count);
            program.output_ownership = try @import("../ownership/check.zig").analyze(self.allocator, program, self.reporter);

            if (unit.function) |id| self.functions.ownership.items[@backingInt(id)] = switch (program.output_ownership) {
                .copy => .Copy,
                .borrowed => .Borrowed,
                .owned => .Owned,
            };
        }

        const own: ?FunctionImport = if (unit.function) |id| .{ .name = "", .id = id, .input_type = program.input_type, .output_type = program.output_type } else null;
        unit.exports = try PublicExports.merge(ir.Export, self.allocator, program.exports, frame.export_aliases.items);
        unit.constants = try PublicExports.merge(ir.Constant, self.allocator, program.constant_exports, frame.export_constants.items);
        unit.members = try PublicExports.prepend(FunctionImport, self.allocator, own, frame.export_functions.items);

        if (frame.export_aliases.items.len + frame.export_constants.items.len + frame.export_functions.items.len != 0) {
            const selected = try PublicExports.plan(self.allocator, self.arena.child_allocator, unit.exports, unit.constants, unit.members, self.reporter);

            if (unit.function == null) if (selected) |member| {
                unit.function = unit.members[member].id;
            };
        }

        try self.modules.append(self.allocator, .{
            .path = unit.path,
            .source_digest = source_digest,
            .type_range = .{ .start = first_type, .end = program.types.count() },
            .exports = program.exports,
            .constant_exports = program.constant_exports,
            .reexports = .{ .types = frame.export_aliases.items, .constants = frame.export_constants.items, .functions = frame.export_functions.items },
            .constant_imports = frame.constant_imports.items,
            .imports = dependencies.items,
            .type_imports = aliases.items,
            .function_imports = imports.items,
            .body = switch (publication.publication) {
                .Types => .types,
                .Entry, .RecursiveEntry => .entry,
                .Dependency, .RecursiveDependency => .{ .function = unit.function.? },
            },
            .own_function = switch (publication.publication) {
                .RecursiveEntry, .RecursiveDependency => unit.function,
                else => null,
            },
        });

        if (entry) {
            program.types = .{};
            program.functions = .{};
            self.entry_program = program;
        }

        unit.state = .Done;
    }

    fn contextDigest(self: *Project, entry: bool) std.mem.Allocator.Error![32]u8 {
        if (entry) return SemanticCache.contextDigest(self.allocator, self.options.context);
        if (self.empty_context_digest) |digest| return digest;

        const digest = try SemanticCache.contextDigest(self.allocator, .{});

        self.empty_context_digest = digest;

        return digest;
    }
    fn loadCompiled(self: *Project, target: compiled.Target, span: zx.Span) zx.Error!Imported {
        const index = switch (try compiled.resolve.library(self.allocator, self.options.compiled_libraries, self.options.root_dir, target)) {
            .found => |value| value,
            .conflict => return self.reporter.fail(.module, span, "compiled package instance has conflicting artifacts"),
            .missing => return self.reporter.fail(.module, span, "compiled library is missing from the input set"),
        };

        const exports = self.compiled_units.get(index) orelse block: {
            const value = compiled.loadInto(self.allocator, self.options.compiled_libraries[index], .{
                .types = &self.types,
                .origins = &self.nominal_origins,
                .functions = &self.functions,
                .native_modules = &self.native_modules,
            }) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return self.reporter.fail(.module, span, "compiled library has invalid IR or conflicting identities");
            };

            try self.store_initializers.appendSlice(self.allocator, value.store_initializers);
            try self.compiled_units.put(self.allocator, index, value.exports);

            break :block value.exports;
        };

        for (exports) |exported| {
            if (!std.mem.eql(u8, exported.name, target.name)) continue;

            const function = if (exported.function) |id| self.functions.at(@backingInt(id)) else null;
            const own: ?FunctionImport = if (exported.function) |id| .{ .name = "", .id = id, .input_type = function.?.input_type, .output_type = function.?.output_type } else null;

            return .{
                .exports = exported.types,
                .constant_exports = exported.constants,
                .members = try PublicExports.prepend(FunctionImport, self.allocator, own, exported.members),
            };
        }

        return self.reporter.fail(.module, span, "compiled library does not export this public module");
    }
    fn find(self: *Project, path: []const u8) ?usize {
        return self.unit_indices.get(path);
    }

    /// Indexes the unit paths for `find`; reports whether they are unique.
    fn indexUnits(self: *Project) std.mem.Allocator.Error!bool {
        var unique = true;

        self.unit_indices = try source_index.Map.init(self.arena.child_allocator, self.units.len);

        for (self.units, 0..) |unit, index| {
            if (!self.unit_indices.claim(index, unit.path)) unique = false;
        }

        return unique;
    }
    fn nativeModule(self: *Project, source: []const u8, identity: ?[]const u8, name: []const u8, span: zx.Span) zx.Error!ir.NativeModuleId {
        if (name.len == 0 or std.mem.indexOfScalar(u8, name, 0) != null or !std.unicode.utf8ValidateSlice(name)) return self.reporter.fail(.module, span, "native import names must be nonempty UTF-8 strings");

        for (0..self.native_modules.count()) |index| {
            const module = self.native_modules.at(index);

            if (std.mem.eql(u8, module.key(), identity orelse source) and std.mem.eql(u8, module.import_name, name)) return @fromBackingInt(@intCast(index));
        }

        const id: ir.NativeModuleId = @fromBackingInt(@intCast(self.native_modules.count()));

        try self.native_modules.append(self.allocator, .{ .specifier = try self.allocator.dupe(u8, source), .identity = if (identity) |key| try self.allocator.dupe(u8, key) else null, .import_name = try self.allocator.dupe(u8, name) });

        self.verified_functions = 0;

        return id;
    }
    fn importNative(self: *Project, item: anytype, imports: *std.ArrayList(FunctionImport), aliases: *std.ArrayList(ir.Export), constants: *std.ArrayList(ir.Constant)) zx.Error!?[]const u8 {
        const path = self.units[self.current_source].path;
        const scoped = package_scope.nativeInterfaces(self.options.package_scopes, path, self.options.native_interfaces);

        const entry = switch (target_registry.native(scoped, item.path, true)) {
            .missing => return null,
            .duplicate => return self.reporter.fail(.module, item.span, "duplicate native interface module"),
            .found => |value| value.*,
        };

        for (package_scope.externals(self.options.package_scopes, path, self.options.externals)) |legacy| {
            if (std.mem.eql(u8, legacy.specifier, item.path)) return self.reporter.fail(.module, item.span, "native declarations conflict with legacy external signatures");
        }

        const unit = self.native_units.get(entry.key()) orelse blk: {
            const module_id = try self.nativeModule(entry.specifier, entry.identity, entry.module, item.span);

            const loaded = if (self.semantic_cache) |cache|
                try cache.native.load(self.allocator, entry, .{ .module = module_id, .types = &self.types, .origins = &self.nominal_origins }, self.reporter, item.span)
            else
                try @import("native.zig").load(self.arena, entry, module_id, &self.types, &self.nominal_origins, self.reporter, item.span);

            const namespace = try self.allocator.alloc([]const u8, entry.namespace.len);

            for (entry.namespace, namespace) |part, *owned| owned.* = try self.allocator.dupe(u8, part);

            const bindings = try ir.NativeBindings.fromValues(self.allocator, loaded.exports);
            const native_index = @backingInt(module_id);

            self.verified_functions = 0;
            self.native_modules.type_namespaces.items[native_index] = namespace;
            self.native_modules.type_names.items[native_index] = bindings.names;
            self.native_modules.type_ids.items[native_index] = bindings.type_ids;

            const members = try self.allocator.alloc(FunctionImport, loaded.members.len);

            for (loaded.members, members) |member, *binding| {
                const id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

                try self.functions.append(self.allocator, member.function);

                binding.* = .{ .name = member.name, .id = id, .input_type = member.function.input_type, .output_type = member.function.output_type };
            }

            const result = NativeUnit{ .exports = loaded.exports, .members = members };

            try self.native_units.put(self.allocator, try self.allocator.dupe(u8, entry.key()), result);

            break :blk result;
        };

        try @import("binding.zig").apply(self.allocator, self.bindingAllocator(), item, .{
            .target = .native,
            .types = self.types.view(),
            .exports = unit.exports,
            .members = unit.members,
        }, self.reporter, aliases, imports, constants);

        return entry.key();
    }
    fn importExternal(self: *Project, item: anytype, imports: *std.ArrayList(FunctionImport)) zx.Error!void {
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

            const imported = try @import("external.zig").load(self.allocator, entry, try self.nativeModule(entry.specifier, entry.identity, entry.implementation.module, item.span), item.span, &self.types, shared, self.reporter);
            const function_id: ir.FunctionId = @fromBackingInt(@intCast(self.functions.count()));

            try self.functions.append(self.allocator, imported.function);

            try imports.append(self.allocator, .{
                .namespace = if (entry.export_name != null) try self.allocator.dupe(u8, item.nameAt(0).text) else null,
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

pub fn analyzeSignatures(allocator: std.mem.Allocator, sources: []const Source, entries: []const []const u8, options: Options) std.mem.Allocator.Error!signature_project.Result {
    return analyzeSignaturesWithCache(allocator, sources, entries, options, null);
}

/// A shared cache must outlive the returned signatures, since they may borrow parsed syntax.
pub fn analyzeSignaturesWithCache(allocator: std.mem.Allocator, sources: []const Source, entries: []const []const u8, options: Options, shared: ?*ParseCache) std.mem.Allocator.Error!signature_project.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    var local = ParseCache{ .allocator = owned };

    defer local.deinit();

    const cache = shared orelse &local;
    var reporter: zx.Reporter = .{};

    const state = switch (try State.open(owned, &options.context)) {
        .state => |state| state,
        .diagnostic => |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } },
    };

    const units = try owned.alloc(Unit, sources.len);

    for (sources, 0..) |source, index| units[index] = .{ .path = try std.fs.path.resolve(owned, &.{ options.root_dir, source.path }) };

    var project = Project{ .binding_scratch = std.heap.ArenaAllocator.init(allocator), .arena = &arena, .allocator = owned, .sources = sources, .parse_cache = cache, .phase = .signature, .units = units, .options = options, .reporter = &reporter, .types = state.types, .native_modules = state.native_modules, .nominal_origins = state.origins };

    defer project.deinitScratch();

    if (!try project.indexUnits()) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "source paths must be unique after normalization" } } };

    project.options.source_index = &project.unit_indices;

    const modules = try owned.alloc(signature_project.Module, entries.len);

    for (entries, modules) |entry, *module| {
        const path = try std.fs.path.resolve(owned, &.{ options.root_dir, entry });
        const index = project.find(path) orelse return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "signature entry module is missing" } } };

        project.loadFrames(index) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            var issue = reporter.diagnostic.?;
            issue.source_index = project.current_source;

            return .{ .arena = arena, .value = .{ .diagnostic = issue } };
        };

        module.* = .{
            .path = units[index].path,
            .signature = units[index].signature.?,
            .type_imports = units[index].signature_aliases,
            .function_imports = units[index].signature_imports,
            .reexport_functions = units[index].signature_reexports,
            .constant_imports = units[index].signature_constant_imports,
        };
    }

    const libraries = try owned.alloc(signature_project.Library, project.compiled_units.count());
    var iterator = project.compiled_units.iterator();

    for (libraries) |*library| {
        const entry = iterator.next().?;

        library.* = .{ .index = entry.key_ptr.*, .exports = entry.value_ptr.* };
    }

    return .{ .arena = arena, .value = .{ .data = .{
        .types = project.types.view(),
        .nominal_types = project.nominal_origins.items.view(),
        .native_modules = project.native_modules.view(),
        .functions = project.functions.view(),
        .store_initializers = project.store_initializers.items,
        .modules = modules,
        .libraries = libraries,
    } } };
}

fn analyzeWithCaches(allocator: std.mem.Allocator, raw_sources: []const Source, options: Options, cache: *ParseCache, semantic_cache: ?*SemanticCache) std.mem.Allocator.Error!Analysis.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const temporary = arena.allocator();
    var reporter: zx.Reporter = .{};

    const sources = switch (try prepareSources(temporary, raw_sources, options)) {
        .sources => |items| items,
        .diagnostic => |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } },
    };

    const state = switch (try State.open(temporary, &options.context)) {
        .state => |state| state,
        .diagnostic => |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } },
    };

    const units = try temporary.alloc(Unit, sources.len);

    for (sources, 0..) |source, index| units[index] = .{ .path = try std.fs.path.resolve(temporary, &.{ options.root_dir, source.path }) };

    var normalized = options;
    normalized.entry = try std.fs.path.resolve(temporary, &.{ options.root_dir, options.entry });
    var project = Project{ .binding_scratch = std.heap.ArenaAllocator.init(allocator), .arena = &arena, .allocator = temporary, .sources = sources, .parse_cache = cache, .semantic_cache = if (options.compiled_libraries.len == 0) semantic_cache else null, .units = units, .options = normalized, .reporter = &reporter, .types = state.types, .native_modules = state.native_modules, .nominal_origins = state.origins };

    defer project.deinitScratch();

    if (!try project.indexUnits()) return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "source paths must be unique after normalization" } } };

    project.options.source_index = &project.unit_indices;
    const root = project.find(normalized.entry) orelse return .{ .arena = arena, .value = .{ .diagnostic = .{ .code = .module, .span = .{ .start = 0, .end = 0 }, .message = "entry module is missing" } } };

    var program = project.load(root) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        var issue = try resources.diagnostic(temporary, sources[project.current_source], reporter.diagnostic.?);
        issue.source_index = project.current_source;

        return .{ .arena = arena, .value = .{ .diagnostic = issue } };
    };

    program.types = project.types.view();
    program.native_modules = project.native_modules.view();
    const publication = @import("project/publication/host.zig").finalize(&program, project.units[root].function, project.functions.count());

    program.functions = project.functions.view().prefix(publication.visible_count);

    if (publication.forward) |id| try @import("function_body.zig").entry(temporary, &program, id);
    if (try Validate.validateProjectPrefix(allocator, program, @min(publication.visible_count, project.verified_functions), project.verified_types)) |issue| return .{ .arena = arena, .value = .{ .diagnostic = issue } };

    var result = Analysis.Result{ .arena = arena, .value = .{ .ir = program }, .nominal_types = project.nominal_origins.items.view(), .modules = project.modules.items, .store_initializers = project.store_initializers.items };

    if (project.semantic_cache) |semantic| {
        var scratch = zx.Arena.init(allocator);

        defer scratch.deinit();

        for (result.modules) |module| {
            const unit = project.units[project.find(module.path).?];

            if (unit.reused) continue;

            defer scratch.reset(std.math.maxInt(usize));

            var extracted = @import("artifact/extract.zig").validated(semantic.allocator, scratch.allocator(), &result, module) catch |err| {
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

pub const resolvePath = Target.resolvePath;

pub fn resolveImport(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    return switch (try resolveTarget(allocator, from, path, options, reporter, span)) {
        .source => |source| source,
        .compiled => reporter.fail(.module, span, "compiled package imports require structured target loading"),
    };
}

pub fn resolveTarget(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error!ImportTarget {
    const target = try resolveModuleTarget(allocator, from, path, options, reporter, span);

    if (target == .source and !std.mem.endsWith(u8, target.source, ".zx")) return reporter.fail(.module, span, "ZX package entry must be a .zx source file");

    return target;
}

pub const ModuleReference = struct { target: ImportTarget, file: bool };

pub fn resolveModuleReference(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error!ModuleReference {
    const route = Target.classify(path);

    return .{
        .target = try Target.resolve(allocator, from, path, route, options, reporter, span),
        .file = route == .File,
    };
}

pub fn resolveModuleTarget(allocator: std.mem.Allocator, from: []const u8, path: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error!ImportTarget {
    return (try resolveModuleReference(allocator, from, path, options, reporter, span)).target;
}

pub fn selectSource(allocator: std.mem.Allocator, candidate: []const u8, options: Options) std.mem.Allocator.Error![]const u8 {
    return Target.select(allocator, candidate, options.source_index);
}

pub fn checkFileTarget(from: []const u8, target: []const u8, options: Options, reporter: *zx.Reporter, span: zx.Span) zx.Error!void {
    return Target.checkFile(from, target, options.package_scopes, reporter, span);
}
