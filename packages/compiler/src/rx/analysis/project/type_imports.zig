const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const frontend = @import("frontend");
const target = @import("../call/target.zig");

pub const Value = union(enum) { imports: []const zx.ir.Export, diagnostic: target.Diagnostic };

pub fn values(allocator: std.mem.Allocator, types: zx.ir.TypeTable, imports: []const zx.ir.Export) std.mem.Allocator.Error![]const zx.ir.Export {
    var result: std.ArrayList(zx.ir.Export) = .empty;

    for (imports) |alias| {
        if (types.at(@backingInt(alias.type_id)) == .enumeration) try result.append(allocator, alias);
    }

    return result.items;
}

pub fn collect(allocator: std.mem.Allocator, source: rx.ModuleSource, raw_project: frontend.project.Options, signatures: frontend.project.signature_project.Data) std.mem.Allocator.Error!Value {
    var project = raw_project;

    if (project.source_index == null) project.source_index = try frontend.project.source_index.buildIn(allocator, signatures.modules, project.root_dir);

    var imports: std.ArrayList(zx.ir.Export) = .empty;

    for (source.node.children) |node| {
        if (!std.mem.eql(u8, node.name, "Type")) continue;

        const from = target.optionalAttribute(node, "from") orelse return .{ .diagnostic = .{ .path = try allocator.dupe(u8, source.path), .location = node.location, .code = "module", .message = "Type requires an explicit from attribute" } };
        const alias = target.optionalAttribute(node, "as") orelse return failure(allocator, source, from, "Type requires an explicit as attribute");
        const owner = try std.fs.path.resolve(allocator, &.{ project.root_dir, source.path });
        const packages = rx.module_reference.dependencies(project, owner);

        const path = if (rx.module_reference.isPackage(from.value, packages)) resolved: {
            var reporter: zx.Reporter = .{};

            const imported = frontend.project.resolveModuleTarget(allocator, owner, from.value, project, &reporter, .{ .start = from.value_location.offset, .end = from.value_location.offset }) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return failure(allocator, source, from, reporter.diagnostic.?.message);
            };

            if (imported != .source or !std.mem.endsWith(u8, imported.source, ".zx")) return failure(allocator, source, from, "Type requires a ZX source module");

            break :resolved try std.fs.path.resolve(allocator, &.{ project.root_dir, imported.source });
        } else resolved: {
            const relative = rx.resolveFunctionPath(allocator, source.path, from.value) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return failure(allocator, source, from, "Type must name a ZX source inside the project root");
            };

            break :resolved try std.fs.path.resolve(allocator, &.{ project.root_dir, relative });
        };

        const selected = try frontend.project.selectSource(allocator, path, project);
        var found = false;

        for (signatures.modules) |module| {
            if (!std.mem.eql(u8, module.path, selected)) continue;

            for (module.signature.exports) |exported| {
                try imports.append(allocator, .{
                    .name = try std.fmt.allocPrint(allocator, "{s}.{s}", .{ alias.value, exported.name }),
                    .type_id = exported.type_id,
                });
            }

            found = true;

            break;
        }

        if (!found) return failure(allocator, source, from, "Type source signature is missing from the analyzed input set");
    }

    return .{ .imports = imports.items };
}

fn failure(allocator: std.mem.Allocator, source: rx.ModuleSource, attribute: rx.ast.Attribute, message: []const u8) std.mem.Allocator.Error!Value {
    return .{ .diagnostic = .{
        .path = try allocator.dupe(u8, source.path),
        .location = attribute.value_location,
        .code = "module",
        .message = message,
    } };
}
