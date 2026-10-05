const fixture = @import("fixture.zig");

test "to_bytes case 897" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"https://example.org/a","windows":true,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_bytes case 899" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"data:text/plain,a","windows":true,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_bytes case 901" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_bytes case 903" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/","windows":true,"expected":[67,58,92]}
    );
}

test "to_bytes case 905" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/dir/a","windows":true,"expected":[67,58,92,100,105,114,92,97]}
    );
}

test "to_bytes case 907" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C|/dir/a","windows":true,"expected":[67,58,92,100,105,114,92,97]}
    );
}

test "to_bytes case 909" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///c:/a?query#hash","windows":true,"expected":[99,58,92,97]}
    );
}

test "to_bytes case 911" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://localhost/C:/a","windows":true,"expected":[67,58,92,97]}
    );
}

test "to_bytes case 913" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://server/share/a","windows":true,"expected":[92,92,115,101,114,118,101,114,92,115,104,97,114,101,92,97]}
    );
}

test "to_bytes case 915" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://xn--6qq79v/share/a","windows":true,"expected":[92,92,228,189,160,229,165,189,92,115,104,97,114,101,92,97]}
    );
}

test "to_bytes case 917" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://[::1]/share/a","windows":true,"expected":[92,92,91,58,58,49,93,92,115,104,97,114,101,92,97]}
    );
}

test "to_bytes case 919" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%20b","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_bytes case 921" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%","windows":true,"expected":[67,58,92,97,37]}
    );
}

test "to_bytes case 923" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2","windows":true,"expected":[67,58,92,97,37,50]}
    );
}

test "to_bytes case 925" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%GG","windows":true,"expected":[67,58,92,97,37,71,71]}
    );
}

test "to_bytes case 927" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%252Fb","windows":true,"expected":[67,58,92,97,37,50,70,98]}
    );
}

test "to_bytes case 929" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%E4%BD%A0%E5%A5%BD","windows":true,"expected":[67,58,92,228,189,160,229,165,189]}
    );
}

test "to_bytes case 931" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%C0%AF","windows":true,"expected":[67,58,92,192,175]}
    );
}

test "to_bytes case 933" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%ED%A0%80","windows":true,"expected":[67,58,92,237,160,128]}
    );
}

test "to_bytes case 935" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%F4%90%80%80","windows":true,"expected":[67,58,92,244,144,128,128]}
    );
}

test "to_bytes case 937" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%00b","windows":true,"expected":[67,58,92,97,0,98]}
    );
}

test "to_bytes case 939" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%01b","windows":true,"expected":[67,58,92,97,1,98]}
    );
}

test "to_bytes case 941" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%02b","windows":true,"expected":[67,58,92,97,2,98]}
    );
}

test "to_bytes case 943" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%03b","windows":true,"expected":[67,58,92,97,3,98]}
    );
}

test "to_bytes case 945" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%04b","windows":true,"expected":[67,58,92,97,4,98]}
    );
}

test "to_bytes case 947" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%05b","windows":true,"expected":[67,58,92,97,5,98]}
    );
}

test "to_bytes case 949" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%06b","windows":true,"expected":[67,58,92,97,6,98]}
    );
}

test "to_bytes case 951" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%07b","windows":true,"expected":[67,58,92,97,7,98]}
    );
}

test "to_bytes case 953" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%08b","windows":true,"expected":[67,58,92,97,8,98]}
    );
}

test "to_bytes case 955" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%09b","windows":true,"expected":[67,58,92,97,9,98]}
    );
}

test "to_bytes case 957" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0ab","windows":true,"expected":[67,58,92,97,10,98]}
    );
}

test "to_bytes case 959" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0bb","windows":true,"expected":[67,58,92,97,11,98]}
    );
}

test "to_bytes case 961" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0cb","windows":true,"expected":[67,58,92,97,12,98]}
    );
}

test "to_bytes case 963" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0db","windows":true,"expected":[67,58,92,97,13,98]}
    );
}

test "to_bytes case 965" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0eb","windows":true,"expected":[67,58,92,97,14,98]}
    );
}

test "to_bytes case 967" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%0fb","windows":true,"expected":[67,58,92,97,15,98]}
    );
}

test "to_bytes case 969" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%10b","windows":true,"expected":[67,58,92,97,16,98]}
    );
}

test "to_bytes case 971" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%11b","windows":true,"expected":[67,58,92,97,17,98]}
    );
}

test "to_bytes case 973" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%12b","windows":true,"expected":[67,58,92,97,18,98]}
    );
}

test "to_bytes case 975" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%13b","windows":true,"expected":[67,58,92,97,19,98]}
    );
}

test "to_bytes case 977" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%14b","windows":true,"expected":[67,58,92,97,20,98]}
    );
}

test "to_bytes case 979" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%15b","windows":true,"expected":[67,58,92,97,21,98]}
    );
}

test "to_bytes case 981" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%16b","windows":true,"expected":[67,58,92,97,22,98]}
    );
}

test "to_bytes case 983" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%17b","windows":true,"expected":[67,58,92,97,23,98]}
    );
}

test "to_bytes case 985" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%18b","windows":true,"expected":[67,58,92,97,24,98]}
    );
}

test "to_bytes case 987" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%19b","windows":true,"expected":[67,58,92,97,25,98]}
    );
}

test "to_bytes case 989" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1ab","windows":true,"expected":[67,58,92,97,26,98]}
    );
}

test "to_bytes case 991" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1bb","windows":true,"expected":[67,58,92,97,27,98]}
    );
}

test "to_bytes case 993" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1cb","windows":true,"expected":[67,58,92,97,28,98]}
    );
}

test "to_bytes case 995" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1db","windows":true,"expected":[67,58,92,97,29,98]}
    );
}

test "to_bytes case 997" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1eb","windows":true,"expected":[67,58,92,97,30,98]}
    );
}

test "to_bytes case 999" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%1fb","windows":true,"expected":[67,58,92,97,31,98]}
    );
}

test "to_bytes case 1001" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%20b","windows":true,"expected":[67,58,92,97,32,98]}
    );
}

test "to_bytes case 1003" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%21b","windows":true,"expected":[67,58,92,97,33,98]}
    );
}

test "to_bytes case 1005" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%22b","windows":true,"expected":[67,58,92,97,34,98]}
    );
}

test "to_bytes case 1007" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%23b","windows":true,"expected":[67,58,92,97,35,98]}
    );
}

test "to_bytes case 1009" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%24b","windows":true,"expected":[67,58,92,97,36,98]}
    );
}

test "to_bytes case 1011" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%25b","windows":true,"expected":[67,58,92,97,37,98]}
    );
}

test "to_bytes case 1013" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%26b","windows":true,"expected":[67,58,92,97,38,98]}
    );
}

test "to_bytes case 1015" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%27b","windows":true,"expected":[67,58,92,97,39,98]}
    );
}

test "to_bytes case 1017" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%28b","windows":true,"expected":[67,58,92,97,40,98]}
    );
}

test "to_bytes case 1019" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%29b","windows":true,"expected":[67,58,92,97,41,98]}
    );
}

test "to_bytes case 1021" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2ab","windows":true,"expected":[67,58,92,97,42,98]}
    );
}

test "to_bytes case 1023" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2bb","windows":true,"expected":[67,58,92,97,43,98]}
    );
}

test "to_bytes case 1025" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2cb","windows":true,"expected":[67,58,92,97,44,98]}
    );
}

test "to_bytes case 1027" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2db","windows":true,"expected":[67,58,92,97,45,98]}
    );
}

test "to_bytes case 1029" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2eb","windows":true,"expected":[67,58,92,97,46,98]}
    );
}

test "to_bytes case 1031" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2fb","windows":true,"expected":[67,58,92,97,47,98]}
    );
}

test "to_bytes case 1033" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%30b","windows":true,"expected":[67,58,92,97,48,98]}
    );
}

test "to_bytes case 1035" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%31b","windows":true,"expected":[67,58,92,97,49,98]}
    );
}

test "to_bytes case 1037" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%32b","windows":true,"expected":[67,58,92,97,50,98]}
    );
}

test "to_bytes case 1039" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%33b","windows":true,"expected":[67,58,92,97,51,98]}
    );
}

test "to_bytes case 1041" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%34b","windows":true,"expected":[67,58,92,97,52,98]}
    );
}

test "to_bytes case 1043" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%35b","windows":true,"expected":[67,58,92,97,53,98]}
    );
}

test "to_bytes case 1045" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%36b","windows":true,"expected":[67,58,92,97,54,98]}
    );
}

test "to_bytes case 1047" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%37b","windows":true,"expected":[67,58,92,97,55,98]}
    );
}

test "to_bytes case 1049" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%38b","windows":true,"expected":[67,58,92,97,56,98]}
    );
}

test "to_bytes case 1051" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%39b","windows":true,"expected":[67,58,92,97,57,98]}
    );
}

test "to_bytes case 1053" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3ab","windows":true,"expected":[67,58,92,97,58,98]}
    );
}

test "to_bytes case 1055" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3bb","windows":true,"expected":[67,58,92,97,59,98]}
    );
}

test "to_bytes case 1057" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3cb","windows":true,"expected":[67,58,92,97,60,98]}
    );
}

test "to_bytes case 1059" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3db","windows":true,"expected":[67,58,92,97,61,98]}
    );
}

test "to_bytes case 1061" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3eb","windows":true,"expected":[67,58,92,97,62,98]}
    );
}

test "to_bytes case 1063" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%3fb","windows":true,"expected":[67,58,92,97,63,98]}
    );
}

test "to_bytes case 1065" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%40b","windows":true,"expected":[67,58,92,97,64,98]}
    );
}

test "to_bytes case 1067" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%41b","windows":true,"expected":[67,58,92,97,65,98]}
    );
}

test "to_bytes case 1069" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%42b","windows":true,"expected":[67,58,92,97,66,98]}
    );
}

test "to_bytes case 1071" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%43b","windows":true,"expected":[67,58,92,97,67,98]}
    );
}

test "to_bytes case 1073" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%44b","windows":true,"expected":[67,58,92,97,68,98]}
    );
}

test "to_bytes case 1075" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%45b","windows":true,"expected":[67,58,92,97,69,98]}
    );
}

test "to_bytes case 1077" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%46b","windows":true,"expected":[67,58,92,97,70,98]}
    );
}

test "to_bytes case 1079" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%47b","windows":true,"expected":[67,58,92,97,71,98]}
    );
}

test "to_bytes case 1081" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%48b","windows":true,"expected":[67,58,92,97,72,98]}
    );
}

test "to_bytes case 1083" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%49b","windows":true,"expected":[67,58,92,97,73,98]}
    );
}

test "to_bytes case 1085" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4ab","windows":true,"expected":[67,58,92,97,74,98]}
    );
}

test "to_bytes case 1087" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4bb","windows":true,"expected":[67,58,92,97,75,98]}
    );
}

test "to_bytes case 1089" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4cb","windows":true,"expected":[67,58,92,97,76,98]}
    );
}

test "to_bytes case 1091" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4db","windows":true,"expected":[67,58,92,97,77,98]}
    );
}

test "to_bytes case 1093" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4eb","windows":true,"expected":[67,58,92,97,78,98]}
    );
}

test "to_bytes case 1095" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%4fb","windows":true,"expected":[67,58,92,97,79,98]}
    );
}

test "to_bytes case 1097" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%50b","windows":true,"expected":[67,58,92,97,80,98]}
    );
}

test "to_bytes case 1099" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%51b","windows":true,"expected":[67,58,92,97,81,98]}
    );
}

test "to_bytes case 1101" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%52b","windows":true,"expected":[67,58,92,97,82,98]}
    );
}

test "to_bytes case 1103" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%53b","windows":true,"expected":[67,58,92,97,83,98]}
    );
}

test "to_bytes case 1105" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%54b","windows":true,"expected":[67,58,92,97,84,98]}
    );
}

test "to_bytes case 1107" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%55b","windows":true,"expected":[67,58,92,97,85,98]}
    );
}

test "to_bytes case 1109" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%56b","windows":true,"expected":[67,58,92,97,86,98]}
    );
}

test "to_bytes case 1111" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%57b","windows":true,"expected":[67,58,92,97,87,98]}
    );
}

test "to_bytes case 1113" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%58b","windows":true,"expected":[67,58,92,97,88,98]}
    );
}

test "to_bytes case 1115" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%59b","windows":true,"expected":[67,58,92,97,89,98]}
    );
}

test "to_bytes case 1117" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5ab","windows":true,"expected":[67,58,92,97,90,98]}
    );
}

test "to_bytes case 1119" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5bb","windows":true,"expected":[67,58,92,97,91,98]}
    );
}

test "to_bytes case 1121" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5cb","windows":true,"expected":[67,58,92,97,92,98]}
    );
}

test "to_bytes case 1123" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5db","windows":true,"expected":[67,58,92,97,93,98]}
    );
}

test "to_bytes case 1125" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5eb","windows":true,"expected":[67,58,92,97,94,98]}
    );
}

test "to_bytes case 1127" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%5fb","windows":true,"expected":[67,58,92,97,95,98]}
    );
}

test "to_bytes case 1129" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%60b","windows":true,"expected":[67,58,92,97,96,98]}
    );
}

test "to_bytes case 1131" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%61b","windows":true,"expected":[67,58,92,97,97,98]}
    );
}

test "to_bytes case 1133" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%62b","windows":true,"expected":[67,58,92,97,98,98]}
    );
}

test "to_bytes case 1135" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%63b","windows":true,"expected":[67,58,92,97,99,98]}
    );
}

test "to_bytes case 1137" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%64b","windows":true,"expected":[67,58,92,97,100,98]}
    );
}

test "to_bytes case 1139" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%65b","windows":true,"expected":[67,58,92,97,101,98]}
    );
}

test "to_bytes case 1141" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%66b","windows":true,"expected":[67,58,92,97,102,98]}
    );
}

test "to_bytes case 1143" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%67b","windows":true,"expected":[67,58,92,97,103,98]}
    );
}

test "to_bytes case 1145" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%68b","windows":true,"expected":[67,58,92,97,104,98]}
    );
}

test "to_bytes case 1147" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%69b","windows":true,"expected":[67,58,92,97,105,98]}
    );
}

test "to_bytes case 1149" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6ab","windows":true,"expected":[67,58,92,97,106,98]}
    );
}

test "to_bytes case 1151" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6bb","windows":true,"expected":[67,58,92,97,107,98]}
    );
}

test "to_bytes case 1153" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6cb","windows":true,"expected":[67,58,92,97,108,98]}
    );
}

test "to_bytes case 1155" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6db","windows":true,"expected":[67,58,92,97,109,98]}
    );
}

test "to_bytes case 1157" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6eb","windows":true,"expected":[67,58,92,97,110,98]}
    );
}

test "to_bytes case 1159" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%6fb","windows":true,"expected":[67,58,92,97,111,98]}
    );
}

test "to_bytes case 1161" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%70b","windows":true,"expected":[67,58,92,97,112,98]}
    );
}

test "to_bytes case 1163" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%71b","windows":true,"expected":[67,58,92,97,113,98]}
    );
}

test "to_bytes case 1165" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%72b","windows":true,"expected":[67,58,92,97,114,98]}
    );
}

test "to_bytes case 1167" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%73b","windows":true,"expected":[67,58,92,97,115,98]}
    );
}

test "to_bytes case 1169" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%74b","windows":true,"expected":[67,58,92,97,116,98]}
    );
}

test "to_bytes case 1171" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%75b","windows":true,"expected":[67,58,92,97,117,98]}
    );
}

test "to_bytes case 1173" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%76b","windows":true,"expected":[67,58,92,97,118,98]}
    );
}

test "to_bytes case 1175" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%77b","windows":true,"expected":[67,58,92,97,119,98]}
    );
}

test "to_bytes case 1177" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%78b","windows":true,"expected":[67,58,92,97,120,98]}
    );
}

test "to_bytes case 1179" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%79b","windows":true,"expected":[67,58,92,97,121,98]}
    );
}

test "to_bytes case 1181" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7ab","windows":true,"expected":[67,58,92,97,122,98]}
    );
}

test "to_bytes case 1183" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7bb","windows":true,"expected":[67,58,92,97,123,98]}
    );
}

test "to_bytes case 1185" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7cb","windows":true,"expected":[67,58,92,97,124,98]}
    );
}

test "to_bytes case 1187" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7db","windows":true,"expected":[67,58,92,97,125,98]}
    );
}

test "to_bytes case 1189" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7eb","windows":true,"expected":[67,58,92,97,126,98]}
    );
}

test "to_bytes case 1191" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%7fb","windows":true,"expected":[67,58,92,97,127,98]}
    );
}

test "to_bytes case 1193" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%80b","windows":true,"expected":[67,58,92,97,128,98]}
    );
}

test "to_bytes case 1195" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%81b","windows":true,"expected":[67,58,92,97,129,98]}
    );
}

test "to_bytes case 1197" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%82b","windows":true,"expected":[67,58,92,97,130,98]}
    );
}

test "to_bytes case 1199" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%83b","windows":true,"expected":[67,58,92,97,131,98]}
    );
}

test "to_bytes case 1201" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%84b","windows":true,"expected":[67,58,92,97,132,98]}
    );
}

test "to_bytes case 1203" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%85b","windows":true,"expected":[67,58,92,97,133,98]}
    );
}

test "to_bytes case 1205" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%86b","windows":true,"expected":[67,58,92,97,134,98]}
    );
}

test "to_bytes case 1207" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%87b","windows":true,"expected":[67,58,92,97,135,98]}
    );
}

test "to_bytes case 1209" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%88b","windows":true,"expected":[67,58,92,97,136,98]}
    );
}

test "to_bytes case 1211" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%89b","windows":true,"expected":[67,58,92,97,137,98]}
    );
}

test "to_bytes case 1213" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8ab","windows":true,"expected":[67,58,92,97,138,98]}
    );
}

test "to_bytes case 1215" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8bb","windows":true,"expected":[67,58,92,97,139,98]}
    );
}

test "to_bytes case 1217" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8cb","windows":true,"expected":[67,58,92,97,140,98]}
    );
}

test "to_bytes case 1219" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8db","windows":true,"expected":[67,58,92,97,141,98]}
    );
}

test "to_bytes case 1221" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8eb","windows":true,"expected":[67,58,92,97,142,98]}
    );
}

test "to_bytes case 1223" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%8fb","windows":true,"expected":[67,58,92,97,143,98]}
    );
}

test "to_bytes case 1225" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%90b","windows":true,"expected":[67,58,92,97,144,98]}
    );
}

test "to_bytes case 1227" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%91b","windows":true,"expected":[67,58,92,97,145,98]}
    );
}

test "to_bytes case 1229" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%92b","windows":true,"expected":[67,58,92,97,146,98]}
    );
}

test "to_bytes case 1231" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%93b","windows":true,"expected":[67,58,92,97,147,98]}
    );
}

test "to_bytes case 1233" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%94b","windows":true,"expected":[67,58,92,97,148,98]}
    );
}

test "to_bytes case 1235" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%95b","windows":true,"expected":[67,58,92,97,149,98]}
    );
}

test "to_bytes case 1237" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%96b","windows":true,"expected":[67,58,92,97,150,98]}
    );
}

test "to_bytes case 1239" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%97b","windows":true,"expected":[67,58,92,97,151,98]}
    );
}

test "to_bytes case 1241" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%98b","windows":true,"expected":[67,58,92,97,152,98]}
    );
}

test "to_bytes case 1243" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%99b","windows":true,"expected":[67,58,92,97,153,98]}
    );
}

test "to_bytes case 1245" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9ab","windows":true,"expected":[67,58,92,97,154,98]}
    );
}

test "to_bytes case 1247" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9bb","windows":true,"expected":[67,58,92,97,155,98]}
    );
}

test "to_bytes case 1249" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9cb","windows":true,"expected":[67,58,92,97,156,98]}
    );
}

test "to_bytes case 1251" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9db","windows":true,"expected":[67,58,92,97,157,98]}
    );
}

test "to_bytes case 1253" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9eb","windows":true,"expected":[67,58,92,97,158,98]}
    );
}

test "to_bytes case 1255" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%9fb","windows":true,"expected":[67,58,92,97,159,98]}
    );
}

test "to_bytes case 1257" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a0b","windows":true,"expected":[67,58,92,97,160,98]}
    );
}

test "to_bytes case 1259" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a1b","windows":true,"expected":[67,58,92,97,161,98]}
    );
}

test "to_bytes case 1261" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a2b","windows":true,"expected":[67,58,92,97,162,98]}
    );
}

test "to_bytes case 1263" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a3b","windows":true,"expected":[67,58,92,97,163,98]}
    );
}

test "to_bytes case 1265" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a4b","windows":true,"expected":[67,58,92,97,164,98]}
    );
}

test "to_bytes case 1267" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a5b","windows":true,"expected":[67,58,92,97,165,98]}
    );
}

test "to_bytes case 1269" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a6b","windows":true,"expected":[67,58,92,97,166,98]}
    );
}

test "to_bytes case 1271" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a7b","windows":true,"expected":[67,58,92,97,167,98]}
    );
}

test "to_bytes case 1273" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a8b","windows":true,"expected":[67,58,92,97,168,98]}
    );
}

test "to_bytes case 1275" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%a9b","windows":true,"expected":[67,58,92,97,169,98]}
    );
}

test "to_bytes case 1277" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%aab","windows":true,"expected":[67,58,92,97,170,98]}
    );
}

test "to_bytes case 1279" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%abb","windows":true,"expected":[67,58,92,97,171,98]}
    );
}

test "to_bytes case 1281" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%acb","windows":true,"expected":[67,58,92,97,172,98]}
    );
}

test "to_bytes case 1283" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%adb","windows":true,"expected":[67,58,92,97,173,98]}
    );
}

test "to_bytes case 1285" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%aeb","windows":true,"expected":[67,58,92,97,174,98]}
    );
}

test "to_bytes case 1287" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%afb","windows":true,"expected":[67,58,92,97,175,98]}
    );
}

test "to_bytes case 1289" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b0b","windows":true,"expected":[67,58,92,97,176,98]}
    );
}

test "to_bytes case 1291" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b1b","windows":true,"expected":[67,58,92,97,177,98]}
    );
}

test "to_bytes case 1293" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b2b","windows":true,"expected":[67,58,92,97,178,98]}
    );
}

test "to_bytes case 1295" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b3b","windows":true,"expected":[67,58,92,97,179,98]}
    );
}

test "to_bytes case 1297" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b4b","windows":true,"expected":[67,58,92,97,180,98]}
    );
}

test "to_bytes case 1299" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b5b","windows":true,"expected":[67,58,92,97,181,98]}
    );
}

test "to_bytes case 1301" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b6b","windows":true,"expected":[67,58,92,97,182,98]}
    );
}

test "to_bytes case 1303" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b7b","windows":true,"expected":[67,58,92,97,183,98]}
    );
}

test "to_bytes case 1305" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b8b","windows":true,"expected":[67,58,92,97,184,98]}
    );
}

test "to_bytes case 1307" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%b9b","windows":true,"expected":[67,58,92,97,185,98]}
    );
}

test "to_bytes case 1309" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%bab","windows":true,"expected":[67,58,92,97,186,98]}
    );
}

test "to_bytes case 1311" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%bbb","windows":true,"expected":[67,58,92,97,187,98]}
    );
}

test "to_bytes case 1313" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%bcb","windows":true,"expected":[67,58,92,97,188,98]}
    );
}

test "to_bytes case 1315" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%bdb","windows":true,"expected":[67,58,92,97,189,98]}
    );
}

test "to_bytes case 1317" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%beb","windows":true,"expected":[67,58,92,97,190,98]}
    );
}

test "to_bytes case 1319" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%bfb","windows":true,"expected":[67,58,92,97,191,98]}
    );
}

test "to_bytes case 1321" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c0b","windows":true,"expected":[67,58,92,97,192,98]}
    );
}

test "to_bytes case 1323" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c1b","windows":true,"expected":[67,58,92,97,193,98]}
    );
}

test "to_bytes case 1325" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c2b","windows":true,"expected":[67,58,92,97,194,98]}
    );
}

test "to_bytes case 1327" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c3b","windows":true,"expected":[67,58,92,97,195,98]}
    );
}

test "to_bytes case 1329" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c4b","windows":true,"expected":[67,58,92,97,196,98]}
    );
}

test "to_bytes case 1331" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c5b","windows":true,"expected":[67,58,92,97,197,98]}
    );
}

test "to_bytes case 1333" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c6b","windows":true,"expected":[67,58,92,97,198,98]}
    );
}

test "to_bytes case 1335" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c7b","windows":true,"expected":[67,58,92,97,199,98]}
    );
}

test "to_bytes case 1337" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c8b","windows":true,"expected":[67,58,92,97,200,98]}
    );
}

test "to_bytes case 1339" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%c9b","windows":true,"expected":[67,58,92,97,201,98]}
    );
}

test "to_bytes case 1341" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%cab","windows":true,"expected":[67,58,92,97,202,98]}
    );
}

test "to_bytes case 1343" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%cbb","windows":true,"expected":[67,58,92,97,203,98]}
    );
}

test "to_bytes case 1345" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ccb","windows":true,"expected":[67,58,92,97,204,98]}
    );
}

test "to_bytes case 1347" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%cdb","windows":true,"expected":[67,58,92,97,205,98]}
    );
}

test "to_bytes case 1349" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ceb","windows":true,"expected":[67,58,92,97,206,98]}
    );
}

test "to_bytes case 1351" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%cfb","windows":true,"expected":[67,58,92,97,207,98]}
    );
}

test "to_bytes case 1353" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d0b","windows":true,"expected":[67,58,92,97,208,98]}
    );
}

test "to_bytes case 1355" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d1b","windows":true,"expected":[67,58,92,97,209,98]}
    );
}

test "to_bytes case 1357" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d2b","windows":true,"expected":[67,58,92,97,210,98]}
    );
}

test "to_bytes case 1359" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d3b","windows":true,"expected":[67,58,92,97,211,98]}
    );
}

test "to_bytes case 1361" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d4b","windows":true,"expected":[67,58,92,97,212,98]}
    );
}

test "to_bytes case 1363" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d5b","windows":true,"expected":[67,58,92,97,213,98]}
    );
}

test "to_bytes case 1365" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d6b","windows":true,"expected":[67,58,92,97,214,98]}
    );
}

test "to_bytes case 1367" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d7b","windows":true,"expected":[67,58,92,97,215,98]}
    );
}

test "to_bytes case 1369" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d8b","windows":true,"expected":[67,58,92,97,216,98]}
    );
}

test "to_bytes case 1371" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%d9b","windows":true,"expected":[67,58,92,97,217,98]}
    );
}

test "to_bytes case 1373" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%dab","windows":true,"expected":[67,58,92,97,218,98]}
    );
}

test "to_bytes case 1375" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%dbb","windows":true,"expected":[67,58,92,97,219,98]}
    );
}

test "to_bytes case 1377" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%dcb","windows":true,"expected":[67,58,92,97,220,98]}
    );
}

test "to_bytes case 1379" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ddb","windows":true,"expected":[67,58,92,97,221,98]}
    );
}

test "to_bytes case 1381" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%deb","windows":true,"expected":[67,58,92,97,222,98]}
    );
}

test "to_bytes case 1383" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%dfb","windows":true,"expected":[67,58,92,97,223,98]}
    );
}

test "to_bytes case 1385" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e0b","windows":true,"expected":[67,58,92,97,224,98]}
    );
}

test "to_bytes case 1387" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e1b","windows":true,"expected":[67,58,92,97,225,98]}
    );
}

test "to_bytes case 1389" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e2b","windows":true,"expected":[67,58,92,97,226,98]}
    );
}

test "to_bytes case 1391" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e3b","windows":true,"expected":[67,58,92,97,227,98]}
    );
}

test "to_bytes case 1393" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e4b","windows":true,"expected":[67,58,92,97,228,98]}
    );
}

test "to_bytes case 1395" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e5b","windows":true,"expected":[67,58,92,97,229,98]}
    );
}

test "to_bytes case 1397" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e6b","windows":true,"expected":[67,58,92,97,230,98]}
    );
}

test "to_bytes case 1399" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e7b","windows":true,"expected":[67,58,92,97,231,98]}
    );
}

test "to_bytes case 1401" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e8b","windows":true,"expected":[67,58,92,97,232,98]}
    );
}

test "to_bytes case 1403" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%e9b","windows":true,"expected":[67,58,92,97,233,98]}
    );
}

test "to_bytes case 1405" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%eab","windows":true,"expected":[67,58,92,97,234,98]}
    );
}

test "to_bytes case 1407" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ebb","windows":true,"expected":[67,58,92,97,235,98]}
    );
}

test "to_bytes case 1409" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ecb","windows":true,"expected":[67,58,92,97,236,98]}
    );
}

test "to_bytes case 1411" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%edb","windows":true,"expected":[67,58,92,97,237,98]}
    );
}

test "to_bytes case 1413" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%eeb","windows":true,"expected":[67,58,92,97,238,98]}
    );
}

test "to_bytes case 1415" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%efb","windows":true,"expected":[67,58,92,97,239,98]}
    );
}

test "to_bytes case 1417" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f0b","windows":true,"expected":[67,58,92,97,240,98]}
    );
}

test "to_bytes case 1419" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f1b","windows":true,"expected":[67,58,92,97,241,98]}
    );
}

test "to_bytes case 1421" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f2b","windows":true,"expected":[67,58,92,97,242,98]}
    );
}

test "to_bytes case 1423" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f3b","windows":true,"expected":[67,58,92,97,243,98]}
    );
}

test "to_bytes case 1425" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f4b","windows":true,"expected":[67,58,92,97,244,98]}
    );
}

test "to_bytes case 1427" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f5b","windows":true,"expected":[67,58,92,97,245,98]}
    );
}

test "to_bytes case 1429" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f6b","windows":true,"expected":[67,58,92,97,246,98]}
    );
}

test "to_bytes case 1431" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f7b","windows":true,"expected":[67,58,92,97,247,98]}
    );
}

test "to_bytes case 1433" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f8b","windows":true,"expected":[67,58,92,97,248,98]}
    );
}

test "to_bytes case 1435" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%f9b","windows":true,"expected":[67,58,92,97,249,98]}
    );
}

test "to_bytes case 1437" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%fab","windows":true,"expected":[67,58,92,97,250,98]}
    );
}

test "to_bytes case 1439" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%fbb","windows":true,"expected":[67,58,92,97,251,98]}
    );
}

test "to_bytes case 1441" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%fcb","windows":true,"expected":[67,58,92,97,252,98]}
    );
}

test "to_bytes case 1443" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%fdb","windows":true,"expected":[67,58,92,97,253,98]}
    );
}

test "to_bytes case 1445" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%feb","windows":true,"expected":[67,58,92,97,254,98]}
    );
}

test "to_bytes case 1447" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%ffb","windows":true,"expected":[67,58,92,97,255,98]}
    );
}
