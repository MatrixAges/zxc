const std = @import("std");
const api = @import("zxc_abi").native.@"std:http";

pub fn validate(input: api.Options) !std.Uri {
    if (!std.unicode.utf8ValidateSlice(input.url)) return error.InvalidUtf8;

    for (input.url) |byte| if (byte <= 0x20 or byte == 0x7f) return error.InvalidUrl;
    if (input.max_header_bytes == 0 or input.max_header_bytes > 16 * 1024 * 1024) return error.InvalidHeaderLimit;
    if (!method(input.method).requestHasBody() and input.body != null) return error.UnsupportedRequestBody;

    var uri = try std.Uri.parse(input.url);

    if (!std.ascii.eqlIgnoreCase(uri.scheme, "http") and !std.ascii.eqlIgnoreCase(uri.scheme, "https")) return error.UnsupportedUriScheme;
    if (std.http.Client.disable_tls and std.ascii.eqlIgnoreCase(uri.scheme, "https")) return error.TlsDisabled;
    if (uri.user != null or uri.password != null) return error.UrlCredentialsUnsupported;
    if (uri.host == null) return error.UriMissingHost;

    if (switch (uri.host.?) {
        .raw => |host| host.len == 0,
        .percent_encoded => |host| host.len == 0,
    }) return error.UriMissingHost;

    uri.scheme = if (std.ascii.eqlIgnoreCase(uri.scheme, "https")) "https" else "http";

    return uri;
}

pub fn method(value: api.Method) std.http.Method {
    return switch (value) {
        .Get => .GET,
        .Head => .HEAD,
        .Post => .POST,
        .Put => .PUT,
        .Patch => .PATCH,
        .Delete => .DELETE,
        .Options => .OPTIONS,
    };
}
