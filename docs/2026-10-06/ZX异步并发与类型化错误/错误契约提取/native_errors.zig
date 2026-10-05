const std = @import("std");
const native = @import("zxc_standard");

comptime {
    @setEvalBranchQuota(1000000);
    report("std:encoding", "encodeBase64", @TypeOf(native.encoding.encodeBase64));
    report("std:encoding", "decodeBase64", @TypeOf(native.encoding.decodeBase64));
    report("std:encoding", "encodeHex", @TypeOf(native.encoding.encodeHex));
    report("std:encoding", "decodeHex", @TypeOf(native.encoding.decodeHex));
    report("std:encoding", "encodeUtf8", @TypeOf(native.encoding.encodeUtf8));
    report("std:encoding", "decodeUtf8", @TypeOf(native.encoding.decodeUtf8));
    report("std:crypto", "sha256", @TypeOf(native.crypto.sha256));
    report("std:crypto", "sha512", @TypeOf(native.crypto.sha512));
    report("std:crypto", "timingSafeEqual", @TypeOf(native.crypto.timingSafeEqual));
    report("std:crypto", "verifyHmacSha256", @TypeOf(native.crypto.verifyHmacSha256));
    report("std:crypto", "verifyHmacSha512", @TypeOf(native.crypto.verifyHmacSha512));
    report("std:crypto", "hmacSha256", @TypeOf(native.crypto.hmacSha256));
    report("std:crypto", "hmacSha512", @TypeOf(native.crypto.hmacSha512));
    report("std:crypto", "hkdfSha256", @TypeOf(native.crypto.hkdfSha256));
    report("std:crypto", "hkdfSha512", @TypeOf(native.crypto.hkdfSha512));
    report("std:crypto", "pbkdf2Sha256", @TypeOf(native.crypto.pbkdf2Sha256));
    report("std:crypto", "pbkdf2Sha512", @TypeOf(native.crypto.pbkdf2Sha512));
    report("std:crypto", "encryptAes128Gcm", @TypeOf(native.crypto.encryptAes128Gcm));
    report("std:crypto", "decryptAes128Gcm", @TypeOf(native.crypto.decryptAes128Gcm));
    report("std:crypto", "encryptAes256Gcm", @TypeOf(native.crypto.encryptAes256Gcm));
    report("std:crypto", "decryptAes256Gcm", @TypeOf(native.crypto.decryptAes256Gcm));
    report("std:crypto", "encryptChaCha20Poly1305", @TypeOf(native.crypto.encryptChaCha20Poly1305));
    report("std:crypto", "decryptChaCha20Poly1305", @TypeOf(native.crypto.decryptChaCha20Poly1305));
    report("std:crypto", "scrypt", @TypeOf(native.crypto.scrypt));
    report("std:path", "isAbsolute", @TypeOf(native.path.isAbsolute));
    report("std:path", "basename", @TypeOf(native.path.basename));
    report("std:path", "dirname", @TypeOf(native.path.dirname));
    report("std:path", "extname", @TypeOf(native.path.extname));
    report("std:path", "parse", @TypeOf(native.path.parse));
    report("std:path", "format", @TypeOf(native.path.format));
    report("std:path", "normalize", @TypeOf(native.path.normalize));
    report("std:path", "join", @TypeOf(native.path.join));
    report("std:path", "resolve", @TypeOf(native.path.resolve));
    report("std:path", "relative", @TypeOf(native.path.relative));
    report("std:path/posix", "isAbsolute", @TypeOf(native.path_posix.isAbsolute));
    report("std:path/posix", "basename", @TypeOf(native.path_posix.basename));
    report("std:path/posix", "dirname", @TypeOf(native.path_posix.dirname));
    report("std:path/posix", "extname", @TypeOf(native.path_posix.extname));
    report("std:path/posix", "parse", @TypeOf(native.path_posix.parse));
    report("std:path/posix", "format", @TypeOf(native.path_posix.format));
    report("std:path/posix", "normalize", @TypeOf(native.path_posix.normalize));
    report("std:path/posix", "join", @TypeOf(native.path_posix.join));
    report("std:path/posix", "resolve", @TypeOf(native.path_posix.resolve));
    report("std:path/posix", "relative", @TypeOf(native.path_posix.relative));
    report("std:path/win32", "isAbsolute", @TypeOf(native.path_win32.isAbsolute));
    report("std:path/win32", "basename", @TypeOf(native.path_win32.basename));
    report("std:path/win32", "dirname", @TypeOf(native.path_win32.dirname));
    report("std:path/win32", "extname", @TypeOf(native.path_win32.extname));
    report("std:path/win32", "parse", @TypeOf(native.path_win32.parse));
    report("std:path/win32", "format", @TypeOf(native.path_win32.format));
    report("std:path/win32", "normalize", @TypeOf(native.path_win32.normalize));
    report("std:path/win32", "join", @TypeOf(native.path_win32.join));
    report("std:path/win32", "resolve", @TypeOf(native.path_win32.resolve));
    report("std:path/win32", "relative", @TypeOf(native.path_win32.relative));
    report("std:querystring", "escape", @TypeOf(native.querystring.escape));
    report("std:querystring", "unescape", @TypeOf(native.querystring.unescape));
    report("std:querystring", "parse", @TypeOf(native.querystring.parse));
    report("std:querystring", "parseWith", @TypeOf(native.querystring.parseWith));
    report("std:querystring", "stringify", @TypeOf(native.querystring.stringify));
    report("std:querystring", "stringifyWith", @TypeOf(native.querystring.stringifyWith));
    report("std:zlib", "gzip", @TypeOf(native.zlib.gzip));
    report("std:zlib", "deflate", @TypeOf(native.zlib.deflate));
    report("std:zlib", "deflateRaw", @TypeOf(native.zlib.deflateRaw));
    report("std:zlib", "gzipWith", @TypeOf(native.zlib.gzipWith));
    report("std:zlib", "deflateWith", @TypeOf(native.zlib.deflateWith));
    report("std:zlib", "deflateRawWith", @TypeOf(native.zlib.deflateRawWith));
    report("std:zlib", "gunzip", @TypeOf(native.zlib.gunzip));
    report("std:zlib", "inflate", @TypeOf(native.zlib.inflate));
    report("std:zlib", "inflateRaw", @TypeOf(native.zlib.inflateRaw));
    report("std:zlib", "zstdDecompress", @TypeOf(native.zlib.zstdDecompress));
    report("std:os", "arch", @TypeOf(native.os.arch));
    report("std:os", "platform", @TypeOf(native.os.platform));
    report("std:os", "endianness", @TypeOf(native.os.endianness));
    report("std:url", "parse", @TypeOf(native.url_api.parse));
    report("std:url", "resolve", @TypeOf(native.url_api.resolve));
    report("std:url", "tryParse", @TypeOf(native.url_api.tryParse));
    report("std:url", "canParse", @TypeOf(native.url_api.canParse));
    report("std:url", "stringify", @TypeOf(native.url_api.stringify));
    report("std:url", "pathname", @TypeOf(native.url_api.pathname));
    report("std:url", "origin", @TypeOf(native.url_api.origin));
    report("std:url", "domainToASCII", @TypeOf(native.url_api.domainToASCII));
    report("std:url", "domainToUnicode", @TypeOf(native.url_api.domainToUnicode));
    report("std:url", "pathToFileURL", @TypeOf(native.url_api.pathToFileURL));
    report("std:url", "fileURLToPath", @TypeOf(native.url_api.fileURLToPath));
    report("std:url", "fileURLToBytes", @TypeOf(native.url_api.fileURLToBytes));
    report("std:url/search_params", "parse", @TypeOf(native.url_search_params.parse));
    report("std:url/search_params", "stringify", @TypeOf(native.url_search_params.stringify));
    report("std:url/search_params", "get", @TypeOf(native.url_search_params.get));
    report("std:url/search_params", "getAll", @TypeOf(native.url_search_params.getAll));
    report("std:url/search_params", "has", @TypeOf(native.url_search_params.has));
    report("std:url/search_params", "append", @TypeOf(native.url_search_params.append));
    report("std:url/search_params", "set", @TypeOf(native.url_search_params.set));
    report("std:url/search_params", "remove", @TypeOf(native.url_search_params.remove));
    report("std:url/search_params", "sort", @TypeOf(native.url_search_params.sort));
    report("std:url/search_params", "keys", @TypeOf(native.url_search_params.keys));
    report("std:url/search_params", "values", @TypeOf(native.url_search_params.values));
    report("std:url/search_params", "size", @TypeOf(native.url_search_params.size));
    report("std:fs", "readFile", @TypeOf(native.fs.readFile));
    report("std:fs", "readText", @TypeOf(native.fs.readText));
    report("std:fs", "writeFile", @TypeOf(native.fs.writeFile));
    report("std:fs", "writeText", @TypeOf(native.fs.writeText));
    report("std:fs", "truncate", @TypeOf(native.fs.truncate));
    report("std:fs", "mkdir", @TypeOf(native.fs.mkdir));
    report("std:fs", "readdir", @TypeOf(native.fs.readdir));
    report("std:fs", "rmdir", @TypeOf(native.fs.rmdir));
    report("std:fs", "unlink", @TypeOf(native.fs.unlink));
    report("std:fs", "rename", @TypeOf(native.fs.rename));
    report("std:fs", "copyFile", @TypeOf(native.fs.copyFile));
    report("std:fs", "realpath", @TypeOf(native.fs.realpath));
    report("std:fs", "readlink", @TypeOf(native.fs.readlink));
    report("std:fs", "stat", @TypeOf(native.fs.stat));
    report("std:fs", "lstat", @TypeOf(native.fs.lstat));
    report("std:child_process", "spawnSync", @TypeOf(native.child_process.spawnSync));
    report("std:child_process", "spawnSyncWithInput", @TypeOf(native.child_process.spawnSyncWithInput));
    report("std:process", "argv", @TypeOf(native.process.argv));
    report("std:process", "getEnv", @TypeOf(native.process.getEnv));
    report("std:process", "cwd", @TypeOf(native.process.cwd));
    report("std:process", "readStdin", @TypeOf(native.process.readStdin));
    report("std:process", "readStdinText", @TypeOf(native.process.readStdinText));
    report("std:process", "writeStdout", @TypeOf(native.process.writeStdout));
    report("std:process", "writeStdoutText", @TypeOf(native.process.writeStdoutText));
    report("std:process", "writeStderr", @TypeOf(native.process.writeStderr));
    report("std:process", "writeStderrText", @TypeOf(native.process.writeStderrText));
    report("std:http", "request", @TypeOf(native.http.request));
}

fn report(comptime module: []const u8, comptime name: []const u8, comptime Function: type) void {
    const result = @typeInfo(Function).@"fn".return_type.?;
    const info = @typeInfo(result);

    if (info != .error_union) return;

    const members = @typeInfo(info.error_union.error_set).error_set.error_names;
    var text: []const u8 = module ++ "\t" ++ name ++ "\t";

    if (members) |names| {
        for (names, 0..) |member, index| {
            if (index != 0) text = text ++ ",";

            text = text ++ member;
        }
    } else text = text ++ "?";

    @compileLog(text);
}

pub fn main() void {}
