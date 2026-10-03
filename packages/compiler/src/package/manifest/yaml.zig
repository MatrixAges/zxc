pub const c = @cImport({
    if (@import("builtin").os.tag == .windows) {
        @cUndef("_FORTIFY_SOURCE");
        @cDefine("_FORTIFY_SOURCE", "0");
    }

    @cDefine("YAML_DECLARE_STATIC", "1");
    @cInclude("yaml.h");
});
