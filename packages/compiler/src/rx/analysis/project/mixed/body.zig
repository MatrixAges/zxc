const std = @import("std");
const State = @import("state.zig");
const generated = @import("rx_options").generated_graph;
const admission = if (generated) @import("generated_rx_mixed_body_admit") else void;
const Source = if (generated) @FieldType(std.meta.Child(admission.Input), "source") else enum { ZX, RX, Store };
const Action = if (generated) admission.Output else enum { Skip, MissingSignature, AnalyzeZX, LowerRX };

pub fn admit(state: *const State, index: usize, preview: bool, reusable: bool) Action {
    const module = &state.graph.modules[index];

    const source: Source = switch (module.source) {
        .zx => .ZX,
        .rx => .RX,
        .store => .Store,
    };

    const signature = if (source == .ZX) state.signature_indices[index] else null;
    const setter = if (signature) |row| state.signatures.modules[row].signature.has_store else false;
    const entry = index == state.graph.entry;

    if (comptime generated) {
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(admission.Input) = .{
            .source = source,
            .signature = signature != null,
            .setter = setter,
            .preview = preview,
            .entry = entry,
            .compiled_dependency = module.compiled_dependency,
            .reusable = reusable,
        };

        return @import("zx").columns.invoke(admission.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (preview and (reusable or module.compiled_dependency or (entry and source == .RX))) return .Skip;

    return switch (source) {
        .ZX => if (signature == null) .MissingSignature else if (setter) .Skip else .AnalyzeZX,
        .RX => .LowerRX,
        .Store => .Skip,
    };
}

pub fn accept(state: *const State, original_native_modules: usize, original_initializers: usize, original_functions: usize, lowered_functions: ?usize) bool {
    if (comptime generated) {
        const rule = @import("generated_rx_mixed_body_accept");
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        const input: std.meta.Child(rule.Input) = .{
            .native_modules = state.native_modules.count(),
            .original_native_modules = original_native_modules,
            .initializers = state.initializers.items.len,
            .original_initializers = original_initializers,
            .functions = if (lowered_functions != null) state.functions.count() else original_functions,
            .original_functions = original_functions,
            .lowered_functions = if (lowered_functions) |count| count else null,
        };

        return @import("zx").columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
    }

    if (state.native_modules.count() != original_native_modules or state.initializers.items.len != original_initializers) return false;

    return if (lowered_functions) |count| count == original_functions or state.functions.count() == original_functions else true;
}
