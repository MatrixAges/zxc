//! The RX modules a resident generator parsed last, kept while every path and text stays the same: parsing and
//! validating them takes longer than the rest of the setup of a build that changed none. A replaced parse stays alive
//! until `release`, since analyses may point into its nodes.
const std = @import("std");
const rx = @import("rx");
const bytes = @import("compiler").bytes;
const Self = @This();

gpa: std.mem.Allocator,
current: ?rx.TextResult = null,
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
pub fn parse(self: *Self, sources: []const rx.TextSource) !*const rx.TextResult {
    if (self.current != null and self.matches(sources)) return &self.current.?;

    var parsed = try rx.parseModules(self.gpa, sources);

    errdefer parsed.deinit();

    try self.replaced.ensureUnusedCapacity(self.gpa, 1);

    self.forget();

    for (sources) |source| {
        try self.texts.append(self.gpa, try self.gpa.dupe(u8, source.path));
        try self.texts.append(self.gpa, try self.gpa.dupe(u8, source.source));
    }

    if (self.current) |old| self.replaced.appendAssumeCapacity(old);

    self.current = parsed;

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
