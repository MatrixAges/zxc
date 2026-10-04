const std = @import("std");
const compiler = @import("compiler");
const Compile = @import("../compile.zig");
const Loaded = @import("../project.zig").Loaded;
const Inputs = @import("../watch/inputs.zig");

pub fn run(context: Compile.Context, loaded: Loaded, inputs: ?*Inputs) !Compile.Status {
    var analyzed = (try @import("analyze.zig").run(context.allocator, .{ .io = context.io, .loaded = loaded, .writer = context.stderr, .inputs = inputs })) orelse return .failed;

    defer analyzed.deinit();

    var library = try analyzed.link(context.allocator);

    defer library.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;

    defer sources.deinit(context.allocator);

    for (analyzed.modules) |module| try sources.appendSlice(context.allocator, module.sources);

    var verified = true;

    for (library.exports, 0..) |exported, index| {
        if (exported.function == null) {
            try context.stderr.print("public module {s}: type interface validated; no executable proof obligation\n", .{exported.name});

            continue;
        }

        var digest: [32]u8 = undefined;

        std.crypto.hash.sha2.Sha256.hash(exported.name, &digest, .{});

        const output = if (context.options.output) |path| try std.fmt.allocPrint(context.allocator, "{s}.{s}.smt2", .{ path, std.fmt.bytesToHex(digest, .lower) }) else null;

        defer if (output) |path| context.allocator.free(path);

        try context.stderr.print("public module {s}:\n", .{exported.name});

        const succeeded = try compiler.verification.check(context.io, context.allocator, try library.module(index), sources.items, exported.path, .{ .solver = context.options.solver, .output = output }, context.stderr);

        verified = succeeded and verified;
    }

    return if (verified) .success else .failed;
}
