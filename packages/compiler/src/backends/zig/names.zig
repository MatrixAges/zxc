const std = @import("std");
const ir = @import("zx").ir;
const NominalType = @import("frontend").NominalType;
const Names = @import("genz").zx.modules.Names;
const Hash = std.crypto.hash.sha2.Sha256;
pub const Error = std.mem.Allocator.Error || error{ MissingNominalOrigin, InvalidNominalOrigin };

pub fn create(allocator: std.mem.Allocator, program: ir.Program, origins: @FieldType(@import("frontend").AnalysisResult, "nominal_types")) Error!Names {
    if (!origins.hasValidShape()) return error.InvalidNominalOrigin;

    const type_names = try allocator.alloc([]const u8, program.types.count());
    const digests = try allocator.alloc([32]u8, program.types.count());
    const nominal = try allocator.alloc(?NominalType, program.types.count());

    @memset(nominal, null);

    for (0..origins.count()) |origin_index| {
        const item = origins.at(origin_index);
        const index = @backingInt(item.type_id);

        if (index >= nominal.len or nominal[index] != null) return error.InvalidNominalOrigin;
        if (!std.mem.eql(u8, item.name, program.types.at(index).nominalName() orelse return error.InvalidNominalOrigin)) return error.InvalidNominalOrigin;

        if (program.types.at(index) == .native_reference) {
            const owner = ir.nativeReferenceOwner(program, item.type_id) orelse return error.InvalidNominalOrigin;

            if (item.origin != .native or !std.mem.eql(u8, owner, item.origin.native)) return error.InvalidNominalOrigin;
        }

        nominal[index] = item;
    }

    for (0..program.types.count()) |index| {
        const value = program.types.at(index);
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
            .tuple => |children| for (0..children.len) |view_index| {
                const child = children.at(view_index);

                field(&hash, &digests[@backingInt(child)]);
            },
            .object => |fields| for (0..fields.len) |position| {
                const item = fields.at(position);

                field(&hash, item.name);
                field(&hash, &digests[@backingInt(item.type_id)]);
            },
            .error_set => |members| for (members) |member| field(&hash, member),
            .enumeration, .native_reference => {
                const origin = nominal[index] orelse return error.MissingNominalOrigin;

                field(&hash, @tagName(origin.origin));

                switch (origin.origin) {
                    .source, .native => |identity| field(&hash, identity),
                    .external => |external| {
                        field(&hash, external.module);
                        field(&hash, external.member);
                    },
                }

                field(&hash, value.nominalName().?);

                if (value == .enumeration) for (value.enumeration.members) |member| field(&hash, member);
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
