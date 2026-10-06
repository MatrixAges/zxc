const std = @import("std");
const dsl = @import("dsl");
pub const ast = dsl.ast;
pub const parseXml = @import("frontend").parseExpressionXml;
pub const XmlResult = dsl.XmlResult;
pub const attributeLocation = dsl.attributeLocation;
pub const attributeEndLocation = dsl.attributeEndLocation;
pub const TextSource = @import("text.zig").Source;
pub const TextResult = @import("text.zig").Result;
pub const parseModules = @import("text.zig").parseModules;
pub const module_reference = @import("module_reference.zig");
pub const resolveModulePath = @import("paths.zig").resolve;
pub const normalizeModulePath = @import("paths.zig").normalize;
pub const normalizeGatewayPath = @import("paths.zig").normalizeGateway;
pub const normalizeStorePath = @import("paths.zig").normalizeStore;
pub const resolveStorePath = @import("paths.zig").resolveStore;
pub const resolveFunctionPath = @import("paths.zig").resolveFunction;
pub const Diagnostic = dsl.Diagnostic;
pub const flow = @import("flow.zig");
pub const gateway = @import("features/gateway/root.zig");
pub const store = @import("features/store/root.zig");
pub const Step = @import("steps.zig").Step;
pub const Module = flow.Module;
pub const Gateway = gateway.Gateway;
pub const Store = store.Store;
pub const Document = dsl.choice(.{ .module = Module, .gateway = Gateway, .store = Store });
pub const Result = dsl.Result(File);
pub const ModuleResult = @import("modules.zig").Result;
pub const ModuleSource = @import("modules.zig").Source;
pub const validateModules = @import("modules.zig").validate;

pub fn validate(allocator: std.mem.Allocator, file_name: []const u8, node: ast.Node) std.mem.Allocator.Error!Result {
    return dsl.validate(File, allocator, node, file_name);
}

const File = struct {
    pub const Data = Document.Data;

    pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *dsl.Reporter, file_name: []const u8) dsl.Error!Data {
        const basename = std.fs.path.basename(file_name);

        const expected: []const u8 = switch (@import("schema/file/adapter.zig").classify(basename)) {
            .App => return reporter.fail(.{
                .code = .context,
                .location = node.location,
                .element = node.name,
                .message = "app.rx schema has not been defined",
            }),
            .Gateway => "Gateway",
            .Store => "Store",
            .Module => "Module",
            .Invalid => return reporter.fail(.{
                .code = .context,
                .location = node.location,
                .element = node.name,
                .message = "RX source file must have the .rx extension",
            }),
        };

        if (!std.mem.eql(u8, node.name, expected)) return reporter.fail(.{
            .code = .unexpected_element,
            .location = node.location,
            .element = node.name,
            .expected = expected,
            .message = "Root element does not match the RX file kind",
        });

        return Document.decode(allocator, node, reporter, {});
    }
};
