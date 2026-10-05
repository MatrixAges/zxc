const fixture = @import("fixture.zig");

test "from_path case 0" {
    try fixture.check(
        \\{"operation":"from_path","input":"","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107,47,112,114,111,106,101,99,116]}
    );
}

test "from_path case 1" {
    try fixture.check(
        \\{"operation":"from_path","input":".","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107,47,112,114,111,106,101,99,116]}
    );
}

test "from_path case 2" {
    try fixture.check(
        \\{"operation":"from_path","input":"..","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107]}
    );
}

test "from_path case 3" {
    try fixture.check(
        \\{"operation":"from_path","input":"../leaf","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107,47,108,101,97,102]}
    );
}

test "from_path case 4" {
    try fixture.check(
        \\{"operation":"from_path","input":"child/","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107,47,112,114,111,106,101,99,116,47,99,104,105,108,100,47]}
    );
}

test "from_path case 5" {
    try fixture.check(
        \\{"operation":"from_path","input":"child\\","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,119,111,114,107,47,112,114,111,106,101,99,116,47,99,104,105,108,100,37,53,67]}
    );
}

test "from_path case 6" {
    try fixture.check(
        \\{"operation":"from_path","input":"/root/../leaf","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,108,101,97,102]}
    );
}

test "from_path case 7" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47]}
    );
}

test "from_path case 8" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a/../b/","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,98,47]}
    );
}

test "from_path case 9" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a%2Fb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,50,53,50,70,98]}
    );
}

test "from_path case 10" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/\u4f60\u597d\ud83d\ude80","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,37,69,52,37,66,68,37,65,48,37,69,53,37,65,53,37,66,68,37,70,48,37,57,70,37,57,65,37,56,48]}
    );
}

test "from_path case 11" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a?b#c","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,51,70,98,37,50,51,99]}
    );
}

test "from_path case 12" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a[]|~^","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,53,66,37,53,68,37,55,67,37,55,69,37,53,69]}
    );
}

test "from_path case 13" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0000b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,48,98]}
    );
}

test "from_path case 14" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0001b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,49,98]}
    );
}

test "from_path case 15" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0002b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,50,98]}
    );
}

test "from_path case 16" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0003b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,51,98]}
    );
}

test "from_path case 17" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0004b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,52,98]}
    );
}

test "from_path case 18" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0005b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,53,98]}
    );
}

test "from_path case 19" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0006b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,54,98]}
    );
}

test "from_path case 20" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0007b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,55,98]}
    );
}

test "from_path case 21" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\bb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,56,98]}
    );
}

test "from_path case 22" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\tb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,57,98]}
    );
}

test "from_path case 23" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\nb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,65,98]}
    );
}

test "from_path case 24" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u000bb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,66,98]}
    );
}

test "from_path case 25" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\fb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,67,98]}
    );
}

test "from_path case 26" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\rb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,68,98]}
    );
}

test "from_path case 27" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u000eb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,69,98]}
    );
}

test "from_path case 28" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u000fb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,48,70,98]}
    );
}

test "from_path case 29" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0010b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,48,98]}
    );
}

test "from_path case 30" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0011b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,49,98]}
    );
}

test "from_path case 31" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0012b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,50,98]}
    );
}

test "from_path case 32" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0013b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,51,98]}
    );
}

test "from_path case 33" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0014b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,52,98]}
    );
}

test "from_path case 34" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0015b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,53,98]}
    );
}

test "from_path case 35" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0016b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,54,98]}
    );
}

test "from_path case 36" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0017b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,55,98]}
    );
}

test "from_path case 37" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0018b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,56,98]}
    );
}

test "from_path case 38" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u0019b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,57,98]}
    );
}

test "from_path case 39" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001ab","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,65,98]}
    );
}

test "from_path case 40" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001bb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,66,98]}
    );
}

test "from_path case 41" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001cb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,67,98]}
    );
}

test "from_path case 42" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001db","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,68,98]}
    );
}

test "from_path case 43" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001eb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,69,98]}
    );
}

test "from_path case 44" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u001fb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,49,70,98]}
    );
}

test "from_path case 45" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,50,48,98]}
    );
}

test "from_path case 46" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a!b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,33,98]}
    );
}

test "from_path case 47" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\"b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,50,50,98]}
    );
}

test "from_path case 48" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a#b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,50,51,98]}
    );
}

test "from_path case 49" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a$b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,36,98]}
    );
}

test "from_path case 50" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a%b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,50,53,98]}
    );
}

test "from_path case 51" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a&b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,38,98]}
    );
}

test "from_path case 52" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a'b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,39,98]}
    );
}

test "from_path case 53" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a(b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,40,98]}
    );
}

test "from_path case 54" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a)b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,41,98]}
    );
}

test "from_path case 55" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a*b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,42,98]}
    );
}

test "from_path case 56" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a+b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,43,98]}
    );
}

test "from_path case 57" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a,b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,44,98]}
    );
}

test "from_path case 58" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a-b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,45,98]}
    );
}

test "from_path case 59" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a.b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,46,98]}
    );
}

test "from_path case 60" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a/b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,47,98]}
    );
}

test "from_path case 61" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a0b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,48,98]}
    );
}

test "from_path case 62" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a1b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,49,98]}
    );
}

test "from_path case 63" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a2b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,50,98]}
    );
}

test "from_path case 64" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a3b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,51,98]}
    );
}

test "from_path case 65" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a4b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,52,98]}
    );
}

test "from_path case 66" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a5b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,53,98]}
    );
}

test "from_path case 67" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a6b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,54,98]}
    );
}

test "from_path case 68" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a7b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,55,98]}
    );
}

test "from_path case 69" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a8b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,56,98]}
    );
}

test "from_path case 70" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a9b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,57,98]}
    );
}

test "from_path case 71" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a:b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,58,98]}
    );
}

test "from_path case 72" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a;b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,59,98]}
    );
}

test "from_path case 73" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a<b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,51,67,98]}
    );
}

test "from_path case 74" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a=b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,61,98]}
    );
}

test "from_path case 75" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a>b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,51,69,98]}
    );
}

test "from_path case 76" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a?b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,51,70,98]}
    );
}

test "from_path case 77" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a@b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,64,98]}
    );
}

test "from_path case 78" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aAb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,65,98]}
    );
}

test "from_path case 79" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aBb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,66,98]}
    );
}

test "from_path case 80" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aCb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,67,98]}
    );
}

test "from_path case 81" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aDb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,68,98]}
    );
}

test "from_path case 82" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aEb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,69,98]}
    );
}

test "from_path case 83" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aFb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,70,98]}
    );
}

test "from_path case 84" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aGb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,71,98]}
    );
}

test "from_path case 85" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aHb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,72,98]}
    );
}

test "from_path case 86" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aIb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,73,98]}
    );
}

test "from_path case 87" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aJb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,74,98]}
    );
}

test "from_path case 88" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aKb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,75,98]}
    );
}

test "from_path case 89" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aLb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,76,98]}
    );
}

test "from_path case 90" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aMb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,77,98]}
    );
}

test "from_path case 91" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aNb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,78,98]}
    );
}

test "from_path case 92" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aOb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,79,98]}
    );
}

test "from_path case 93" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aPb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,80,98]}
    );
}

test "from_path case 94" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aQb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,81,98]}
    );
}

test "from_path case 95" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aRb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,82,98]}
    );
}

test "from_path case 96" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aSb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,83,98]}
    );
}

test "from_path case 97" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aTb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,84,98]}
    );
}

test "from_path case 98" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aUb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,85,98]}
    );
}

test "from_path case 99" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aVb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,86,98]}
    );
}

test "from_path case 100" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aWb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,87,98]}
    );
}

test "from_path case 101" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aXb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,88,98]}
    );
}

test "from_path case 102" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aYb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,89,98]}
    );
}

test "from_path case 103" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aZb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,90,98]}
    );
}

test "from_path case 104" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a[b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,53,66,98]}
    );
}

test "from_path case 105" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\\b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,53,67,98]}
    );
}

test "from_path case 106" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a]b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,53,68,98]}
    );
}

test "from_path case 107" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a^b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,53,69,98]}
    );
}

test "from_path case 108" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a_b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,95,98]}
    );
}

test "from_path case 109" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a`b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,54,48,98]}
    );
}

test "from_path case 110" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aab","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,97,98]}
    );
}

test "from_path case 111" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/abb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,98,98]}
    );
}

test "from_path case 112" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/acb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,99,98]}
    );
}

test "from_path case 113" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/adb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,100,98]}
    );
}

test "from_path case 114" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aeb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,101,98]}
    );
}

test "from_path case 115" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/afb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,102,98]}
    );
}

test "from_path case 116" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/agb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,103,98]}
    );
}

test "from_path case 117" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/ahb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,104,98]}
    );
}

test "from_path case 118" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aib","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,105,98]}
    );
}

test "from_path case 119" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/ajb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,106,98]}
    );
}

test "from_path case 120" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/akb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,107,98]}
    );
}

test "from_path case 121" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/alb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,108,98]}
    );
}

test "from_path case 122" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/amb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,109,98]}
    );
}

test "from_path case 123" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/anb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,110,98]}
    );
}

test "from_path case 124" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aob","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,111,98]}
    );
}

test "from_path case 125" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/apb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,112,98]}
    );
}

test "from_path case 126" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aqb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,113,98]}
    );
}

test "from_path case 127" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/arb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,114,98]}
    );
}

test "from_path case 128" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/asb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,115,98]}
    );
}

test "from_path case 129" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/atb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,116,98]}
    );
}

test "from_path case 130" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/aub","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,117,98]}
    );
}

test "from_path case 131" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/avb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,118,98]}
    );
}

test "from_path case 132" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/awb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,119,98]}
    );
}

test "from_path case 133" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/axb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,120,98]}
    );
}

test "from_path case 134" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/ayb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,121,98]}
    );
}

test "from_path case 135" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/azb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,122,98]}
    );
}

test "from_path case 136" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a{b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,55,66,98]}
    );
}

test "from_path case 137" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a|b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,55,67,98]}
    );
}

test "from_path case 138" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a}b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,55,68,98]}
    );
}

test "from_path case 139" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a~b","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,55,69,98]}
    );
}

test "from_path case 140" {
    try fixture.check(
        \\{"operation":"from_path","input":"/data/a\u007fb","windows":false,"cwd":"/work/project","expected":[102,105,108,101,58,47,47,47,100,97,116,97,47,97,37,55,70,98]}
    );
}
