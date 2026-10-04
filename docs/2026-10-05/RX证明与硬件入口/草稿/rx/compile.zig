const std = @import("std");
const compiler = @import("compiler");
const Compile = @import("../compile.zig");

pub fn run(context: Compile.Context) !Compile.Status {
    const allocator = context.allocator;
    const options = context.options;
    const writer = context.stderr;
    const inputs = if (context.watch) |attempt| attempt.inputs else null;

    if (options.formatting or options.mode == .lib) {
        try writer.writeAll("RX formatting and lib publishing require their RX integration\n");

        return .failed;
    }

    const loaded = @import("../project.zig").loadWithInputs(context.io, allocator, options.input, options.project, inputs) catch |err| return failure(context, err);

    if (loaded.diagnostic) |message| {
        try writer.print("{s}\n", .{message});

        return .failed;
    }

    var prepared = (@import("analyze.zig").run(allocator, .{ .io = context.io, .project = loaded.project, .writer = writer, .inputs = inputs }) catch |err| return failure(context, err)) orelse return .failed;

    defer prepared.analysis.deinit();

    const program = prepared.analysis.value.ir;

    if (options.verifying) {
        const verified = compiler.verification.check(context.io, allocator, program, prepared.sources, loaded.project.entry, .{ .solver = options.solver, .output = options.output }, writer) catch |err| return failure(context, err);

        return if (verified) .success else .failed;
    }

    if (options.fpga) {
        const generated = @import("../fpga.zig").runProgram(context.io, allocator, program, prepared.sources, loaded.project.entry, options, writer) catch |err| return failure(context, err);

        return if (generated) .success else .failed;
    }

    var cache = try @import("../generation_cache.zig").init(context.io, allocator, loaded.project.root_dir);

    defer cache.deinit();

    var dependencies: std.ArrayList([]const u8) = .empty;
    var type_output: std.Io.Writer.Allocating = .init(allocator);

    defer type_output.deinit();

    const configuration = compiler.CompileOptions{ .io = context.io, .sources = prepared.sources, .project = loaded.project, .generation_cache = if (options.native and options.cache) &cache else null, .solver = options.solver, .writer = writer, .dependencies = &dependencies, .type_output = if (options.output != null) &type_output.writer else null };

    if (!options.native) {
        const emitted = try compiler.emitProgramVerified(allocator, configuration, &prepared.analysis);

        defer emitted.deinit(allocator);

        if (emitted == .diagnostic) {
            try writer.print("{s}: {t}: {s}\n", .{ options.input, emitted.diagnostic.code, emitted.diagnostic.message });

            return .failed;
        }

        if (options.output) |path| {
            if (type_output.written().len != 0) try @import("../artifacts.zig").write(context.io, try std.fmt.allocPrint(allocator, "{s}.abi.zig", .{path}), type_output.written());
            try @import("../artifacts.zig").write(context.io, path, emitted.source);
        } else try context.stdout.writeAll(emitted.source);

        return .success;
    }

    var generated = try compiler.emitModulesVerified(allocator, configuration, &prepared.analysis);

    defer generated.deinit();

    if (generated == .diagnostic) {
        try writer.print("{s}: {t}: {s}\n", .{ options.input, generated.diagnostic.code, generated.diagnostic.message });

        return .failed;
    }

    try @import("state.zig").append(&generated.bundle, &prepared, configuration.generation_cache);
    try @import("../generation_cache.zig").report(&cache, options, writer);

    const toolchain = @import("../toolchain.zig").resolve(context.io, allocator, context.environment) catch |err| return failure(context, err);
    const project = try @import("../standard.zig").resolve(allocator, loaded, dependencies.items, toolchain.standard);
    const bundle = generated.bundle;

    for (project.config.native_modules) |native| {
        for (bundle.modules) |module| if (std.mem.eql(u8, native.name, module.name)) return error.ConflictingModuleName;
    }

    if (context.watch) |attempt| {
        try attempt.prepareBackend(context.io);

        var observed = try @import("../build.zig").runObserved(context.io, allocator, bundle, options, project, toolchain, context.environment, attempt.inputs);

        defer observed.deinit();

        try attempt.finishBackend(observed.input_paths);
        try writer.writeAll(observed.response.stderr);
        try observed.response.diagnostics.renderToWriter(.{}, writer);

        if (!observed.response.succeeded) return .backend_failed;
        if (!observed.response.inputs_complete) return error.IncompleteBackendInputs;
        if (!try observed.publish(context.io, allocator, attempt.inputs, options)) return .retry;
    } else if (!try @import("../build.zig").run(context.io, allocator, bundle, options, project, toolchain, context.environment)) return .failed;

    return .success;
}

fn failure(context: Compile.Context, err: anyerror) !Compile.Status {
    if (err == error.OutOfMemory or err == error.Canceled) return err;

    try context.stderr.print("{s}: {s}\n", .{ context.options.input, @errorName(err) });

    return .failed;
}
