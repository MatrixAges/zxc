const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const Import = @import("Import.zig").Import;
const Type = @import("Type.zig").Type;
const Args = @import("Args.zig").Args;
const Call = @import("Call.zig").Call;
const Task = @import("Task.zig").Sequential;
const Parallel = @import("Parallel.zig").Parallel;
const Switch = @import("Switch.zig").Switch;
const Emit = @import("Emit.zig").Emit;
const Return = @import("Return.zig").Return;
const StoreReference = @import("../features/store/root.zig").StoreReference;

const ModuleBase = dsl.element("Module", struct {
    @"fn": ?[]const u8 = null,
}, dsl.list(dsl.choice(.{
    .type = Type,
    .args = Args,
    .store = StoreReference,
    .import = Import,
    .call = Call,
    .task = Task,
    .parallel = Parallel,
    .@"switch" = Switch,
    .emit = Emit,
    .@"return" = Return,
}), .{}));

pub const Module = dsl.refine(ModuleBase, checkModule);

fn checkModule(data: ModuleBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    if (data.attributes.@"fn") |reference| {
        if (node.children.len != 0) return checks.fail(node, "fn", "Module.fn cannot be combined with child declarations or steps", reporter);
        if (!@import("../paths.zig").isFunctionReference(reference)) return checks.fail(node, "fn", "Module.fn must reference a ZX source file", reporter);

        return;
    }

    try checks.uniqueChildren(node, "Type", "as", reporter);

    var has_args = false;
    var has_steps = false;

    for (node.children, 0..) |child, index| {
        if (std.mem.eql(u8, child.name, "Type")) {
            if (has_args or has_steps) return checks.fail(child, "from", "Type declarations must precede Args and module steps", reporter);

            continue;
        }

        if (std.mem.eql(u8, child.name, "Args")) {
            if (has_args or has_steps) return checks.fail(child, "in", "Args must appear once after Type declarations and before module steps", reporter);

            has_args = true;

            continue;
        }

        has_steps = true;

        if (!std.mem.eql(u8, child.name, "Store")) continue;

        const alias = checks.attribute(child, "as") orelse checks.attribute(child, "from").?;

        for (node.children[0..index]) |previous| {
            if (!std.mem.eql(u8, previous.name, "Store")) continue;

            const previous_alias = checks.attribute(previous, "as") orelse checks.attribute(previous, "from").?;

            if (std.mem.eql(u8, alias, previous_alias)) return checks.fail(child, if (checks.attribute(child, "as") != null) "as" else "from", "Store reference alias is already registered", reporter);
        }
    }
}
