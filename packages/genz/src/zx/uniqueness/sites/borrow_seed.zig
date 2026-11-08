const std = @import("std");
const Seed = @import("seed.zig");
const Role = @import("../order.zig").Role;
const none = @import("../order.zig").none;
const Site = Seed.Site;

pub fn normalize(allocator: std.mem.Allocator, source: *Seed) std.mem.Allocator.Error!void {
    var candidates: std.ArrayList(usize) = .empty;

    for (source.sites, 0..) |site, index| if (eligible(source, site)) try candidates.append(allocator, index);
    if (candidates.items.len == 0) return;

    const first = try allocator.alloc(u32, source.first.len);
    var sites: std.ArrayList(Site) = .empty;
    var candidate: usize = 0;
    var serial = source.order.edgeCount();

    for (first[0 .. first.len - 1], 0..) |*start, root| {
        start.* = @intCast(sites.items.len);

        for (source.sites[source.first[root]..source.first[root + 1]], source.first[root]..) |original, index| {
            const selected = candidate < candidates.items.len and candidates.items[candidate] == index;
            var site = original;
            site.role = resolved(source, original);

            if (selected) {
                site.role = .observe;
                site.edge = std.math.cast(u32, serial) orelse return error.OutOfMemory;
                serial += 1;
            }

            try sites.append(allocator, site);

            if (!selected) continue;

            candidate += 1;
            const result = source.nodeRoot(@fromBackingInt(original.parent));

            for (source.sites[source.first[result]..source.first[result + 1]]) |observation| {
                var use = original;
                use.top = observation.top;
                use.parent = observation.parent;
                use.region = observation.region;
                use.arms = observation.arms;
                use.role = .observe;
                use.edge = std.math.cast(u32, serial) orelse return error.OutOfMemory;

                try sites.append(allocator, use);

                serial += 1;
            }
        }
    }

    first[first.len - 1] = @intCast(sites.items.len);
    source.first = first;
    source.sites = sites.items;
}

fn borrowOnly(source: *const Seed, callee: usize) bool {
    return source.summaries.return_only[callee] and source.summaries.held[callee].len == source.summaries.written[callee].len and
        std.mem.indexOfScalar(bool, source.summaries.written[callee], true) == null;
}

fn known(source: *const Seed, site: Site, callee: usize) bool {
    const first = @as(i64, site.lo) + site.delta;
    const end = @as(i64, site.hi) + site.delta;

    return first >= 0 and end <= @min(source.summaries.held[callee].len, source.summaries.written[callee].len);
}

fn resolved(source: *const Seed, site: Site) Role {
    if (site.role != .argument) return site.role;

    const callee = @backingInt(source.expressions.get(@fromBackingInt(site.parent)).value.call.function);
    const held = source.summaries.held[callee];
    const written = source.summaries.written[callee];
    const result = source.nodeRoot(@fromBackingInt(site.parent));

    if (known(source, site, callee) and borrowOnly(source, callee) and source.first[result] == source.first[result + 1]) return .observe;

    const count = @min(held.len, written.len);
    var consumed = true;
    var observed = true;

    for (held[0..count], written[0..count]) |retained, updated| {
        consumed = consumed and (retained or updated);
        observed = observed and !retained and !updated;
    }

    if (count == 0 or consumed) return .use;
    if (observed and known(source, site, callee)) return .observe;

    return .argument;
}

fn eligible(source: *const Seed, site: Site) bool {
    if (site.role != .argument) return false;

    const callee = @backingInt(source.expressions.get(@fromBackingInt(site.parent)).value.call.function);

    if (!borrowOnly(source, callee) or !known(source, site, callee)) return false;

    const first: usize = @intCast(@as(i64, site.lo) + site.delta);
    const end: usize = @intCast(@as(i64, site.hi) + site.delta);

    if (std.mem.indexOfScalar(bool, source.summaries.held[callee][first..end], true) == null) return false;

    const result = source.nodeRoot(@fromBackingInt(site.parent));

    for (source.sites[source.first[result]..source.first[result + 1]]) |use| {
        if (resolved(source, use) != .observe) return false;
        if (use.parent != none and source.expressions.get(@fromBackingInt(use.parent)).value == .call) return false;
    }

    return true;
}
