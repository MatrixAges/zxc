const std = @import("std");
const compiler = @import("compiler");
const c = @import("yaml.zig").c;
const model = @import("model.zig");
const Decoder = @import("decode.zig");
const Error = Decoder.Error;

pub fn field(decoder: *Decoder, key: []const u8, value: *const c.yaml_node_t, result: *model.Manifest) Error!bool {
    if (std.mem.eql(u8, key, "native_interfaces")) {
        const items = try decoder.sequence(value);
        const values = try decoder.allocator.alloc(model.NativeInterface, items.len);

        for (items, values) |item, *entry| entry.* = try interface(decoder, decoder.node(item));

        result.native_interfaces = values;
    } else if (std.mem.eql(u8, key, "native_modules")) {
        const items = try decoder.sequence(value);
        const values = try decoder.allocator.alloc(model.NativeModule, items.len);

        for (items, values) |item, *entry| entry.* = try module(decoder, decoder.node(item));

        result.native_modules = values;
    } else if (std.mem.eql(u8, key, "externals")) {
        const items = try decoder.sequence(value);
        const values = try decoder.allocator.alloc(compiler.project.External, items.len);

        for (items, values) |item, *entry| entry.* = try external(decoder, decoder.node(item));

        result.externals = values;
    } else if (std.mem.eql(u8, key, "libraries")) {
        result.libraries = try decoder.strings(value);
    } else if (std.mem.eql(u8, key, "include_paths")) {
        result.include_paths = try decoder.strings(value);
    } else if (std.mem.eql(u8, key, "library_paths")) {
        result.library_paths = try decoder.strings(value);
    } else return false;

    return true;
}

fn interface(decoder: *Decoder, value: *const c.yaml_node_t) Error!model.NativeInterface {
    var result: model.NativeInterface = .{ .specifier = "", .path = "", .module = "" };

    for (try decoder.mapping(value)) |entry| {
        const key = try decoder.scalar(decoder.node(entry.key));
        const item = decoder.node(entry.value);

        if (std.mem.eql(u8, key, "specifier")) {
            result.specifier = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "path")) {
            result.path = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "module")) {
            result.module = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "namespace")) {
            result.namespace = try decoder.strings(item);
        } else return decoder.fail(decoder.node(entry.key), "unknown native interface field");
    }

    if (result.specifier.len == 0 or result.path.len == 0 or result.module.len == 0) return decoder.fail(value, "native interface requires specifier, path and module");

    return result;
}

fn module(decoder: *Decoder, value: *const c.yaml_node_t) Error!model.NativeModule {
    var result: model.NativeModule = .{ .name = "" };

    for (try decoder.mapping(value)) |entry| {
        const key = try decoder.scalar(decoder.node(entry.key));
        const item = decoder.node(entry.value);

        if (std.mem.eql(u8, key, "name")) {
            result.name = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "path")) {
            result.path = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "header")) {
            result.header = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "dependencies")) {
            result.dependencies = try decoder.strings(item);
        } else if (std.mem.eql(u8, key, "bundle_files")) {
            result.bundle_files = try decoder.strings(item);
        } else if (std.mem.eql(u8, key, "include_paths")) {
            result.include_paths = try decoder.strings(item);
        } else if (std.mem.eql(u8, key, "abi_aliases")) {
            result.abi_aliases = try abiAliases(decoder, item);
        } else return decoder.fail(decoder.node(entry.key), "unknown native module field");
    }

    if (result.name.len == 0) return decoder.fail(value, "native module requires name");
    if ((result.path == null) == (result.header == null)) return decoder.fail(value, "native module requires exactly one of path or header");

    return result;
}

fn abiAliases(decoder: *Decoder, value: *const c.yaml_node_t) Error![]const model.AbiAlias {
    const items = try decoder.sequence(value);
    const aliases = try decoder.allocator.alloc(model.AbiAlias, items.len);

    for (items, aliases) |item, *alias| {
        alias.* = .{ .name = "", .specifier = "" };

        for (try decoder.mapping(decoder.node(item))) |pair| {
            const key = try decoder.scalar(decoder.node(pair.key));
            const text = try decoder.scalar(decoder.node(pair.value));

            if (std.mem.eql(u8, key, "name")) {
                alias.name = text;
            } else if (std.mem.eql(u8, key, "specifier")) {
                alias.specifier = text;
            } else return decoder.fail(decoder.node(pair.key), "unknown native ABI alias field");
        }

        if (alias.name.len == 0 or alias.specifier.len == 0) return decoder.fail(decoder.node(item), "native ABI alias requires name and specifier");
    }

    return aliases;
}

fn external(decoder: *Decoder, value: *const c.yaml_node_t) Error!compiler.project.External {
    var result: compiler.project.External = .{ .specifier = "", .signature = "", .implementation = .{ .module = "", .member = "" } };

    for (try decoder.mapping(value)) |entry| {
        const key = try decoder.scalar(decoder.node(entry.key));
        const item = decoder.node(entry.value);

        if (std.mem.eql(u8, key, "specifier")) {
            result.specifier = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "signature")) {
            result.signature = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "export_name")) {
            result.export_name = try decoder.scalar(item);
        } else if (std.mem.eql(u8, key, "implementation")) {
            for (try decoder.mapping(item)) |part| {
                const name = try decoder.scalar(decoder.node(part.key));
                const field_value = decoder.node(part.value);

                if (std.mem.eql(u8, name, "module")) {
                    result.implementation.module = try decoder.scalar(field_value);
                } else if (std.mem.eql(u8, name, "member")) {
                    result.implementation.member = try decoder.scalar(field_value);
                } else if (std.mem.eql(u8, name, "allocator_argument")) {
                    result.implementation.allocator_argument = try decoder.boolean(field_value);
                } else if (std.mem.eql(u8, name, "io_argument")) {
                    result.implementation.io_argument = try decoder.boolean(field_value);
                } else if (std.mem.eql(u8, name, "expand_tuple")) {
                    result.implementation.expand_tuple = try decoder.boolean(field_value);
                } else if (std.mem.eql(u8, name, "fallible")) {
                    result.implementation.fallible = try decoder.boolean(field_value);
                } else return decoder.fail(decoder.node(part.key), "unknown external implementation field");
            }
        } else return decoder.fail(decoder.node(entry.key), "unknown external interface field");
    }

    if (result.specifier.len == 0 or result.signature.len == 0 or result.implementation.module.len == 0 or result.implementation.member.len == 0) return decoder.fail(value, "external interface requires specifier, signature and implementation module/member");

    return result;
}
