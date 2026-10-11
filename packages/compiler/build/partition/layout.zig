const std = @import("std");
const signature = @import("signature.zig");

pub const File = struct { path: []const u8, source: []const u8 };

const Variants = std.ArrayList([]const u8);
const Demands = std.StringArrayHashMapUnmanaged(Variants);
const import_prefix = "@import(\"zxc_module_";

pub const bridge_source = @embedFile("bridge.zig");

/// Places generated function files into `count` separately compiled partitions. A function lives in the
/// partition its name hashes to, so an edit leaves the other partitions untouched. A call into another
/// partition, or from the shared top level, imports a forwarding stub of the same file name, and the owning
/// partition exports exactly the entries called from outside it. Inline functions expand in their caller's
/// unit, as in a single-unit build, so a caller's scope receives a copy of every file it calls inline.
pub fn plan(allocator: std.mem.Allocator, functions: []const File, top: []const File, count: u32) ![]File {
    var scopes = Scopes{ .allocator = allocator, .stubs = try allocator.alloc(Demands, count + 1), .copies = try allocator.alloc(Copies, count + 1) };

    @memset(scopes.stubs, .empty);
    @memset(scopes.copies, .empty);

    for (functions) |function| try scopes.owners.put(allocator, function.path, .{ .partition = partition(function.path, count), .source = function.source });

    for (functions) |function| try scopes.demand(scopes.owners.get(function.path).?.partition, function.source);
    for (top) |file| try scopes.demand(count, file.source);

    const owners = scopes.owners;
    var exports = scopes.exports;
    var files: std.ArrayList(File) = .empty;

    try files.append(allocator, .{ .path = "bridge.zig", .source = bridge_source });

    for (functions) |function| try files.append(allocator, .{ .path = try directory(allocator, owners.get(function.path).?.partition, count, function.path), .source = function.source });

    for (scopes.copies, 0..) |copies, index| {
        for (copies.keys()) |callee| try files.append(allocator, .{ .path = try directory(allocator, @intCast(index), count, callee), .source = owners.get(callee).?.source });
    }

    var signatures: std.StringHashMapUnmanaged([]const u8) = .empty;

    for (scopes.stubs, 0..) |scope, index| {
        for (scope.keys(), scope.values()) |callee, variants| {
            if (scopes.copies[index].contains(callee)) continue;

            try files.append(allocator, .{
                .path = try directory(allocator, @intCast(index), count, callee),
                .source = try stub(allocator, &signatures, callee, owners.get(callee).?.source, variants.items),
            });
        }
    }

    const roots = try allocator.alloc(std.Io.Writer.Allocating, count);

    for (roots) |*root| {
        root.* = .init(allocator);

        try root.writer.writeAll("const bridge = @import(\"zxc_bridge\");\n\ncomptime {\n");
    }

    exports.sort(SortByName{ .keys = exports.keys() });

    for (exports.keys(), exports.values()) |callee, variants| {
        const writer = &roots[owners.get(callee).?.partition].writer;

        for (variants.items) |variant| try writer.print("    bridge.exportAs(@import(\"{s}\").{s}, \"{s}\");\n", .{ callee, variant, try symbol(allocator, callee, variant) });
    }

    for (roots, 0..) |*root, index| {
        try root.writer.writeAll("}\n");
        try files.append(allocator, .{ .path = try std.fmt.allocPrint(allocator, "part_{d}/root.zig", .{index}), .source = root.written() });
    }

    return files.items;
}

fn partition(name: []const u8, count: u32) u32 {
    return @intCast(std.hash.Wyhash.hash(0, name) % count);
}

fn directory(allocator: std.mem.Allocator, scope: u32, count: u32, name: []const u8) ![]const u8 {
    if (scope == count) return name;

    return std.fmt.allocPrint(allocator, "part_{d}/{s}", .{ scope, name });
}

fn symbol(allocator: std.mem.Allocator, callee: []const u8, variant: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}_{s}", .{ callee[0 .. callee.len - ".zig".len], variant });
}

const Copies = std.StringArrayHashMapUnmanaged(void);

const Scopes = struct {
    allocator: std.mem.Allocator,
    owners: std.StringHashMapUnmanaged(struct { partition: u32, source: []const u8 }) = .empty,
    stubs: []Demands,
    copies: []Copies,
    exports: Demands = .empty,
    inline_variants: std.StringHashMapUnmanaged([]const []const u8) = .empty,

    fn inlined(self: *Scopes, callee: []const u8, source: []const u8, variant: []const u8) !bool {
        const entry = try self.inline_variants.getOrPut(self.allocator, callee);

        if (!entry.found_existing) entry.value_ptr.* = try signature.inlineNames(self.allocator, source);

        for (entry.value_ptr.*) |name| if (std.mem.eql(u8, name, variant)) return true;

        return false;
    }

    /// Records every call from `scope` into a function owned by another scope.
    fn demand(self: *Scopes, scope: u32, source: []const u8) !void {
        var cursor: usize = 0;

        while (std.mem.indexOfPos(u8, source, cursor, import_prefix)) |at| {
            const name_start = at + "@import(\"".len;
            const quote = std.mem.indexOfScalarPos(u8, source, name_start, '"') orelse return error.UnterminatedImport;
            const callee = source[name_start..quote];
            var member = quote + 1;

            while (member < source.len and source[member] == ')') member += 1;

            if (member >= source.len or source[member] != '.') return error.UnsupportedFunctionReference;

            const variant_start = member + 1;
            var variant_end = variant_start;

            while (variant_end < source.len and (std.ascii.isAlphanumeric(source[variant_end]) or source[variant_end] == '_')) variant_end += 1;

            cursor = variant_end;

            const owner = self.owners.get(callee) orelse return error.MissingFunctionFile;

            if (owner.partition == scope) continue;

            const variant = source[variant_start..variant_end];

            if (try self.inlined(callee, owner.source, variant)) {
                if ((try self.copies[scope].getOrPut(self.allocator, callee)).found_existing) continue;

                try self.demand(scope, owner.source);

                continue;
            }

            try add(self.allocator, &self.stubs[scope], callee, variant);
            try add(self.allocator, &self.exports, callee, variant);
        }
    }
};

fn add(allocator: std.mem.Allocator, demands: *Demands, callee: []const u8, variant: []const u8) !void {
    const entry = try demands.getOrPut(allocator, callee);

    if (!entry.found_existing) entry.value_ptr.* = .empty;

    for (entry.value_ptr.items) |known| if (std.mem.eql(u8, known, variant)) return;

    try entry.value_ptr.append(allocator, variant);
}

/// `signatures` memoizes function types by exported symbol, since every scope calling a function stubs it.
fn stub(allocator: std.mem.Allocator, signatures: *std.StringHashMapUnmanaged([]const u8), callee: []const u8, source: []const u8, variants: []const []const u8) ![]const u8 {
    var output: std.Io.Writer.Allocating = .init(allocator);

    try output.writer.writeAll("const std = @import(\"std\");\n\nconst zx_abi = @import(\"zxc_abi\");\n\nconst bridge = @import(\"zxc_bridge\");\n");

    for (variants) |variant| {
        const name = try symbol(allocator, callee, variant);
        const entry = try signatures.getOrPut(allocator, name);

        if (!entry.found_existing) entry.value_ptr.* = try signature.find(allocator, source, variant) orelse {
            std.debug.print("{s}: no public function {s}\n", .{ callee, variant });

            return error.MissingFunctionSignature;
        };

        try output.writer.print("\npub const {s} = bridge.import({s}, \"{s}\");\n", .{ variant, entry.value_ptr.*, name });
    }

    return output.written();
}

const SortByName = struct {
    keys: []const []const u8,
    pub fn lessThan(self: SortByName, left: usize, right: usize) bool {
        return std.mem.lessThan(u8, self.keys[left], self.keys[right]);
    }
};
