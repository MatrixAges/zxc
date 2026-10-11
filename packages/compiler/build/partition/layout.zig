const std = @import("std");
const signature = @import("signature.zig");
const Scanning = @import("scanning.zig");
const parallel = @import("../parallel.zig");

pub const File = struct { path: []const u8, source: []const u8 };

const Variants = std.ArrayList([]const u8);
const Demands = std.AutoArrayHashMapUnmanaged(u32, Variants);
const Copies = std.AutoArrayHashMapUnmanaged(u32, void);

pub const bridge_source = @embedFile("bridge.zig");

/// Places generated function files into `count` separately compiled partitions. A function lives in the
/// partition its name hashes to, so an edit leaves the other partitions untouched. A call into another
/// partition, or from the shared top level, imports a forwarding stub of the same file name, and the owning
/// partition exports exactly the entries called from outside it. Inline functions expand in their caller's
/// unit, as in a single-unit build, so a caller's scope receives a copy of every file it calls inline.
pub fn plan(io: std.Io, allocator: std.mem.Allocator, functions: []const File, top: []const File, count: u32) ![]File {
    var indices: std.StringHashMapUnmanaged(u32) = .empty;

    try indices.ensureTotalCapacity(allocator, @intCast(functions.len));

    for (functions, 0..) |function, index| indices.putAssumeCapacity(function.path, @intCast(index));

    const partitions = try allocator.alloc(u32, functions.len);

    for (functions, partitions) |function, *owner| owner.* = partition(function.path, count);

    const arenas = try parallel.Arenas.init(io, allocator, functions.len);

    defer arenas.deinit();

    const scanning = try Scanning.run(allocator, arenas, functions, &indices);

    var scopes = Scopes{
        .allocator = allocator,
        .partitions = partitions,
        .references = scanning.references,
        .inline_names = scanning.inline_names,
        .stubs = try allocator.alloc(Demands, count + 1),
        .copies = try allocator.alloc(Copies, count + 1),
    };

    @memset(scopes.stubs, .empty);
    @memset(scopes.copies, .empty);

    for (partitions, scanning.references) |owner, references| try scopes.demand(owner, references);
    for (top) |file| try scopes.demand(count, try Scanning.scan(allocator, file.source, &indices));

    var exports = scopes.exports;
    var files: std.ArrayList(File) = .empty;

    try files.append(allocator, .{ .path = "bridge.zig", .source = bridge_source });

    for (functions, partitions) |function, owner| try files.append(allocator, .{ .path = try directory(allocator, owner, count, function.path), .source = function.source });

    for (scopes.copies, 0..) |copies, index| {
        for (copies.keys()) |callee| try files.append(allocator, .{ .path = try directory(allocator, @intCast(index), count, functions[callee].path), .source = functions[callee].source });
    }

    exports.sortUnstable(SortByName{ .keys = exports.keys(), .functions = functions });

    // Every stubbed variant is exported by its owner, so the signatures of the exports serve all stubs.
    const signatures = Signatures{ .functions = functions, .exports = &exports, .found = try allocator.alloc([]const ?[]const u8, exports.count()) };

    try parallel.each(arenas, exports.count(), &signatures);

    for (scopes.stubs, 0..) |scope, index| {
        for (scope.keys(), scope.values()) |callee, variants| {
            if (scopes.copies[index].contains(callee)) continue;

            const function = functions[callee];
            const exported = exports.getIndex(callee).?;

            try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, function.path),
                .source = try stub(allocator, function.path, variants.items, exports.values()[exported].items, signatures.found[exported]),
            });
        }
    }

    const roots = Roots{ .functions = functions, .partitions = partitions, .exports = &exports, .sources = try allocator.alloc([]const u8, count) };

    try parallel.each(arenas, count, &roots);

    for (roots.sources, 0..) |source, index| {
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/root.zig", .{index}), .source = try allocator.dupe(u8, source) });
    }

    return files.items;
}

/// The type of every exported variant, found in the exporting function's source.
const Signatures = struct {
    functions: []const File,
    exports: *const Demands,
    found: [][]const ?[]const u8,

    pub fn step(self: *const Signatures, allocator: std.mem.Allocator, index: usize) !void {
        const source = self.functions[self.exports.keys()[index]].source;
        const variants = self.exports.values()[index].items;
        const result = try allocator.alloc(?[]const u8, variants.len);

        for (variants, result) |variant, *found| found.* = try signature.find(allocator, source, variant);

        self.found[index] = result;
    }
};

/// The root of each partition, exporting its functions called from outside it in name order.
const Roots = struct {
    functions: []const File,
    partitions: []const u32,
    exports: *const Demands,
    sources: [][]const u8,

    pub fn step(self: *const Roots, allocator: std.mem.Allocator, index: usize) !void {
        var root: std.Io.Writer.Allocating = .init(allocator);

        try root.writer.writeAll("const bridge = @import(\"zxc_bridge\");\n\npub const panic = bridge.Panic;\n\ncomptime {\n");

        for (self.exports.keys(), self.exports.values()) |callee, variants| {
            if (self.partitions[callee] != index) continue;

            const name = self.functions[callee].path;

            for (variants.items) |variant| try root.writer.print("    bridge.exportAs(@import(\"{s}\").{s}, \"{s}_{s}\");\n", .{ name, variant, stem(name), variant });
        }

        try root.writer.writeAll("}\n");
        self.sources[index] = root.written();
    }
};

fn partition(name: []const u8, count: u32) u32 {
    return @intCast(std.hash.Wyhash.hash(0, name) % count);
}

fn directory(allocator: std.mem.Allocator, scope: u32, count: u32, name: []const u8) ![]const u8 {
    if (scope == count) return name;

    return std.fmt.allocPrint(allocator, "part_{d}/{s}", .{ scope, name });
}

/// A function file's name without its extension, which prefixes its exported symbols.
fn stem(callee: []const u8) []const u8 {
    return callee[0 .. callee.len - ".zig".len];
}

/// Functions are referred to by their index in the planned function list.
const Scopes = struct {
    allocator: std.mem.Allocator,
    partitions: []const u32,
    references: []const []const Scanning.Reference,
    inline_names: []const []const []const u8,
    stubs: []Demands,
    copies: []Copies,
    exports: Demands = .empty,

    /// Records every call from `scope` into a function owned by another scope.
    fn demand(self: *Scopes, scope: u32, calls: []const Scanning.Reference) !void {
        for (calls) |call| {
            if (self.partitions[call.callee] == scope) continue;

            if (inlined(self.inline_names[call.callee], call.variant)) {
                if ((try self.copies[scope].getOrPut(self.allocator, call.callee)).found_existing) continue;

                try self.demand(scope, self.references[call.callee]);

                continue;
            }

            try add(self.allocator, &self.stubs[scope], call.callee, call.variant);
            try add(self.allocator, &self.exports, call.callee, call.variant);
        }
    }
};

fn inlined(names: []const []const u8, variant: []const u8) bool {
    for (names) |name| if (std.mem.eql(u8, name, variant)) return true;

    return false;
}

fn add(allocator: std.mem.Allocator, demands: *Demands, callee: u32, variant: []const u8) !void {
    const entry = try demands.getOrPut(allocator, callee);

    if (!entry.found_existing) entry.value_ptr.* = .empty;

    for (entry.value_ptr.items) |known| if (std.mem.eql(u8, known, variant)) return;

    try entry.value_ptr.append(allocator, variant);
}

/// A forwarding file importing `variants` of `callee` from the partition that exports them; `signatures` holds the
/// type of each of the callee's `exported` variants.
fn stub(allocator: std.mem.Allocator, callee: []const u8, variants: []const []const u8, exported: []const []const u8, signatures: []const ?[]const u8) ![]const u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    try output.writer.writeAll("const std = @import(\"std\");\n\nconst zx_abi = @import(\"zxc_abi\");\n\nconst bridge = @import(\"zxc_bridge\");\n");

    for (variants) |variant| {
        const position = for (exported, 0..) |name, index| {
            if (std.mem.eql(u8, name, variant)) break index;
        } else unreachable;

        const found = signatures[position] orelse {
            std.debug.print("{s}: no public function {s}\n", .{ callee, variant });

            return error.MissingFunctionSignature;
        };

        try output.writer.print("\npub const {s} = bridge.import({s}, \"{s}_{s}\");\n", .{ variant, found, stem(callee), variant });
    }

    return output.written();
}

const SortByName = struct {
    keys: []const u32,
    functions: []const File,
    pub fn lessThan(self: SortByName, left: usize, right: usize) bool {
        return std.mem.lessThan(u8, self.functions[self.keys[left]].path, self.functions[self.keys[right]].path);
    }
};
