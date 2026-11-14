//! The RX modules a resident generator parsed last, kept while every path and text stays the same: parsing and
//! validating them takes longer than the rest of the setup of a build that changed none. A replaced parse stays alive
//! until `release`, since analyses may point into its nodes.
const std = @import("std");
const rx = @import("rx");
const bytes = @import("compiler").bytes;
const Self = @This();

gpa: std.mem.Allocator,
current: ?rx.TextResult = null,
packages: [32]u8 = undefined,
/// The paths and texts `current` was parsed from, in turn.
texts: std.ArrayList([]u8) = .empty,
replaced: std.ArrayList(rx.TextResult) = .empty,
pub fn deinit(self: *Self) void {
    self.release();
    self.replaced.deinit(self.gpa);
    self.forget();
    self.texts.deinit(self.gpa);
    if (self.current) |*parsed| parsed.deinit();
}

/// The parse of `sources`; the kept one while their paths and texts match it.
pub fn parse(self: *Self, sources: []const rx.TextSource, packages: [32]u8) !*const rx.TextResult {
    if (self.current != null and bytes.equal(&self.packages, &packages) and self.matches(sources)) return &self.current.?;

    var parsed = try rx.parseModules(self.gpa, sources);

    errdefer parsed.deinit();

    if (self.current != null) try self.replaced.ensureUnusedCapacity(self.gpa, 1);

    var texts: std.ArrayList([]u8) = .empty;

    errdefer {
        for (texts.items) |text| self.gpa.free(text);

        texts.deinit(self.gpa);
    }

    try texts.ensureTotalCapacity(self.gpa, 2 * sources.len);

    for (sources) |source| {
        texts.appendAssumeCapacity(try self.gpa.dupe(u8, source.path));
        texts.appendAssumeCapacity(try self.gpa.dupe(u8, source.source));
    }

    if (self.current) |old| self.replaced.appendAssumeCapacity(old);

    self.forget();
    self.texts.deinit(self.gpa);

    self.texts = texts;
    self.current = parsed;
    self.packages = packages;

    return &self.current.?;
}

/// Frees the parses replaced since the last call.
pub fn release(self: *Self) void {
    for (self.replaced.items) |*parsed| parsed.deinit();

    self.replaced.clearRetainingCapacity();
}

fn matches(self: *const Self, sources: []const rx.TextSource) bool {
    if (self.texts.items.len != 2 * sources.len) return false;

    for (sources, 0..) |source, index| {
        if (!bytes.equal(self.texts.items[2 * index], source.path) or !bytes.equal(self.texts.items[2 * index + 1], source.source)) return false;
    }

    return true;
}

fn forget(self: *Self) void {
    for (self.texts.items) |text| self.gpa.free(text);

    self.texts.clearRetainingCapacity();
}
