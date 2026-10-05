const fixture = @import("fixture.zig");

test "to_path case 896" {
    try fixture.check(
        \\{"operation":"to_path","input":"https://example.org/a","windows":true,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_path case 898" {
    try fixture.check(
        \\{"operation":"to_path","input":"data:text/plain,a","windows":true,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_path case 900" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_path case 902" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/","windows":true,"expected":[67,58,92]}
    );
}

test "to_path case 904" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/dir/a","windows":true,"expected":[67,58,92,100,105,114,92,97]}
    );
}

test "to_path case 906" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C|/dir/a","windows":true,"expected":[67,58,92,100,105,114,92,97]}
    );
}

test "to_path case 908" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///c:/a?query#hash","windows":true,"expected":[99,58,92,97]}
    );
}

test "to_path case 910" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://localhost/C:/a","windows":true,"expected":[67,58,92,97]}
    );
}

test "to_path case 912" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://server/share/a","windows":true,"expected":[92,92,115,101,114,118,101,114,92,115,104,97,114,101,92,97]}
    );
}

test "to_path case 914" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://xn--6qq79v/share/a","windows":true,"expected":[92,92,228,189,160,229,165,189,92,115,104,97,114,101,92,97]}
    );
}

test "to_path case 916" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://[::1]/share/a","windows":true,"expected":[92,92,91,58,58,49,93,92,115,104,97,114,101,92,97]}
    );
}

test "to_path case 918" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%20b","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_path case 920" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%","windows":true,"error":"URIError"}
    );
}

test "to_path case 922" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2","windows":true,"error":"URIError"}
    );
}

test "to_path case 924" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%GG","windows":true,"error":"URIError"}
    );
}

test "to_path case 926" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%252Fb","windows":true,"expected":[67,58,92,97,37,50,70,98]}
    );
}

test "to_path case 928" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%E4%BD%A0%E5%A5%BD","windows":true,"expected":[67,58,92,228,189,160,229,165,189]}
    );
}

test "to_path case 930" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%C0%AF","windows":true,"error":"URIError"}
    );
}

test "to_path case 932" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%ED%A0%80","windows":true,"error":"URIError"}
    );
}

test "to_path case 934" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%F4%90%80%80","windows":true,"error":"URIError"}
    );
}

test "to_path case 936" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%00b","windows":true,"expected":[67,58,92,97,0,98]}
    );
}

test "to_path case 938" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%01b","windows":true,"expected":[67,58,92,97,1,98]}
    );
}

test "to_path case 940" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%02b","windows":true,"expected":[67,58,92,97,2,98]}
    );
}

test "to_path case 942" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%03b","windows":true,"expected":[67,58,92,97,3,98]}
    );
}

test "to_path case 944" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%04b","windows":true,"expected":[67,58,92,97,4,98]}
    );
}

test "to_path case 946" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%05b","windows":true,"expected":[67,58,92,97,5,98]}
    );
}

test "to_path case 948" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%06b","windows":true,"expected":[67,58,92,97,6,98]}
    );
}

test "to_path case 950" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%07b","windows":true,"expected":[67,58,92,97,7,98]}
    );
}

test "to_path case 952" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%08b","windows":true,"expected":[67,58,92,97,8,98]}
    );
}

test "to_path case 954" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%09b","windows":true,"expected":[67,58,92,97,9,98]}
    );
}

test "to_path case 956" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0ab","windows":true,"expected":[67,58,92,97,10,98]}
    );
}

test "to_path case 958" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0bb","windows":true,"expected":[67,58,92,97,11,98]}
    );
}

test "to_path case 960" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0cb","windows":true,"expected":[67,58,92,97,12,98]}
    );
}

test "to_path case 962" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0db","windows":true,"expected":[67,58,92,97,13,98]}
    );
}

test "to_path case 964" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0eb","windows":true,"expected":[67,58,92,97,14,98]}
    );
}

test "to_path case 966" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%0fb","windows":true,"expected":[67,58,92,97,15,98]}
    );
}

test "to_path case 968" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%10b","windows":true,"expected":[67,58,92,97,16,98]}
    );
}

test "to_path case 970" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%11b","windows":true,"expected":[67,58,92,97,17,98]}
    );
}

test "to_path case 972" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%12b","windows":true,"expected":[67,58,92,97,18,98]}
    );
}

test "to_path case 974" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%13b","windows":true,"expected":[67,58,92,97,19,98]}
    );
}

test "to_path case 976" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%14b","windows":true,"expected":[67,58,92,97,20,98]}
    );
}

test "to_path case 978" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%15b","windows":true,"expected":[67,58,92,97,21,98]}
    );
}

test "to_path case 980" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%16b","windows":true,"expected":[67,58,92,97,22,98]}
    );
}

test "to_path case 982" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%17b","windows":true,"expected":[67,58,92,97,23,98]}
    );
}

test "to_path case 984" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%18b","windows":true,"expected":[67,58,92,97,24,98]}
    );
}

test "to_path case 986" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%19b","windows":true,"expected":[67,58,92,97,25,98]}
    );
}

test "to_path case 988" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1ab","windows":true,"expected":[67,58,92,97,26,98]}
    );
}

test "to_path case 990" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1bb","windows":true,"expected":[67,58,92,97,27,98]}
    );
}

test "to_path case 992" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1cb","windows":true,"expected":[67,58,92,97,28,98]}
    );
}

test "to_path case 994" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1db","windows":true,"expected":[67,58,92,97,29,98]}
    );
}

test "to_path case 996" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1eb","windows":true,"expected":[67,58,92,97,30,98]}
    );
}

test "to_path case 998" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%1fb","windows":true,"expected":[67,58,92,97,31,98]}
    );
}

test "to_path case 1000" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%20b","windows":true,"expected":[67,58,92,97,32,98]}
    );
}

test "to_path case 1002" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%21b","windows":true,"expected":[67,58,92,97,33,98]}
    );
}

test "to_path case 1004" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%22b","windows":true,"expected":[67,58,92,97,34,98]}
    );
}

test "to_path case 1006" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%23b","windows":true,"expected":[67,58,92,97,35,98]}
    );
}

test "to_path case 1008" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%24b","windows":true,"expected":[67,58,92,97,36,98]}
    );
}

test "to_path case 1010" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%25b","windows":true,"expected":[67,58,92,97,37,98]}
    );
}

test "to_path case 1012" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%26b","windows":true,"expected":[67,58,92,97,38,98]}
    );
}

test "to_path case 1014" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%27b","windows":true,"expected":[67,58,92,97,39,98]}
    );
}

test "to_path case 1016" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%28b","windows":true,"expected":[67,58,92,97,40,98]}
    );
}

test "to_path case 1018" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%29b","windows":true,"expected":[67,58,92,97,41,98]}
    );
}

test "to_path case 1020" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2ab","windows":true,"expected":[67,58,92,97,42,98]}
    );
}

test "to_path case 1022" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2bb","windows":true,"expected":[67,58,92,97,43,98]}
    );
}

test "to_path case 1024" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2cb","windows":true,"expected":[67,58,92,97,44,98]}
    );
}

test "to_path case 1026" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2db","windows":true,"expected":[67,58,92,97,45,98]}
    );
}

test "to_path case 1028" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2eb","windows":true,"expected":[67,58,92,97,46,98]}
    );
}

test "to_path case 1030" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2fb","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_path case 1032" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%30b","windows":true,"expected":[67,58,92,97,48,98]}
    );
}

test "to_path case 1034" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%31b","windows":true,"expected":[67,58,92,97,49,98]}
    );
}

test "to_path case 1036" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%32b","windows":true,"expected":[67,58,92,97,50,98]}
    );
}

test "to_path case 1038" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%33b","windows":true,"expected":[67,58,92,97,51,98]}
    );
}

test "to_path case 1040" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%34b","windows":true,"expected":[67,58,92,97,52,98]}
    );
}

test "to_path case 1042" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%35b","windows":true,"expected":[67,58,92,97,53,98]}
    );
}

test "to_path case 1044" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%36b","windows":true,"expected":[67,58,92,97,54,98]}
    );
}

test "to_path case 1046" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%37b","windows":true,"expected":[67,58,92,97,55,98]}
    );
}

test "to_path case 1048" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%38b","windows":true,"expected":[67,58,92,97,56,98]}
    );
}

test "to_path case 1050" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%39b","windows":true,"expected":[67,58,92,97,57,98]}
    );
}

test "to_path case 1052" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3ab","windows":true,"expected":[67,58,92,97,58,98]}
    );
}

test "to_path case 1054" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3bb","windows":true,"expected":[67,58,92,97,59,98]}
    );
}

test "to_path case 1056" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3cb","windows":true,"expected":[67,58,92,97,60,98]}
    );
}

test "to_path case 1058" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3db","windows":true,"expected":[67,58,92,97,61,98]}
    );
}

test "to_path case 1060" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3eb","windows":true,"expected":[67,58,92,97,62,98]}
    );
}

test "to_path case 1062" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%3fb","windows":true,"expected":[67,58,92,97,63,98]}
    );
}

test "to_path case 1064" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%40b","windows":true,"expected":[67,58,92,97,64,98]}
    );
}

test "to_path case 1066" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%41b","windows":true,"expected":[67,58,92,97,65,98]}
    );
}

test "to_path case 1068" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%42b","windows":true,"expected":[67,58,92,97,66,98]}
    );
}

test "to_path case 1070" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%43b","windows":true,"expected":[67,58,92,97,67,98]}
    );
}

test "to_path case 1072" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%44b","windows":true,"expected":[67,58,92,97,68,98]}
    );
}

test "to_path case 1074" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%45b","windows":true,"expected":[67,58,92,97,69,98]}
    );
}

test "to_path case 1076" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%46b","windows":true,"expected":[67,58,92,97,70,98]}
    );
}

test "to_path case 1078" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%47b","windows":true,"expected":[67,58,92,97,71,98]}
    );
}

test "to_path case 1080" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%48b","windows":true,"expected":[67,58,92,97,72,98]}
    );
}

test "to_path case 1082" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%49b","windows":true,"expected":[67,58,92,97,73,98]}
    );
}

test "to_path case 1084" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4ab","windows":true,"expected":[67,58,92,97,74,98]}
    );
}

test "to_path case 1086" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4bb","windows":true,"expected":[67,58,92,97,75,98]}
    );
}

test "to_path case 1088" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4cb","windows":true,"expected":[67,58,92,97,76,98]}
    );
}

test "to_path case 1090" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4db","windows":true,"expected":[67,58,92,97,77,98]}
    );
}

test "to_path case 1092" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4eb","windows":true,"expected":[67,58,92,97,78,98]}
    );
}

test "to_path case 1094" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%4fb","windows":true,"expected":[67,58,92,97,79,98]}
    );
}

test "to_path case 1096" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%50b","windows":true,"expected":[67,58,92,97,80,98]}
    );
}

test "to_path case 1098" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%51b","windows":true,"expected":[67,58,92,97,81,98]}
    );
}

test "to_path case 1100" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%52b","windows":true,"expected":[67,58,92,97,82,98]}
    );
}

test "to_path case 1102" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%53b","windows":true,"expected":[67,58,92,97,83,98]}
    );
}

test "to_path case 1104" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%54b","windows":true,"expected":[67,58,92,97,84,98]}
    );
}

test "to_path case 1106" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%55b","windows":true,"expected":[67,58,92,97,85,98]}
    );
}

test "to_path case 1108" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%56b","windows":true,"expected":[67,58,92,97,86,98]}
    );
}

test "to_path case 1110" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%57b","windows":true,"expected":[67,58,92,97,87,98]}
    );
}

test "to_path case 1112" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%58b","windows":true,"expected":[67,58,92,97,88,98]}
    );
}

test "to_path case 1114" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%59b","windows":true,"expected":[67,58,92,97,89,98]}
    );
}

test "to_path case 1116" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5ab","windows":true,"expected":[67,58,92,97,90,98]}
    );
}

test "to_path case 1118" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5bb","windows":true,"expected":[67,58,92,97,91,98]}
    );
}

test "to_path case 1120" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5cb","windows":true,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_path case 1122" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5db","windows":true,"expected":[67,58,92,97,93,98]}
    );
}

test "to_path case 1124" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5eb","windows":true,"expected":[67,58,92,97,94,98]}
    );
}

test "to_path case 1126" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%5fb","windows":true,"expected":[67,58,92,97,95,98]}
    );
}

test "to_path case 1128" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%60b","windows":true,"expected":[67,58,92,97,96,98]}
    );
}

test "to_path case 1130" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%61b","windows":true,"expected":[67,58,92,97,97,98]}
    );
}

test "to_path case 1132" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%62b","windows":true,"expected":[67,58,92,97,98,98]}
    );
}

test "to_path case 1134" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%63b","windows":true,"expected":[67,58,92,97,99,98]}
    );
}

test "to_path case 1136" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%64b","windows":true,"expected":[67,58,92,97,100,98]}
    );
}

test "to_path case 1138" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%65b","windows":true,"expected":[67,58,92,97,101,98]}
    );
}

test "to_path case 1140" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%66b","windows":true,"expected":[67,58,92,97,102,98]}
    );
}

test "to_path case 1142" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%67b","windows":true,"expected":[67,58,92,97,103,98]}
    );
}

test "to_path case 1144" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%68b","windows":true,"expected":[67,58,92,97,104,98]}
    );
}

test "to_path case 1146" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%69b","windows":true,"expected":[67,58,92,97,105,98]}
    );
}

test "to_path case 1148" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6ab","windows":true,"expected":[67,58,92,97,106,98]}
    );
}

test "to_path case 1150" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6bb","windows":true,"expected":[67,58,92,97,107,98]}
    );
}

test "to_path case 1152" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6cb","windows":true,"expected":[67,58,92,97,108,98]}
    );
}

test "to_path case 1154" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6db","windows":true,"expected":[67,58,92,97,109,98]}
    );
}

test "to_path case 1156" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6eb","windows":true,"expected":[67,58,92,97,110,98]}
    );
}

test "to_path case 1158" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%6fb","windows":true,"expected":[67,58,92,97,111,98]}
    );
}

test "to_path case 1160" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%70b","windows":true,"expected":[67,58,92,97,112,98]}
    );
}

test "to_path case 1162" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%71b","windows":true,"expected":[67,58,92,97,113,98]}
    );
}

test "to_path case 1164" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%72b","windows":true,"expected":[67,58,92,97,114,98]}
    );
}

test "to_path case 1166" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%73b","windows":true,"expected":[67,58,92,97,115,98]}
    );
}

test "to_path case 1168" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%74b","windows":true,"expected":[67,58,92,97,116,98]}
    );
}

test "to_path case 1170" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%75b","windows":true,"expected":[67,58,92,97,117,98]}
    );
}

test "to_path case 1172" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%76b","windows":true,"expected":[67,58,92,97,118,98]}
    );
}

test "to_path case 1174" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%77b","windows":true,"expected":[67,58,92,97,119,98]}
    );
}

test "to_path case 1176" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%78b","windows":true,"expected":[67,58,92,97,120,98]}
    );
}

test "to_path case 1178" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%79b","windows":true,"expected":[67,58,92,97,121,98]}
    );
}

test "to_path case 1180" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7ab","windows":true,"expected":[67,58,92,97,122,98]}
    );
}

test "to_path case 1182" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7bb","windows":true,"expected":[67,58,92,97,123,98]}
    );
}

test "to_path case 1184" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7cb","windows":true,"expected":[67,58,92,97,124,98]}
    );
}

test "to_path case 1186" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7db","windows":true,"expected":[67,58,92,97,125,98]}
    );
}

test "to_path case 1188" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7eb","windows":true,"expected":[67,58,92,97,126,98]}
    );
}

test "to_path case 1190" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%7fb","windows":true,"expected":[67,58,92,97,127,98]}
    );
}

test "to_path case 1192" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%80b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1194" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%81b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1196" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%82b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1198" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%83b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1200" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%84b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1202" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%85b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1204" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%86b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1206" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%87b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1208" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%88b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1210" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%89b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1212" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8ab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1214" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8bb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1216" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8cb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1218" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8db","windows":true,"error":"URIError"}
    );
}

test "to_path case 1220" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8eb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1222" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%8fb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1224" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%90b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1226" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%91b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1228" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%92b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1230" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%93b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1232" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%94b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1234" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%95b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1236" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%96b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1238" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%97b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1240" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%98b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1242" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%99b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1244" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9ab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1246" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9bb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1248" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9cb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1250" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9db","windows":true,"error":"URIError"}
    );
}

test "to_path case 1252" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9eb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1254" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%9fb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1256" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1258" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1260" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1262" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1264" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1266" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1268" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1270" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1272" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1274" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%a9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1276" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%aab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1278" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%abb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1280" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%acb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1282" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%adb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1284" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%aeb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1286" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%afb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1288" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1290" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1292" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1294" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1296" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1298" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1300" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1302" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1304" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1306" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%b9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1308" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%bab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1310" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%bbb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1312" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%bcb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1314" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%bdb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1316" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%beb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1318" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%bfb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1320" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1322" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1324" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1326" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1328" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1330" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1332" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1334" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1336" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1338" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%c9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1340" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%cab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1342" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%cbb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1344" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ccb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1346" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%cdb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1348" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ceb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1350" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%cfb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1352" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1354" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1356" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1358" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1360" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1362" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1364" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1366" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1368" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1370" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%d9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1372" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%dab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1374" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%dbb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1376" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%dcb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1378" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ddb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1380" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%deb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1382" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%dfb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1384" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1386" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1388" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1390" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1392" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1394" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1396" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1398" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1400" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1402" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%e9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1404" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%eab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1406" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ebb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1408" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ecb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1410" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%edb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1412" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%eeb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1414" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%efb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1416" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f0b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1418" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f1b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1420" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f2b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1422" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f3b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1424" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f4b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1426" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f5b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1428" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f6b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1430" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f7b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1432" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f8b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1434" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%f9b","windows":true,"error":"URIError"}
    );
}

test "to_path case 1436" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%fab","windows":true,"error":"URIError"}
    );
}

test "to_path case 1438" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%fbb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1440" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%fcb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1442" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%fdb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1444" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%feb","windows":true,"error":"URIError"}
    );
}

test "to_path case 1446" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%ffb","windows":true,"error":"URIError"}
    );
}
