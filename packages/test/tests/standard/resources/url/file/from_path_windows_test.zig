const fixture = @import("fixture.zig");

test "from_path case 691" {
    try fixture.check(
        \\{"operation":"from_path","input":"","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107,47,112,114,111,106,101,99,116]}
    );
}

test "from_path case 692" {
    try fixture.check(
        \\{"operation":"from_path","input":".","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107,47,112,114,111,106,101,99,116]}
    );
}

test "from_path case 693" {
    try fixture.check(
        \\{"operation":"from_path","input":"..","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107]}
    );
}

test "from_path case 694" {
    try fixture.check(
        \\{"operation":"from_path","input":"../leaf","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107,47,108,101,97,102]}
    );
}

test "from_path case 695" {
    try fixture.check(
        \\{"operation":"from_path","input":"child/","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107,47,112,114,111,106,101,99,116,47,99,104,105,108,100,47]}
    );
}

test "from_path case 696" {
    try fixture.check(
        \\{"operation":"from_path","input":"child\\","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,119,111,114,107,47,112,114,111,106,101,99,116,47,99,104,105,108,100,47]}
    );
}

test "from_path case 697" {
    try fixture.check(
        \\{"operation":"from_path","input":"/root/../leaf","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,108,101,97,102]}
    );
}

test "from_path case 698" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47]}
    );
}

test "from_path case 699" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a/../b/","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,98,47]}
    );
}

test "from_path case 700" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a%2Fb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,50,53,50,70,98]}
    );
}

test "from_path case 701" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\\u4f60\u597d\ud83d\ude80","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,37,69,52,37,66,68,37,65,48,37,69,53,37,65,53,37,66,68,37,70,48,37,57,70,37,57,65,37,56,48]}
    );
}

test "from_path case 702" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a?b#c","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,51,70,98,37,50,51,99]}
    );
}

test "from_path case 703" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a[]|~^","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,53,66,37,53,68,37,55,67,37,55,69,37,53,69]}
    );
}

test "from_path case 704" {
    try fixture.check(
        \\{"operation":"from_path","input":"D:\\folder\\a","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,68,58,47,102,111,108,100,101,114,47,97]}
    );
}

test "from_path case 705" {
    try fixture.check(
        \\{"operation":"from_path","input":"c:/folder/a","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,99,58,47,102,111,108,100,101,114,47,97]}
    );
}

test "from_path case 706" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\rooted","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,114,111,111,116,101,100]}
    );
}

test "from_path case 707" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\server\\share\\a","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,115,101,114,118,101,114,47,115,104,97,114,101,47,97]}
    );
}

test "from_path case 708" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\nas\\My Docs\\File.doc","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,110,97,115,47,77,121,37,50,48,68,111,99,115,47,70,105,108,101,46,100,111,99]}
    );
}

test "from_path case 709" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\UNC\\server\\share\\a","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,115,101,114,118,101,114,47,115,104,97,114,101,47,97]}
    );
}

test "from_path case 710" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\C:\\path\\to\\file.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,112,97,116,104,47,116,111,47,102,105,108,101,46,116,120,116]}
    );
}

test "from_path case 711" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\\u4f60\u597d\\share\\a","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,120,110,45,45,54,113,113,55,57,118,47,115,104,97,114,101,47,97]}
    );
}

test "from_path case 712" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\host","windows":true,"cwd":"C:\\work\\project","error":"ERR_INVALID_ARG_VALUE"}
    );
}

test "from_path case 713" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\\\missing","windows":true,"cwd":"C:\\work\\project","error":"ERR_INVALID_ARG_VALUE"}
    );
}

test "from_path case 714" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\a:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,97,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 715" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\b:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,98,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 716" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\c:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,99,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 717" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\d:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,100,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 718" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\e:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,101,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 719" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\f:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,102,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 720" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\g:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,103,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 721" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\h:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,104,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 722" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\i:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,105,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 723" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\j:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,106,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 724" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\k:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,107,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 725" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\l:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,108,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 726" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\m:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,109,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 727" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\n:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,110,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 728" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\o:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,111,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 729" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\p:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,112,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 730" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\q:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,113,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 731" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\r:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,114,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 732" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\s:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,115,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 733" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\t:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,116,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 734" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\u:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,117,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 735" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\v:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,118,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 736" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\w:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,119,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 737" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\x:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,120,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 738" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\y:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,121,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 739" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\z:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,122,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 740" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\A:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,65,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 741" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\B:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,66,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 742" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\C:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 743" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\D:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,68,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 744" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\E:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,69,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 745" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\F:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,70,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 746" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\G:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,71,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 747" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\H:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,72,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 748" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\I:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,73,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 749" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\J:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,74,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 750" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\K:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,75,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 751" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\L:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,76,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 752" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\M:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,77,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 753" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\N:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,78,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 754" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\O:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,79,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 755" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\P:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,80,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 756" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\Q:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,81,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 757" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\R:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,82,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 758" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\S:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,83,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 759" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\T:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,84,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 760" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\U:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,85,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 761" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\V:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,86,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 762" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\W:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,87,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 763" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\X:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,88,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 764" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\Y:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,89,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 765" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\?\\Z:\\folder\\..\\leaf #.txt","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,90,58,47,108,101,97,102,37,50,48,37,50,51,46,116,120,116]}
    );
}

test "from_path case 766" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\server\\share\\a\\..\\b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,115,101,114,118,101,114,47,115,104,97,114,101,47,98]}
    );
}

test "from_path case 767" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\server\\share\\a/../b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,115,101,114,118,101,114,47,115,104,97,114,101,47,98]}
    );
}

test "from_path case 768" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0000b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,48,98]}
    );
}

test "from_path case 769" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0001b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,49,98]}
    );
}

test "from_path case 770" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0002b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,50,98]}
    );
}

test "from_path case 771" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0003b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,51,98]}
    );
}

test "from_path case 772" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0004b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,52,98]}
    );
}

test "from_path case 773" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0005b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,53,98]}
    );
}

test "from_path case 774" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0006b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,54,98]}
    );
}

test "from_path case 775" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0007b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,55,98]}
    );
}

test "from_path case 776" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\bb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,56,98]}
    );
}

test "from_path case 777" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\tb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,57,98]}
    );
}

test "from_path case 778" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\nb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,65,98]}
    );
}

test "from_path case 779" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u000bb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,66,98]}
    );
}

test "from_path case 780" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\fb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,67,98]}
    );
}

test "from_path case 781" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\rb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,68,98]}
    );
}

test "from_path case 782" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u000eb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,69,98]}
    );
}

test "from_path case 783" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u000fb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,48,70,98]}
    );
}

test "from_path case 784" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0010b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,48,98]}
    );
}

test "from_path case 785" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0011b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,49,98]}
    );
}

test "from_path case 786" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0012b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,50,98]}
    );
}

test "from_path case 787" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0013b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,51,98]}
    );
}

test "from_path case 788" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0014b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,52,98]}
    );
}

test "from_path case 789" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0015b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,53,98]}
    );
}

test "from_path case 790" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0016b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,54,98]}
    );
}

test "from_path case 791" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0017b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,55,98]}
    );
}

test "from_path case 792" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0018b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,56,98]}
    );
}

test "from_path case 793" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u0019b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,57,98]}
    );
}

test "from_path case 794" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001ab","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,65,98]}
    );
}

test "from_path case 795" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001bb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,66,98]}
    );
}

test "from_path case 796" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001cb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,67,98]}
    );
}

test "from_path case 797" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001db","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,68,98]}
    );
}

test "from_path case 798" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001eb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,69,98]}
    );
}

test "from_path case 799" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u001fb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,49,70,98]}
    );
}

test "from_path case 800" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,50,48,98]}
    );
}

test "from_path case 801" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a!b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,33,98]}
    );
}

test "from_path case 802" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\"b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,50,50,98]}
    );
}

test "from_path case 803" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a#b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,50,51,98]}
    );
}

test "from_path case 804" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a$b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,36,98]}
    );
}

test "from_path case 805" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a%b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,50,53,98]}
    );
}

test "from_path case 806" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a&b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,38,98]}
    );
}

test "from_path case 807" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a'b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,39,98]}
    );
}

test "from_path case 808" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a(b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,40,98]}
    );
}

test "from_path case 809" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a)b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,41,98]}
    );
}

test "from_path case 810" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a*b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,42,98]}
    );
}

test "from_path case 811" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a+b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,43,98]}
    );
}

test "from_path case 812" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a,b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,44,98]}
    );
}

test "from_path case 813" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a-b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,45,98]}
    );
}

test "from_path case 814" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a.b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,46,98]}
    );
}

test "from_path case 815" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a/b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,47,98]}
    );
}

test "from_path case 816" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a0b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,48,98]}
    );
}

test "from_path case 817" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a1b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,49,98]}
    );
}

test "from_path case 818" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a2b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,50,98]}
    );
}

test "from_path case 819" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a3b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,51,98]}
    );
}

test "from_path case 820" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a4b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,52,98]}
    );
}

test "from_path case 821" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a5b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,53,98]}
    );
}

test "from_path case 822" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a6b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,54,98]}
    );
}

test "from_path case 823" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a7b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,55,98]}
    );
}

test "from_path case 824" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a8b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,56,98]}
    );
}

test "from_path case 825" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a9b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,57,98]}
    );
}

test "from_path case 826" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a:b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,58,98]}
    );
}

test "from_path case 827" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a;b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,59,98]}
    );
}

test "from_path case 828" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a<b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,51,67,98]}
    );
}

test "from_path case 829" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a=b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,61,98]}
    );
}

test "from_path case 830" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a>b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,51,69,98]}
    );
}

test "from_path case 831" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a?b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,51,70,98]}
    );
}

test "from_path case 832" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a@b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,64,98]}
    );
}

test "from_path case 833" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aAb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,65,98]}
    );
}

test "from_path case 834" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aBb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,66,98]}
    );
}

test "from_path case 835" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aCb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,67,98]}
    );
}

test "from_path case 836" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aDb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,68,98]}
    );
}

test "from_path case 837" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aEb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,69,98]}
    );
}

test "from_path case 838" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aFb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,70,98]}
    );
}

test "from_path case 839" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aGb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,71,98]}
    );
}

test "from_path case 840" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aHb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,72,98]}
    );
}

test "from_path case 841" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aIb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,73,98]}
    );
}

test "from_path case 842" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aJb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,74,98]}
    );
}

test "from_path case 843" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aKb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,75,98]}
    );
}

test "from_path case 844" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aLb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,76,98]}
    );
}

test "from_path case 845" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aMb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,77,98]}
    );
}

test "from_path case 846" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aNb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,78,98]}
    );
}

test "from_path case 847" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aOb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,79,98]}
    );
}

test "from_path case 848" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aPb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,80,98]}
    );
}

test "from_path case 849" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aQb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,81,98]}
    );
}

test "from_path case 850" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aRb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,82,98]}
    );
}

test "from_path case 851" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aSb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,83,98]}
    );
}

test "from_path case 852" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aTb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,84,98]}
    );
}

test "from_path case 853" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aUb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,85,98]}
    );
}

test "from_path case 854" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aVb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,86,98]}
    );
}

test "from_path case 855" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aWb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,87,98]}
    );
}

test "from_path case 856" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aXb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,88,98]}
    );
}

test "from_path case 857" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aYb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,89,98]}
    );
}

test "from_path case 858" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aZb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,90,98]}
    );
}

test "from_path case 859" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a[b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,53,66,98]}
    );
}

test "from_path case 860" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\\b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,47,98]}
    );
}

test "from_path case 861" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a]b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,53,68,98]}
    );
}

test "from_path case 862" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a^b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,53,69,98]}
    );
}

test "from_path case 863" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a_b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,95,98]}
    );
}

test "from_path case 864" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a`b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,54,48,98]}
    );
}

test "from_path case 865" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aab","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,97,98]}
    );
}

test "from_path case 866" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\abb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,98,98]}
    );
}

test "from_path case 867" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\acb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,99,98]}
    );
}

test "from_path case 868" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\adb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,100,98]}
    );
}

test "from_path case 869" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aeb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,101,98]}
    );
}

test "from_path case 870" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\afb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,102,98]}
    );
}

test "from_path case 871" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\agb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,103,98]}
    );
}

test "from_path case 872" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\ahb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,104,98]}
    );
}

test "from_path case 873" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aib","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,105,98]}
    );
}

test "from_path case 874" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\ajb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,106,98]}
    );
}

test "from_path case 875" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\akb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,107,98]}
    );
}

test "from_path case 876" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\alb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,108,98]}
    );
}

test "from_path case 877" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\amb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,109,98]}
    );
}

test "from_path case 878" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\anb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,110,98]}
    );
}

test "from_path case 879" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aob","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,111,98]}
    );
}

test "from_path case 880" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\apb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,112,98]}
    );
}

test "from_path case 881" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aqb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,113,98]}
    );
}

test "from_path case 882" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\arb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,114,98]}
    );
}

test "from_path case 883" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\asb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,115,98]}
    );
}

test "from_path case 884" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\atb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,116,98]}
    );
}

test "from_path case 885" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\aub","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,117,98]}
    );
}

test "from_path case 886" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\avb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,118,98]}
    );
}

test "from_path case 887" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\awb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,119,98]}
    );
}

test "from_path case 888" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\axb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,120,98]}
    );
}

test "from_path case 889" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\ayb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,121,98]}
    );
}

test "from_path case 890" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\azb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,122,98]}
    );
}

test "from_path case 891" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a{b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,55,66,98]}
    );
}

test "from_path case 892" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a|b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,55,67,98]}
    );
}

test "from_path case 893" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a}b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,55,68,98]}
    );
}

test "from_path case 894" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a~b","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,55,69,98]}
    );
}

test "from_path case 895" {
    try fixture.check(
        \\{"operation":"from_path","input":"C:\\data\\a\u007fb","windows":true,"cwd":"C:\\work\\project","expected":[102,105,108,101,58,47,47,47,67,58,47,100,97,116,97,47,97,37,55,70,98]}
    );
}

test "from_path case 1448" {
    try fixture.check(
        \\{"operation":"from_path","input":"\\\\host name\\share\\a","windows":true,"cwd":"C:\\work\\project","error":"ERR_INVALID_URL"}
    );
}
