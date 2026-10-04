const std = @import("std");
pub const Metadata = struct { identity: []const u8, schema_version: u32, type_identity: []const u8 };
pub const Snapshot = struct { format_version: u32, identity: []const u8, schema_version: u32, type_identity: []const u8, revision: u64, value: std.json.Value };

pub fn parse(allocator: std.mem.Allocator, source: []const u8, metadata: Metadata) !Snapshot {
    const snapshot = try std.json.parseFromSliceLeaky(Snapshot, allocator, source, .{ .parse_numbers = false });

    if (snapshot.format_version != 1) return error.InvalidSnapshotFormat;
    if (!std.mem.eql(u8, snapshot.identity, metadata.identity)) return error.StoreIdentityMismatch;
    if (snapshot.schema_version != metadata.schema_version) return error.StoreSchemaMismatch;
    if (!std.mem.eql(u8, snapshot.type_identity, metadata.type_identity)) return error.StoreTypeMismatch;

    return snapshot;
}

pub fn encode(allocator: std.mem.Allocator, metadata: Metadata, revision: u64, value: anytype) ![]u8 {
    return std.json.Stringify.valueAlloc(allocator, .{ .format_version = @as(u32, 1), .identity = metadata.identity, .schema_version = metadata.schema_version, .type_identity = metadata.type_identity, .revision = revision, .value = value }, .{});
}
