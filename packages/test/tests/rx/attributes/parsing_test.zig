const fixture = @import("fixture.zig");

test "expression-0-0" {
    try fixture.check(
        \\{"source":"<Probe a={$in} next=\"tail\"/>","value":"$in","raw":"$in","kind":"expression","offset":10}
    );
}

test "expression-0-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n $in \r\n } next=\"tail\"/>","value":" \r\n $in \r\n ","raw":" \r\n $in \r\n ","kind":"expression","offset":10}
    );
}

test "expression-1-0" {
    try fixture.check(
        \\{"source":"<Probe a={{a: {b: 1}}} next=\"tail\"/>","value":"{a: {b: 1}}","raw":"{a: {b: 1}}","kind":"expression","offset":10}
    );
}

test "expression-1-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n {a: {b: 1}} \r\n } next=\"tail\"/>","value":" \r\n {a: {b: 1}} \r\n ","raw":" \r\n {a: {b: 1}} \r\n ","kind":"expression","offset":10}
    );
}

test "expression-2-0" {
    try fixture.check(
        \\{"source":"<Probe a={[1, {x: \"}\"}, 3]} next=\"tail\"/>","value":"[1, {x: \"}\"}, 3]","raw":"[1, {x: \"}\"}, 3]","kind":"expression","offset":10}
    );
}

test "expression-2-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n [1, {x: \"}\"}, 3] \r\n } next=\"tail\"/>","value":" \r\n [1, {x: \"}\"}, 3] \r\n ","raw":" \r\n [1, {x: \"}\"}, 3] \r\n ","kind":"expression","offset":10}
    );
}

test "expression-3-0" {
    try fixture.check(
        \\{"source":"<Probe a={\"a}b\"} next=\"tail\"/>","value":"\"a}b\"","raw":"\"a}b\"","kind":"expression","offset":10}
    );
}

test "expression-3-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n \"a}b\" \r\n } next=\"tail\"/>","value":" \r\n \"a}b\" \r\n ","raw":" \r\n \"a}b\" \r\n ","kind":"expression","offset":10}
    );
}

test "expression-4-0" {
    try fixture.check(
        \\{"source":"<Probe a={\"a\\\"}b\"} next=\"tail\"/>","value":"\"a\\\"}b\"","raw":"\"a\\\"}b\"","kind":"expression","offset":10}
    );
}

test "expression-4-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n \"a\\\"}b\" \r\n } next=\"tail\"/>","value":" \r\n \"a\\\"}b\" \r\n ","raw":" \r\n \"a\\\"}b\" \r\n ","kind":"expression","offset":10}
    );
}

test "expression-5-0" {
    try fixture.check(
        \\{"source":"<Probe a={\"a\\\\\"} next=\"tail\"/>","value":"\"a\\\\\"","raw":"\"a\\\\\"","kind":"expression","offset":10}
    );
}

test "expression-5-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n \"a\\\\\" \r\n } next=\"tail\"/>","value":" \r\n \"a\\\\\" \r\n ","raw":" \r\n \"a\\\\\" \r\n ","kind":"expression","offset":10}
    );
}

test "expression-6-0" {
    try fixture.check(
        \\{"source":"<Probe a={`a}b`} next=\"tail\"/>","value":"`a}b`","raw":"`a}b`","kind":"expression","offset":10}
    );
}

test "expression-6-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n `a}b` \r\n } next=\"tail\"/>","value":" \r\n `a}b` \r\n ","raw":" \r\n `a}b` \r\n ","kind":"expression","offset":10}
    );
}

test "expression-7-0" {
    try fixture.check(
        \\{"source":"<Probe a={`a${{x: \"}\"}.x}b`} next=\"tail\"/>","value":"`a${{x: \"}\"}.x}b`","raw":"`a${{x: \"}\"}.x}b`","kind":"expression","offset":10}
    );
}

test "expression-7-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n `a${{x: \"}\"}.x}b` \r\n } next=\"tail\"/>","value":" \r\n `a${{x: \"}\"}.x}b` \r\n ","raw":" \r\n `a${{x: \"}\"}.x}b` \r\n ","kind":"expression","offset":10}
    );
}

test "expression-8-0" {
    try fixture.check(
        \\{"source":"<Probe a={`a${`b${$in}`}c`} next=\"tail\"/>","value":"`a${`b${$in}`}c`","raw":"`a${`b${$in}`}c`","kind":"expression","offset":10}
    );
}

test "expression-8-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n `a${`b${$in}`}c` \r\n } next=\"tail\"/>","value":" \r\n `a${`b${$in}`}c` \r\n ","raw":" \r\n `a${`b${$in}`}c` \r\n ","kind":"expression","offset":10}
    );
}

test "expression-9-0" {
    try fixture.check(
        \\{"source":"<Probe a={/* } > / < & */ $in} next=\"tail\"/>","value":"/* } > / < & */ $in","raw":"/* } > / < & */ $in","kind":"expression","offset":10}
    );
}

test "expression-9-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n /* } > / < & */ $in \r\n } next=\"tail\"/>","value":" \r\n /* } > / < & */ $in \r\n ","raw":" \r\n /* } > / < & */ $in \r\n ","kind":"expression","offset":10}
    );
}

test "expression-10-0" {
    try fixture.check(
        \\{"source":"<Probe a={$in // } > < &\n} next=\"tail\"/>","value":"$in // } > < &\n","raw":"$in // } > < &\n","kind":"expression","offset":10}
    );
}

test "expression-10-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n $in // } > < &\n \r\n } next=\"tail\"/>","value":" \r\n $in // } > < &\n \r\n ","raw":" \r\n $in // } > < &\n \r\n ","kind":"expression","offset":10}
    );
}

test "expression-11-0" {
    try fixture.check(
        \\{"source":"<Probe a={// }\r\n$in} next=\"tail\"/>","value":"// }\r\n$in","raw":"// }\r\n$in","kind":"expression","offset":10}
    );
}

test "expression-11-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n // }\r\n$in \r\n } next=\"tail\"/>","value":" \r\n // }\r\n$in \r\n ","raw":" \r\n // }\r\n$in \r\n ","kind":"expression","offset":10}
    );
}

test "expression-12-0" {
    try fixture.check(
        \\{"source":"<Probe a={\n $in < 5 && $in > 0 \n} next=\"tail\"/>","value":"\n $in < 5 && $in > 0 \n","raw":"\n $in < 5 && $in > 0 \n","kind":"expression","offset":10}
    );
}

test "expression-12-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n \n $in < 5 && $in > 0 \n \r\n } next=\"tail\"/>","value":" \r\n \n $in < 5 && $in > 0 \n \r\n ","raw":" \r\n \n $in < 5 && $in > 0 \n \r\n ","kind":"expression","offset":10}
    );
}

test "expression-13-0" {
    try fixture.check(
        \\{"source":"<Probe a={\"&amp;\"} next=\"tail\"/>","value":"\"&amp;\"","raw":"\"&amp;\"","kind":"expression","offset":10}
    );
}

test "expression-13-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n \"&amp;\" \r\n } next=\"tail\"/>","value":" \r\n \"&amp;\" \r\n ","raw":" \r\n \"&amp;\" \r\n ","kind":"expression","offset":10}
    );
}

test "expression-14-0" {
    try fixture.check(
        \\{"source":"<Probe a={{x: \"</Probe>\", y: \"next=\\\"fake\\\"\"}} next=\"tail\"/>","value":"{x: \"</Probe>\", y: \"next=\\\"fake\\\"\"}","raw":"{x: \"</Probe>\", y: \"next=\\\"fake\\\"\"}","kind":"expression","offset":10}
    );
}

test "expression-14-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n {x: \"</Probe>\", y: \"next=\\\"fake\\\"\"} \r\n } next=\"tail\"/>","value":" \r\n {x: \"</Probe>\", y: \"next=\\\"fake\\\"\"} \r\n ","raw":" \r\n {x: \"</Probe>\", y: \"next=\\\"fake\\\"\"} \r\n ","kind":"expression","offset":10}
    );
}

test "expression-15-0" {
    try fixture.check(
        \\{"source":"<Probe a={($in ?? 0)} next=\"tail\"/>","value":"($in ?? 0)","raw":"($in ?? 0)","kind":"expression","offset":10}
    );
}

test "expression-15-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n ($in ?? 0) \r\n } next=\"tail\"/>","value":" \r\n ($in ?? 0) \r\n ","raw":" \r\n ($in ?? 0) \r\n ","kind":"expression","offset":10}
    );
}

test "expression-16-0" {
    try fixture.check(
        \\{"source":"<Probe a={{\r\n value: $in\r\n}} next=\"tail\"/>","value":"{\r\n value: $in\r\n}","raw":"{\r\n value: $in\r\n}","kind":"expression","offset":10}
    );
}

test "expression-16-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n {\r\n value: $in\r\n} \r\n } next=\"tail\"/>","value":" \r\n {\r\n value: $in\r\n} \r\n ","raw":" \r\n {\r\n value: $in\r\n} \r\n ","kind":"expression","offset":10}
    );
}

test "expression-17-0" {
    try fixture.check(
        \\{"source":"<Probe a={true ? \"<\" : \">\"} next=\"tail\"/>","value":"true ? \"<\" : \">\"","raw":"true ? \"<\" : \">\"","kind":"expression","offset":10}
    );
}

test "expression-17-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n true ? \"<\" : \">\" \r\n } next=\"tail\"/>","value":" \r\n true ? \"<\" : \">\" \r\n ","raw":" \r\n true ? \"<\" : \">\" \r\n ","kind":"expression","offset":10}
    );
}

test "expression-18-0" {
    try fixture.check(
        \\{"source":"<Probe a={`\u4e2d${$in}\ud83d\ude42`} next=\"tail\"/>","value":"`\u4e2d${$in}\ud83d\ude42`","raw":"`\u4e2d${$in}\ud83d\ude42`","kind":"expression","offset":10}
    );
}

test "expression-18-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n `\u4e2d${$in}\ud83d\ude42` \r\n } next=\"tail\"/>","value":" \r\n `\u4e2d${$in}\ud83d\ude42` \r\n ","raw":" \r\n `\u4e2d${$in}\ud83d\ude42` \r\n ","kind":"expression","offset":10}
    );
}

test "expression-19-0" {
    try fixture.check(
        \\{"source":"<Probe a={[\"{\", \"}\", \"<\", \"&\"]} next=\"tail\"/>","value":"[\"{\", \"}\", \"<\", \"&\"]","raw":"[\"{\", \"}\", \"<\", \"&\"]","kind":"expression","offset":10}
    );
}

test "expression-19-4" {
    try fixture.check(
        \\{"source":"<Probe a={ \r\n [\"{\", \"}\", \"<\", \"&\"] \r\n } next=\"tail\"/>","value":" \r\n [\"{\", \"}\", \"<\", \"&\"] \r\n ","raw":" \r\n [\"{\", \"}\", \"<\", \"&\"] \r\n ","kind":"expression","offset":10}
    );
}

test "string-0-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"\" next=\"tail\"/>","value":"","raw":"","offset":10}
    );
}

test "string-0-39" {
    try fixture.check(
        \\{"source":"<Probe a='' next=\"tail\"/>","value":"","raw":"","offset":10}
    );
}

test "string-1-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"$in\" next=\"tail\"/>","value":"$in","raw":"$in","offset":10}
    );
}

test "string-1-39" {
    try fixture.check(
        \\{"source":"<Probe a='$in' next=\"tail\"/>","value":"$in","raw":"$in","offset":10}
    );
}

test "string-2-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"{x:1}\" next=\"tail\"/>","value":"{x:1}","raw":"{x:1}","offset":10}
    );
}

test "string-2-39" {
    try fixture.check(
        \\{"source":"<Probe a='{x:1}' next=\"tail\"/>","value":"{x:1}","raw":"{x:1}","offset":10}
    );
}

test "string-3-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"&amp;&lt;&gt;&quot;&apos;\" next=\"tail\"/>","value":"&<>\"'","raw":"&amp;&lt;&gt;&quot;&apos;","offset":10}
    );
}

test "string-3-39" {
    try fixture.check(
        \\{"source":"<Probe a='&amp;&lt;&gt;&quot;&apos;' next=\"tail\"/>","value":"&<>\"'","raw":"&amp;&lt;&gt;&quot;&apos;","offset":10}
    );
}

test "string-4-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"&#x4E2D;&#128578;\" next=\"tail\"/>","value":"\u4e2d\ud83d\ude42","raw":"&#x4E2D;&#128578;","offset":10}
    );
}

test "string-4-39" {
    try fixture.check(
        \\{"source":"<Probe a='&#x4E2D;&#128578;' next=\"tail\"/>","value":"\u4e2d\ud83d\ude42","raw":"&#x4E2D;&#128578;","offset":10}
    );
}

test "string-5-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"&amp;lt;\" next=\"tail\"/>","value":"&lt;","raw":"&amp;lt;","offset":10}
    );
}

test "string-5-39" {
    try fixture.check(
        \\{"source":"<Probe a='&amp;lt;' next=\"tail\"/>","value":"&lt;","raw":"&amp;lt;","offset":10}
    );
}

test "string-6-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"a\r\nb\rc\nd\te\" next=\"tail\"/>","value":"a b c d e","raw":"a\r\nb\rc\nd\te","offset":10}
    );
}

test "string-6-39" {
    try fixture.check(
        \\{"source":"<Probe a='a\r\nb\rc\nd\te' next=\"tail\"/>","value":"a b c d e","raw":"a\r\nb\rc\nd\te","offset":10}
    );
}

test "string-7-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"&#10;&#13;&#9;\" next=\"tail\"/>","value":"\n\r\t","raw":"&#10;&#13;&#9;","offset":10}
    );
}

test "string-7-39" {
    try fixture.check(
        \\{"source":"<Probe a='&#10;&#13;&#9;' next=\"tail\"/>","value":"\n\r\t","raw":"&#10;&#13;&#9;","offset":10}
    );
}

test "string-8-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"} next={x}\" next=\"tail\"/>","value":"} next={x}","raw":"} next={x}","offset":10}
    );
}

test "string-8-39" {
    try fixture.check(
        \\{"source":"<Probe a='} next={x}' next=\"tail\"/>","value":"} next={x}","raw":"} next={x}","offset":10}
    );
}

test "string-9-34" {
    try fixture.check(
        \\{"source":"<Probe a=\"`a${b}`\" next=\"tail\"/>","value":"`a${b}`","raw":"`a${b}`","offset":10}
    );
}

test "string-9-39" {
    try fixture.check(
        \\{"source":"<Probe a='`a${b}`' next=\"tail\"/>","value":"`a${b}`","raw":"`a${b}`","offset":10}
    );
}

test "malformed-0" {
    try fixture.check(
        \\{"source":"<Probe a={$in/>","syntax":true}
    );
}

test "malformed-1" {
    try fixture.check(
        \\{"source":"<Probe a={\"unterminated}/>","syntax":true}
    );
}

test "malformed-2" {
    try fixture.check(
        \\{"source":"<Probe a={`unterminated}/>","syntax":true}
    );
}

test "malformed-3" {
    try fixture.check(
        \\{"source":"<Probe a={/* never closed } />","syntax":true}
    );
}

test "malformed-4" {
    try fixture.check(
        \\{"source":"<Probe a={{x: 1}/>","syntax":true}
    );
}

test "malformed-5" {
    try fixture.check(
        \\{"source":"<Probe a={1}next=\"tail\"/>","syntax":true}
    );
}

test "malformed-6" {
    try fixture.check(
        \\{"source":"<Probe a={1} a={2}/>","syntax":true}
    );
}

test "malformed-7" {
    try fixture.check(
        \\{"source":"<Probe a={1}} next=\"tail\"/>","syntax":true}
    );
}

test "malformed-8" {
    try fixture.check(
        \\{"source":"<Probe a={1","syntax":true}
    );
}

test "malformed-9" {
    try fixture.check(
        \\{"source":"<Probe a=word/>","syntax":true}
    );
}
