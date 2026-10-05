const fixture = @import("fixture.zig");

test "WPT URL source index 790" {
    try fixture.check("{\x22input\x22:\x22blob:http%3a//example.org/\x22,\x22base\x22:null,\x22href\x22:\x22blob:http%3a//example.org/\x22,\x22origin\x22:\x22null\x22,\x22protocol\x22:\x22blob:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22http%3a//example.org/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 792" {
    try fixture.check("{\x22input\x22:\x22http://0x7f.0.0.0x7g\x22,\x22base\x22:null,\x22href\x22:\x22http://0x7f.0.0.0x7g/\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x220x7f.0.0.0x7g\x22,\x22hostname\x22:\x220x7f.0.0.0x7g\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 793" {
    try fixture.check("{\x22input\x22:\x22http://0X7F.0.0.0X7G\x22,\x22base\x22:null,\x22href\x22:\x22http://0x7f.0.0.0x7g/\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x220x7f.0.0.0x7g\x22,\x22hostname\x22:\x220x7f.0.0.0x7g\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 795" {
    try fixture.check("{\x22input\x22:\x22http://[::127.0.0.0.1]\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 797" {
    try fixture.check("{\x22input\x22:\x22http://[0:1:0:1:0:1:0:1]\x22,\x22base\x22:null,\x22href\x22:\x22http://[0:1:0:1:0:1:0:1]/\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22[0:1:0:1:0:1:0:1]\x22,\x22hostname\x22:\x22[0:1:0:1:0:1:0:1]\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 798" {
    try fixture.check("{\x22input\x22:\x22http://[1:0:1:0:1:0:1:0]\x22,\x22base\x22:null,\x22href\x22:\x22http://[1:0:1:0:1:0:1:0]/\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22[1:0:1:0:1:0:1:0]\x22,\x22hostname\x22:\x22[1:0:1:0:1:0:1:0]\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 800" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?\x5c\x22\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%22\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 801" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?#\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?#\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 802" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?<\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%3C\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%3C\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 803" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?>\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%3E\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%3E\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 804" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?\xe2\x8c\xa3\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%E2%8C%A3\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%E2%8C%A3\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 805" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?%23%23\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%23%23\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%23%23\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 806" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?%GH\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?%GH\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?%GH\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 807" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?a#%EF\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?a#%EF\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?a\x22,\x22hash\x22:\x22#%EF\x22}");
}

test "WPT URL source index 808" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?a#%GH\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?a#%GH\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?a\x22,\x22hash\x22:\x22#%GH\x22}");
}

test "WPT URL source index 810" {
    try fixture.check("{\x22input\x22:\x22a\x22,\x22base\x22:null,\x22failure\x22:true,\x22relativeTo\x22:\x22non-opaque-path-base\x22}");
}

test "WPT URL source index 811" {
    try fixture.check("{\x22input\x22:\x22a/\x22,\x22base\x22:null,\x22failure\x22:true,\x22relativeTo\x22:\x22non-opaque-path-base\x22}");
}

test "WPT URL source index 812" {
    try fixture.check("{\x22input\x22:\x22a//\x22,\x22base\x22:null,\x22failure\x22:true,\x22relativeTo\x22:\x22non-opaque-path-base\x22}");
}

test "WPT URL source index 814" {
    try fixture.check("{\x22input\x22:\x22test-a-colon.html\x22,\x22base\x22:\x22a:\x22,\x22failure\x22:true}");
}

test "WPT URL source index 815" {
    try fixture.check("{\x22input\x22:\x22test-a-colon-b.html\x22,\x22base\x22:\x22a:b\x22,\x22failure\x22:true}");
}

test "WPT URL source index 817" {
    try fixture.check("{\x22input\x22:\x22test-a-colon-slash.html\x22,\x22base\x22:\x22a:/\x22,\x22href\x22:\x22a:/test-a-colon-slash.html\x22,\x22protocol\x22:\x22a:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test-a-colon-slash.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 818" {
    try fixture.check("{\x22input\x22:\x22test-a-colon-slash-slash.html\x22,\x22base\x22:\x22a://\x22,\x22href\x22:\x22a:///test-a-colon-slash-slash.html\x22,\x22protocol\x22:\x22a:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test-a-colon-slash-slash.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 819" {
    try fixture.check("{\x22input\x22:\x22test-a-colon-slash-b.html\x22,\x22base\x22:\x22a:/b\x22,\x22href\x22:\x22a:/test-a-colon-slash-b.html\x22,\x22protocol\x22:\x22a:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test-a-colon-slash-b.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 820" {
    try fixture.check("{\x22input\x22:\x22test-a-colon-slash-slash-b.html\x22,\x22base\x22:\x22a://b\x22,\x22href\x22:\x22a://b/test-a-colon-slash-slash-b.html\x22,\x22protocol\x22:\x22a:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22b\x22,\x22hostname\x22:\x22b\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test-a-colon-slash-slash-b.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 822" {
    try fixture.check("{\x22input\x22:\x22http://example.org/test?a#b\x5cu0000c\x22,\x22base\x22:null,\x22href\x22:\x22http://example.org/test?a#b%00c\x22,\x22protocol\x22:\x22http:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?a\x22,\x22hash\x22:\x22#b%00c\x22}");
}

test "WPT URL source index 823" {
    try fixture.check("{\x22input\x22:\x22non-spec://example.org/test?a#b\x5cu0000c\x22,\x22base\x22:null,\x22href\x22:\x22non-spec://example.org/test?a#b%00c\x22,\x22protocol\x22:\x22non-spec:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?a\x22,\x22hash\x22:\x22#b%00c\x22}");
}

test "WPT URL source index 824" {
    try fixture.check("{\x22input\x22:\x22non-spec:/test?a#b\x5cu0000c\x22,\x22base\x22:null,\x22href\x22:\x22non-spec:/test?a#b%00c\x22,\x22protocol\x22:\x22non-spec:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/test\x22,\x22search\x22:\x22?a\x22,\x22hash\x22:\x22#b%00c\x22}");
}

test "WPT URL source index 826" {
    try fixture.check("{\x22input\x22:\x2210.0.0.7:8080/foo.html\x22,\x22base\x22:\x22file:///some/dir/bar.html\x22,\x22href\x22:\x22file:///some/dir/10.0.0.7:8080/foo.html\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/some/dir/10.0.0.7:8080/foo.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 828" {
    try fixture.check("{\x22input\x22:\x22a!@$*=/foo.html\x22,\x22base\x22:\x22file:///some/dir/bar.html\x22,\x22href\x22:\x22file:///some/dir/a!@$*=/foo.html\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/some/dir/a!@$*=/foo.html\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 830" {
    try fixture.check("{\x22input\x22:\x22a1234567890-+.:foo/bar\x22,\x22base\x22:\x22http://example.com/dir/file\x22,\x22href\x22:\x22a1234567890-+.:foo/bar\x22,\x22protocol\x22:\x22a1234567890-+.:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22foo/bar\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 832" {
    try fixture.check("{\x22input\x22:\x22file://a\xc2\xadb/p\x22,\x22base\x22:null,\x22href\x22:\x22file://ab/p\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22ab\x22,\x22hostname\x22:\x22ab\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/p\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 833" {
    try fixture.check("{\x22input\x22:\x22file://a%C2%ADb/p\x22,\x22base\x22:null,\x22href\x22:\x22file://ab/p\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22ab\x22,\x22hostname\x22:\x22ab\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/p\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 835" {
    try fixture.check("{\x22input\x22:\x22file://loC\xf0\x9d\x90\x80\xf0\x9d\x90\x8b\xf0\x9d\x90\x87\xf0\x9d\x90\xa8\xf0\x9d\x90\xac\xf0\x9d\x90\xad/usr/bin\x22,\x22base\x22:null,\x22href\x22:\x22file:///usr/bin\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/usr/bin\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 837" {
    try fixture.check("{\x22input\x22:\x22file://\xc2\xad/p\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 838" {
    try fixture.check("{\x22input\x22:\x22file://%C2%AD/p\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 839" {
    try fixture.check("{\x22input\x22:\x22file://xn--/p\x22,\x22base\x22:null,\x22href\x22:\x22file://xn--/p\x22,\x22protocol\x22:\x22file:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22xn--\x22,\x22hostname\x22:\x22xn--\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/p\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22\x22}");
}

test "WPT URL source index 841" {
    try fixture.check("{\x22input\x22:\x22#link\x22,\x22base\x22:\x22https://example.org/##link\x22,\x22href\x22:\x22https://example.org/#link\x22,\x22protocol\x22:\x22https:\x22,\x22username\x22:\x22\x22,\x22password\x22:\x22\x22,\x22host\x22:\x22example.org\x22,\x22hostname\x22:\x22example.org\x22,\x22port\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22search\x22:\x22\x22,\x22hash\x22:\x22#link\x22}");
}

test "WPT URL source index 843" {
    try fixture.check("{\x22input\x22:\x22non-special:cannot-be-a-base-url-\x5cu0000\x5cu0001\x5cu001f\x5cu001e~\x7f\xc2\x80\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22non-special:cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22non-special:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 844" {
    try fixture.check("{\x22input\x22:\x22non-special:cannot-be-a-base-url-!\x5c\x22$%&'()*+,-.;<=>@[\x5c\x5c]^_`{|}~@/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22non-special:cannot-be-a-base-url-!\x5c\x22$%&'()*+,-.;<=>@[\x5c\x5c]^_`{|}~@/\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22cannot-be-a-base-url-!\x5c\x22$%&'()*+,-.;<=>@[\x5c\x5c]^_`{|}~@/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22non-special:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 845" {
    try fixture.check("{\x22input\x22:\x22https://www.example.com/path{\x7fpath.html?query'\x7f=query#fragment<\x7ffragment\x22,\x22base\x22:null,\x22hash\x22:\x22#fragment%3C%7Ffragment\x22,\x22host\x22:\x22www.example.com\x22,\x22hostname\x22:\x22www.example.com\x22,\x22href\x22:\x22https://www.example.com/path%7B%7Fpath.html?query%27%7F=query#fragment%3C%7Ffragment\x22,\x22origin\x22:\x22https://www.example.com\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/path%7B%7Fpath.html\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22?query%27%7F=query\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 846" {
    try fixture.check("{\x22input\x22:\x22https://user:pass[\x7f@foo/bar\x22,\x22base\x22:\x22http://example.org\x22,\x22hash\x22:\x22\x22,\x22host\x22:\x22foo\x22,\x22hostname\x22:\x22foo\x22,\x22href\x22:\x22https://user:pass%5B%7F@foo/bar\x22,\x22origin\x22:\x22https://foo\x22,\x22password\x22:\x22pass%5B%7F\x22,\x22pathname\x22:\x22/bar\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22user\x22}");
}

test "WPT URL source index 848" {
    try fixture.check("{\x22input\x22:\x22foo:// !\x5c\x22$%&'()*+,-.;<=>@[\x5c\x5c]^_`{|}~@host/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22foo://%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~@host/\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~\x22}");
}

test "WPT URL source index 849" {
    try fixture.check("{\x22input\x22:\x22wss:// !\x5c\x22$%&'()*+,-.;<=>@[]^_`{|}~@host/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22wss://%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~@host/\x22,\x22origin\x22:\x22wss://host\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~\x22}");
}

test "WPT URL source index 850" {
    try fixture.check("{\x22input\x22:\x22foo://joe: !\x5c\x22$%&'()*+,-.:;<=>@[\x5c\x5c]^_`{|}~@host/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22foo://joe:%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~@host/\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22joe\x22}");
}

test "WPT URL source index 851" {
    try fixture.check("{\x22input\x22:\x22wss://joe: !\x5c\x22$%&'()*+,-.:;<=>@[]^_`{|}~@host/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22wss://joe:%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~@host/\x22,\x22origin\x22:\x22wss://host\x22,\x22password\x22:\x22%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22joe\x22}");
}

test "WPT URL source index 852" {
    try fixture.check("{\x22input\x22:\x22foo://!\x5c\x22$%&'()*+,-.;=_`{}~/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22!\x5c\x22$%&'()*+,-.;=_`{}~\x22,\x22hostname\x22:\x22!\x5c\x22$%&'()*+,-.;=_`{}~\x22,\x22href\x22:\x22foo://!\x5c\x22$%&'()*+,-.;=_`{}~/\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 853" {
    try fixture.check("{\x22input\x22:\x22wss://!\x5c\x22$&'()*+,-.;=_`{}~/\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22!\x5c\x22$&'()*+,-.;=_`{}~\x22,\x22hostname\x22:\x22!\x5c\x22$&'()*+,-.;=_`{}~\x22,\x22href\x22:\x22wss://!\x5c\x22$&'()*+,-.;=_`{}~/\x22,\x22origin\x22:\x22wss://!\x5c\x22$&'()*+,-.;=_`{}~\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 854" {
    try fixture.check("{\x22input\x22:\x22foo://host/ !\x5c\x22$%&'()*+,-./:;<=>@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22foo://host/%20!%22$%&'()*+,-./:;%3C=%3E@[\x5c\x5c]%5E_%60%7B|%7D~\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/%20!%22$%&'()*+,-./:;%3C=%3E@[\x5c\x5c]%5E_%60%7B|%7D~\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 855" {
    try fixture.check("{\x22input\x22:\x22wss://host/ !\x5c\x22$%&'()*+,-./:;<=>@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22wss://host/%20!%22$%&'()*+,-./:;%3C=%3E@[/]%5E_%60%7B|%7D~\x22,\x22origin\x22:\x22wss://host\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/%20!%22$%&'()*+,-./:;%3C=%3E@[/]%5E_%60%7B|%7D~\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 856" {
    try fixture.check("{\x22input\x22:\x22foo://host/dir/? !\x5c\x22$%&'()*+,-./:;<=>?@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22foo://host/dir/?%20!%22$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_`{|}~\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/dir/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22?%20!%22$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_`{|}~\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 857" {
    try fixture.check("{\x22input\x22:\x22wss://host/dir/? !\x5c\x22$%&'()*+,-./:;<=>?@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22wss://host/dir/?%20!%22$%&%27()*+,-./:;%3C=%3E?@[\x5c\x5c]^_`{|}~\x22,\x22origin\x22:\x22wss://host\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/dir/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22?%20!%22$%&%27()*+,-./:;%3C=%3E?@[\x5c\x5c]^_`{|}~\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 858" {
    try fixture.check("{\x22input\x22:\x22foo://host/dir/# !\x5c\x22#$%&'()*+,-./:;<=>?@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_%60{|}~\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22foo://host/dir/#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_%60{|}~\x22,\x22origin\x22:\x22null\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/dir/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22foo:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 859" {
    try fixture.check("{\x22input\x22:\x22wss://host/dir/# !\x5c\x22#$%&'()*+,-./:;<=>?@[\x5c\x5c]^_`{|}~\x22,\x22base\x22:null,\x22hash\x22:\x22#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_%60{|}~\x22,\x22host\x22:\x22host\x22,\x22hostname\x22:\x22host\x22,\x22href\x22:\x22wss://host/dir/#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\x5c\x5c]^_%60{|}~\x22,\x22origin\x22:\x22wss://host\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/dir/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22wss:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 861" {
    try fixture.check("{\x22input\x22:\x22abc:rootless\x22,\x22base\x22:\x22abc://host/path\x22,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22abc:rootless\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22rootless\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22abc:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 862" {
    try fixture.check("{\x22input\x22:\x22abc:rootless\x22,\x22base\x22:\x22abc:/path\x22,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22abc:rootless\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22rootless\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22abc:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 863" {
    try fixture.check("{\x22input\x22:\x22abc:rootless\x22,\x22base\x22:\x22abc:path\x22,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22abc:rootless\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22rootless\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22abc:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 864" {
    try fixture.check("{\x22input\x22:\x22abc:/rooted\x22,\x22base\x22:\x22abc://host/path\x22,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22abc:/rooted\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/rooted\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22abc:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 866" {
    try fixture.check("{\x22input\x22:\x22#\x22,\x22base\x22:null,\x22failure\x22:true,\x22relativeTo\x22:\x22any-base\x22}");
}

test "WPT URL source index 867" {
    try fixture.check("{\x22input\x22:\x22?\x22,\x22base\x22:null,\x22failure\x22:true,\x22relativeTo\x22:\x22non-opaque-path-base\x22}");
}

test "WPT URL source index 869" {
    try fixture.check("{\x22input\x22:\x22http://1.2.3.4.5\x22,\x22base\x22:\x22http://other.com/\x22,\x22failure\x22:true}");
}

test "WPT URL source index 870" {
    try fixture.check("{\x22input\x22:\x22http://1.2.3.4.5.\x22,\x22base\x22:\x22http://other.com/\x22,\x22failure\x22:true}");
}

test "WPT URL source index 871" {
    try fixture.check("{\x22input\x22:\x22http://0..0x300/\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 872" {
    try fixture.check("{\x22input\x22:\x22http://0..0x300./\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 873" {
    try fixture.check("{\x22input\x22:\x22http://256.256.256.256.256\x22,\x22base\x22:\x22http://other.com/\x22,\x22failure\x22:true}");
}

test "WPT URL source index 874" {
    try fixture.check("{\x22input\x22:\x22http://256.256.256.256.256.\x22,\x22base\x22:\x22http://other.com/\x22,\x22failure\x22:true}");
}

test "WPT URL source index 875" {
    try fixture.check("{\x22input\x22:\x22http://1.2.3.08\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 876" {
    try fixture.check("{\x22input\x22:\x22http://1.2.3.08.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 877" {
    try fixture.check("{\x22input\x22:\x22http://1.2.3.09\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 878" {
    try fixture.check("{\x22input\x22:\x22http://09.2.3.4\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 879" {
    try fixture.check("{\x22input\x22:\x22http://09.2.3.4.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 880" {
    try fixture.check("{\x22input\x22:\x22http://01.2.3.4.5\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 881" {
    try fixture.check("{\x22input\x22:\x22http://01.2.3.4.5.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 882" {
    try fixture.check("{\x22input\x22:\x22http://0x100.2.3.4\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 883" {
    try fixture.check("{\x22input\x22:\x22http://0x100.2.3.4.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 884" {
    try fixture.check("{\x22input\x22:\x22http://0x1.2.3.4.5\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 885" {
    try fixture.check("{\x22input\x22:\x22http://0x1.2.3.4.5.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 886" {
    try fixture.check("{\x22input\x22:\x22http://foo.1.2.3.4\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 887" {
    try fixture.check("{\x22input\x22:\x22http://foo.1.2.3.4.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 888" {
    try fixture.check("{\x22input\x22:\x22http://foo.2.3.4\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 889" {
    try fixture.check("{\x22input\x22:\x22http://foo.2.3.4.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 890" {
    try fixture.check("{\x22input\x22:\x22http://foo.09\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 891" {
    try fixture.check("{\x22input\x22:\x22http://foo.09.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 892" {
    try fixture.check("{\x22input\x22:\x22http://foo.0x4\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 893" {
    try fixture.check("{\x22input\x22:\x22http://foo.0x4.\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 894" {
    try fixture.check("{\x22input\x22:\x22http://foo.09..\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22foo.09..\x22,\x22hostname\x22:\x22foo.09..\x22,\x22href\x22:\x22http://foo.09../\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22http:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 895" {
    try fixture.check("{\x22input\x22:\x22http://0999999999999999999/\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 896" {
    try fixture.check("{\x22input\x22:\x22http://foo.0x\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 897" {
    try fixture.check("{\x22input\x22:\x22http://foo.0XFfFfFfFfFfFfFfFfFfAcE123\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 898" {
    try fixture.check("{\x22input\x22:\x22http://\xf0\x9f\x92\xa9.123/\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 900" {
    try fixture.check("{\x22input\x22:\x22https://\x5cu0000y\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 901" {
    try fixture.check("{\x22input\x22:\x22https://x/\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/%00y\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 902" {
    try fixture.check("{\x22input\x22:\x22https://x/?\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/?%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22?%00y\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 903" {
    try fixture.check("{\x22input\x22:\x22https://x/?#\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22#%00y\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/?#%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 904" {
    try fixture.check("{\x22input\x22:\x22https://\xef\xbf\xbfy\x22,\x22base\x22:null,\x22failure\x22:true}");
}

test "WPT URL source index 905" {
    try fixture.check("{\x22input\x22:\x22https://x/\xef\xbf\xbfy\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/%EF%BF%BFy\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/%EF%BF%BFy\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 906" {
    try fixture.check("{\x22input\x22:\x22https://x/?\xef\xbf\xbfy\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/?%EF%BF%BFy\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22?%EF%BF%BFy\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 907" {
    try fixture.check("{\x22input\x22:\x22https://x/?#\xef\xbf\xbfy\x22,\x22base\x22:null,\x22hash\x22:\x22#%EF%BF%BFy\x22,\x22host\x22:\x22x\x22,\x22hostname\x22:\x22x\x22,\x22href\x22:\x22https://x/?#%EF%BF%BFy\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22https:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 908" {
    try fixture.check("{\x22input\x22:\x22non-special:\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22non-special:%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22%00y\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22non-special:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 909" {
    try fixture.check("{\x22input\x22:\x22non-special:x/\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22non-special:x/%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22x/%00y\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22non-special:\x22,\x22search\x22:\x22\x22,\x22username\x22:\x22\x22}");
}

test "WPT URL source index 910" {
    try fixture.check("{\x22input\x22:\x22non-special:x/?\x5cu0000y\x22,\x22base\x22:null,\x22hash\x22:\x22\x22,\x22host\x22:\x22\x22,\x22hostname\x22:\x22\x22,\x22href\x22:\x22non-special:x/?%00y\x22,\x22password\x22:\x22\x22,\x22pathname\x22:\x22x/\x22,\x22port\x22:\x22\x22,\x22protocol\x22:\x22non-special:\x22,\x22search\x22:\x22?%00y\x22,\x22username\x22:\x22\x22}");
}
