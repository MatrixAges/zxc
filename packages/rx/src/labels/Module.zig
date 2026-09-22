const std = @import("std");
const dsl = @import("dsl");
const checks = @import("../checks.zig");
const Import = @import("Import.zig").Import;
const Call = @import("Call.zig").Call;
const Task = @import("Task.zig").Task;
const Parallel = @import("Parallel.zig").Parallel;
const Switch = @import("Switch.zig").Switch;
const Emit = @import("Emit.zig").Emit;
const Return = @import("Return.zig").Return;
const StoreReference = @import("Store.zig").StoreReference;

const ModuleBase = dsl.element("Module", struct {
    in: ?[]const u8 = null,
    out: ?[]const u8 = null,
}, dsl.list(dsl.choice(.{
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

fn checkModule(_: ModuleBase.Data, node: dsl.ast.Node, _: anytype, reporter: *dsl.Reporter) dsl.Error!void {
    try checks.nonEmpty(node, reporter);

    for (node.children, 0..) |child, index| {
        if (!std.mem.eql(u8, child.name, "Store")) continue;

        const alias = checks.attribute(child, "as") orelse checks.attribute(child, "from").?;

        for (node.children[0..index]) |previous| {
            if (!std.mem.eql(u8, previous.name, "Store")) continue;

            const previous_alias = checks.attribute(previous, "as") orelse checks.attribute(previous, "from").?;

            if (std.mem.eql(u8, alias, previous_alias)) return checks.fail(child, if (checks.attribute(child, "as") != null) "as" else "from", "Store reference alias is already registered", reporter);
        }
    }
}
