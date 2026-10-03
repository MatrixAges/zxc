const std = @import("std");
const zx = @import("zx");
const frontend = @import("frontend");

pub const Options = struct {
    solver: ?[]const u8 = null,
    output: ?[]const u8 = null,
};

pub fn check(io: std.Io, backing_allocator: std.mem.Allocator, program: zx.ir.Program, sources: []const frontend.project.Source, entry: []const u8, options: Options, writer: *std.Io.Writer) !bool {
    var arena = std.heap.ArenaAllocator.init(backing_allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    var generated = try @import("root.zig").generate(allocator, program);

    defer generated.deinit();

    if (generated.value == .diagnostic) {
        try writer.print("verification: {s}\n", .{generated.value.diagnostic.message});

        return false;
    }

    const query = generated.value.query;
    const evidence = try std.json.Stringify.valueAlloc(allocator, .{ .sources = sources, .entry = entry, .ir_version = program.version, .types = program.types, .inputs = query.inputs, .ir = program }, .{ .whitespace = .indent_2 });
    var hash: [32]u8 = undefined;
    var fingerprint = std.crypto.hash.sha2.Sha256.init(.{});

    fingerprint.update(evidence);
    fingerprint.update(query.feasibility);
    fingerprint.update(query.correctness);
    fingerprint.final(&hash);

    const correctness_path = options.output orelse try std.fmt.allocPrint(allocator, ".zxc/proofs/{s}/correctness.smt2", .{std.fmt.bytesToHex(hash, .lower)});
    const feasibility_path = try std.fmt.allocPrint(allocator, "{s}.preconditions.smt2", .{correctness_path});
    const solver = options.solver orelse "z3";

    try write(io, correctness_path, query.correctness);
    try write(io, feasibility_path, query.feasibility);
    try write(io, try std.fmt.allocPrint(allocator, "{s}.source.json", .{correctness_path}), evidence);
    try write(io, try std.fmt.allocPrint(allocator, "{s}.result.txt", .{correctness_path}), "not_proved");
    try write(io, try std.fmt.allocPrint(allocator, "{s}.model.txt", .{correctness_path}), "");

    const version = try std.process.run(allocator, io, .{ .argv = &.{ solver, "--version" } });

    try write(io, try std.fmt.allocPrint(allocator, "{s}.solver.txt", .{correctness_path}), version.stdout);
    if (version.term != .exited or version.term.exited != 0) return error.SolverVersionFailed;

    const feasibility = try solve(io, allocator, solver, feasibility_path);

    try write(io, try std.fmt.allocPrint(allocator, "{s}.preconditions.result.txt", .{correctness_path}), feasibility);

    if (!std.mem.eql(u8, feasibility, "sat")) {
        try writer.print("verification not proved: preconditions are {s}\n", .{feasibility});

        return false;
    }

    const result = try solve(io, allocator, solver, correctness_path);

    try write(io, try std.fmt.allocPrint(allocator, "{s}.result.txt", .{correctness_path}), result);

    if (std.mem.eql(u8, result, "unsat")) {
        try writer.print("verified: entry paths satisfy supported safety obligations and reached contracts; query: {s}\n", .{correctness_path});

        return true;
    }

    if (std.mem.eql(u8, result, "sat")) {
        const counterexample_path = try std.fmt.allocPrint(allocator, "{s}.counterexample.smt2", .{correctness_path});

        try write(io, counterexample_path, try std.fmt.allocPrint(allocator, "{s}(get-model)\n", .{query.correctness}));

        const counterexample = try std.process.run(allocator, io, .{ .argv = &.{ solver, "-smt2", counterexample_path } });

        try write(io, try std.fmt.allocPrint(allocator, "{s}.model.txt", .{correctness_path}), counterexample.stdout);
        try writer.print("verification failed: counterexample\n{s}\n", .{counterexample.stdout});
        for (query.inputs) |input| try writer.print("{s} = {s}\n", .{ input.symbol, input.path });
    } else try writer.print("verification not proved: {s}\n", .{result});

    return false;
}

fn solve(io: std.Io, allocator: std.mem.Allocator, solver: []const u8, path: []const u8) ![]const u8 {
    const result = try std.process.run(allocator, io, .{ .argv = &.{ solver, "-smt2", path } });

    if (result.term != .exited or result.term.exited != 0 or result.stderr.len != 0) return error.SolverFailed;

    const status = std.mem.trim(u8, result.stdout, " \r\n\t");

    if (!std.mem.eql(u8, status, "sat") and !std.mem.eql(u8, status, "unsat") and !std.mem.eql(u8, status, "unknown")) return error.InvalidSolverResponse;

    return status;
}

fn write(io: std.Io, path: []const u8, content: []const u8) !void {
    var file = try std.Io.Dir.cwd().createFileAtomic(io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, content);
    try file.replace(io);
}
