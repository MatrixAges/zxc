const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const parse = @import("../frontend/parse.zig").parse;
const Analyzer = @import("../analysis/analyzer.zig");
const Analysis = @import("../analysis/analyze.zig");
pub const Source = struct { path: []const u8, source: []const u8 };
pub const External = struct { specifier: []const u8, signature: []const u8, implementation: ir.External };
pub const Options = struct { externals: []const External = &.{}, entry: []const u8, root_dir: []const u8 = ".", context: Analysis.Context = .{} };
const Unit = struct { path: []const u8, state: enum { fresh, visiting, done } = .fresh, program: ?ir.Program = null, function: ?ir.FunctionId = null };

const Project = struct {
    allocator: std.mem.Allocator,
    sources: []const Source,
    units: []Unit,
    options: Options,
    reporter: *zx.Reporter,
    types: []const ir.Type = &.{},
    functions: std.ArrayList(ir.Function) = .empty,
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

        var parsed = try parse(self.allocator, self.sources[index].source, unit.path);

        defer parsed.deinit();

        if (parsed.value == .diagnostic) {
            self.reporter.diagnostic = parsed.value.diagnostic;

            return error.InvalidSource;
        }

        const input = parsed.value.parsed;
        var aliases: std.ArrayList(ir.Export) = .empty;
        var imported_names: std.StringHashMapUnmanaged(void) = .empty;
        var imports: std.ArrayList(Analyzer.FunctionImport) = .empty;

        for (input.ast.imports) |item| {
            for (item.names) |name| {
                const entry = try imported_names.getOrPut(self.allocator, name.text);

                if (entry.found_existing) return self.reporter.fail(.name, name.span, "duplicate import binding");
            }

            if (std.mem.startsWith(u8, item.path, "zig:") or std.mem.startsWith(u8, item.path, "lib:")) {
                if (item.kind != .function or item.names.len != 1) return self.reporter.fail(.module, item.span, "external interfaces require a default function import");

                const imported = try @import("external.zig").load(self.allocator, self.options.externals, item, self.types, self.reporter);
                self.types = imported.types;

                const function_id: ir.FunctionId = @enumFromInt(self.functions.items.len);

                try self.functions.append(self.allocator, imported.function);
                try imports.append(self.allocator, .{ .positional_types = if (imported.function.external.?.expand_tuple) self.types[@intFromEnum(imported.function.input_type)].tuple else null, .name = try self.allocator.dupe(u8, item.names[0].text), .id = function_id, .input_type = imported.function.input_type, .output_type = imported.function.output_type });

                continue;
            }

            const path = try resolvePath(self.allocator, unit.path, item.path, self.options.root_dir, self.reporter, item.span);
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
        }

        var analyzer = Analyzer{
            .allocator = self.allocator,
            .reporter = self.reporter,
            .types = .{ .allocator = self.allocator, .reporter = self.reporter, .declarations = input.ast.declarations, .aliases = aliases.items },
            .function_imports = imports.items,
            .store_bindings = if (std.mem.eql(u8, unit.path, self.options.entry)) self.options.context.stores else &.{},
        };

        try analyzer.types.items.appendSlice(self.allocator, self.types);

        const program = try analyzer.run(input.ast, unit.path);

        self.types = program.types;

        try @import("../ownership/check.zig").check(self.allocator, program, self.reporter);

        if (!program.type_only) {
            unit.function = @enumFromInt(self.functions.items.len);

            try self.functions.append(self.allocator, .{ .file_name = program.file_name, .input_type = program.input_type, .output_type = program.output_type, .symbols = program.symbols, .expressions = program.expressions, .body = program.body });
        }

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
};

pub fn analyze(allocator: std.mem.Allocator, sources: []const Source, options: Options) std.mem.Allocator.Error!Analysis.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const temporary = arena.allocator();
    var reporter: zx.Reporter = .{};
    const units = try temporary.alloc(Unit, sources.len);

    for (sources, 0..) |source, index| units[index] = .{ .path = try std.fs.path.resolve(temporary, &.{ options.root_dir, source.path }) };

    var normalized = options;
    normalized.entry = try std.fs.path.resolve(temporary, &.{ options.root_dir, options.entry });

    var project = Project{ .allocator = temporary, .sources = sources, .units = units, .options = normalized, .reporter = &reporter };

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
    program.functions = try temporary.dupe(ir.Function, project.functions.items[0 .. project.functions.items.len - @intFromBool(!program.type_only)]);

    return .{ .arena = arena, .value = .{ .ir = program } };
}

pub fn resolvePath(allocator: std.mem.Allocator, from: []const u8, path: []const u8, root: []const u8, reporter: *zx.Reporter, span: zx.Span) zx.Error![]const u8 {
    if (!std.mem.endsWith(u8, path, ".zx")) return reporter.fail(.module, span, "project imports must end in .zx; runtime and RX imports are forbidden");
    if (std.mem.startsWith(u8, path, "@/")) return std.fs.path.resolve(allocator, &.{ root, path[2..] });
    if (!std.mem.startsWith(u8, path, "./") and !std.mem.startsWith(u8, path, "../")) return reporter.fail(.module, span, "imports require ./, ../ or @/ paths; external interfaces require explicit registration");

    return std.fs.path.resolve(allocator, &.{ std.fs.path.dirname(from) orelse ".", path });
}
