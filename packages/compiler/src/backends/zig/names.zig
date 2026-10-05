const std = @import("std");
const ir = @import("zx").ir;
const NominalType = @import("frontend").NominalType;
const Names = @import("genz").zx.modules.Names;
const Hash = std.crypto.hash.sha2.Sha256;
pub const Error = std.mem.Allocator.Error || error{ MissingNominalOrigin, InvalidNominalOrigin };

pub fn create(allocator: std.mem.Allocator, program: ir.Program, origins: []const NominalType) Error!Names {
    const type_names = try allocator.alloc([]const u8, program.types.len);
    const digests = try allocator.alloc([32]u8, program.types.len);
    const nominal = try allocator.alloc(?NominalType, program.types.len);

    @memset(nominal, null);

    for (origins) |item| {
        const index = @backingInt(item.type_id);

        if (index >= nominal.len or nominal[index] != null or program.types[index] != .enumeration) return error.InvalidNominalOrigin;
        if (!std.mem.eql(u8, item.name, program.types[index].enumeration.name)) return error.InvalidNominalOrigin;

        nominal[index] = item;
    }

    for (program.types, 0..) |value, index| {
        var hash = Hash.init(.{});

        field(&hash, "zxc.zig.type.v1");
        field(&hash, @tagName(value));

        switch (value) {
            .task => |task| {
                field(&hash, &digests[@backingInt(task.result)]);
                field(&hash, &digests[@backingInt(task.errors)]);
            },
            .scalar => |scalar| field(&hash, @tagName(scalar)),
            .optional, .list => |child| field(&hash, &digests[@backingInt(child)]),
            .tuple => |children| for (children) |child| {
                field(&hash, &digests[@backingInt(child)]);
            },
            .object => |fields| for (fields) |item| {
                field(&hash, item.name);
                field(&hash, &digests[@backingInt(item.type_id)]);
            },
            .error_set => |members| for (members) |member| field(&hash, member),
            .enumeration => |enumeration| {
                const origin = nominal[index] orelse return error.MissingNominalOrigin;

                field(&hash, @tagName(origin.origin));

                switch (origin.origin) {
                    .source, .native => |identity| field(&hash, identity),
                    .external => |external| {
                        field(&hash, external.module);
                        field(&hash, external.member);
                    },
                }

                field(&hash, enumeration.name);

                for (enumeration.members) |member| field(&hash, member);
            },
        }

        hash.final(&digests[index]);

        type_names[index] = try std.fmt.allocPrint(allocator, "zx_type_{s}", .{std.fmt.bytesToHex(digests[index], .lower)});
    }

    const functions = try allocator.alloc([]const u8, program.functions.len);
    const io_functions = try @import("genz").zx.io.functions(allocator, program);

    defer allocator.free(io_functions);

    const process_functions = try @import("genz").zx.capabilities.functions(allocator, program, .process);

    defer allocator.free(process_functions);

    for (program.functions, functions, io_functions, process_functions) |function, *name, needs_io, needs_process| {
        var hash = Hash.init(.{});

        field(&hash, "zxc.zig.function.v1");
        field(&hash, function.file_name);

        if (needs_io) field(&hash, "std.Io");
        if (needs_process) field(&hash, "std.process.Init.Minimal");
        if (function.consumes_input) field(&hash, "owned Input");

        if (function.external) |external| {
            const module = program.native_modules[@backingInt(external.module)];

            field(&hash, "native");
            field(&hash, module.specifier);
            field(&hash, module.import_name);
            field(&hash, external.exportName());

            for (external.member) |member| field(&hash, member);
        } else field(&hash, "source");

        var digest: [32]u8 = undefined;

        hash.final(&digest);

        name.* = try std.fmt.allocPrint(allocator, "zxc_module_{s}", .{std.fmt.bytesToHex(digest, .lower)});
    }

    return .{ .types = type_names, .functions = functions };
}

fn field(hash: *Hash, bytes: []const u8) void {
    var length: [8]u8 = undefined;

    std.mem.writeInt(u64, &length, @intCast(bytes.len), .little);
    hash.update(&length);
    hash.update(bytes);
}
