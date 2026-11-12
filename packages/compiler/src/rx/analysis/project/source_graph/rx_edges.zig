const rx = @import("rx");
const Reference = @import("model.zig").Reference;
const dependency = rx.dependency_reference;

pub fn collect(collector: anytype, source: rx.ModuleSource) @TypeOf(collector.*).Error!void {
    var references: dependency.Iterator = .{};

    defer references.deinit(collector.allocator);
    references.reset(&source.node, source.references);
    while (try references.next(collector.allocator, false)) |selection| try reference(collector, source.path, selection);
}

fn reference(collector: anytype, owner: []const u8, selection: dependency.Entry) @TypeOf(collector.*).Error!void {
    const value = selection.attribute orelse return collector.fail(selection.node.location, "source dependency requires an explicit target");

    const role: Reference = switch (selection.role) {
        .Dependency => .dependency,
        .Call => .call,
        .TypeImport => .type_import,
    };

    if (selection.package_allowed) {
        const packages = rx.module_reference.dependencies(collector.options, collector.ownerPath());

        if (rx.module_reference.isPackage(value.value, packages)) return collector.import(value.value, value.value_location, role);
    }

    const path = switch (selection.target) {
        .Module => rx.resolveModulePath(collector.allocator, owner, value.value),
        .Function => rx.resolveFunctionPath(collector.allocator, owner, value.value),
        .Store => rx.resolveStorePath(collector.allocator, owner, value.value),
    };

    const resolved = path catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return collector.fail(value.value_location, "source dependency escapes the project root or is not a valid module path");
    };

    if (selection.target == .Store) return collector.store(resolved, value.value_location, owner);
    try collector.local(resolved, value.value_location, role);
}
