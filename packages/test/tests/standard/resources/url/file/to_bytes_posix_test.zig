const fixture = @import("fixture.zig");

test "to_bytes case 142" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"https://example.org/a","windows":false,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_bytes case 144" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"data:text/plain,a","windows":false,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_bytes case 146" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///","windows":false,"expected":[47]}
    );
}

test "to_bytes case 148" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/","windows":false,"expected":[47,67,58,47]}
    );
}

test "to_bytes case 150" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/dir/a","windows":false,"expected":[47,67,58,47,100,105,114,47,97]}
    );
}

test "to_bytes case 152" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C|/dir/a","windows":false,"expected":[47,67,58,47,100,105,114,47,97]}
    );
}

test "to_bytes case 154" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///c:/a?query#hash","windows":false,"expected":[47,99,58,47,97]}
    );
}

test "to_bytes case 156" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://localhost/C:/a","windows":false,"expected":[47,67,58,47,97]}
    );
}

test "to_bytes case 158" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://server/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_bytes case 160" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://xn--6qq79v/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_bytes case 162" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file://[::1]/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_bytes case 164" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%20b","windows":false,"expected":[47,97,32,98]}
    );
}

test "to_bytes case 166" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%","windows":false,"expected":[47,67,58,47,97,37]}
    );
}

test "to_bytes case 168" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%2","windows":false,"expected":[47,67,58,47,97,37,50]}
    );
}

test "to_bytes case 170" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%GG","windows":false,"expected":[47,67,58,47,97,37,71,71]}
    );
}

test "to_bytes case 172" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/a%252Fb","windows":false,"expected":[47,67,58,47,97,37,50,70,98]}
    );
}

test "to_bytes case 174" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%E4%BD%A0%E5%A5%BD","windows":false,"expected":[47,67,58,47,228,189,160,229,165,189]}
    );
}

test "to_bytes case 176" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%C0%AF","windows":false,"expected":[47,67,58,47,192,175]}
    );
}

test "to_bytes case 178" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%ED%A0%80","windows":false,"expected":[47,67,58,47,237,160,128]}
    );
}

test "to_bytes case 180" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///C:/%F4%90%80%80","windows":false,"expected":[47,67,58,47,244,144,128,128]}
    );
}

test "to_bytes case 182" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%00b","windows":false,"expected":[47,97,0,98]}
    );
}

test "to_bytes case 184" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%01b","windows":false,"expected":[47,97,1,98]}
    );
}

test "to_bytes case 186" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%02b","windows":false,"expected":[47,97,2,98]}
    );
}

test "to_bytes case 188" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%03b","windows":false,"expected":[47,97,3,98]}
    );
}

test "to_bytes case 190" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%04b","windows":false,"expected":[47,97,4,98]}
    );
}

test "to_bytes case 192" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%05b","windows":false,"expected":[47,97,5,98]}
    );
}

test "to_bytes case 194" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%06b","windows":false,"expected":[47,97,6,98]}
    );
}

test "to_bytes case 196" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%07b","windows":false,"expected":[47,97,7,98]}
    );
}

test "to_bytes case 198" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%08b","windows":false,"expected":[47,97,8,98]}
    );
}

test "to_bytes case 200" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%09b","windows":false,"expected":[47,97,9,98]}
    );
}

test "to_bytes case 202" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0ab","windows":false,"expected":[47,97,10,98]}
    );
}

test "to_bytes case 204" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0bb","windows":false,"expected":[47,97,11,98]}
    );
}

test "to_bytes case 206" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0cb","windows":false,"expected":[47,97,12,98]}
    );
}

test "to_bytes case 208" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0db","windows":false,"expected":[47,97,13,98]}
    );
}

test "to_bytes case 210" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0eb","windows":false,"expected":[47,97,14,98]}
    );
}

test "to_bytes case 212" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%0fb","windows":false,"expected":[47,97,15,98]}
    );
}

test "to_bytes case 214" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%10b","windows":false,"expected":[47,97,16,98]}
    );
}

test "to_bytes case 216" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%11b","windows":false,"expected":[47,97,17,98]}
    );
}

test "to_bytes case 218" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%12b","windows":false,"expected":[47,97,18,98]}
    );
}

test "to_bytes case 220" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%13b","windows":false,"expected":[47,97,19,98]}
    );
}

test "to_bytes case 222" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%14b","windows":false,"expected":[47,97,20,98]}
    );
}

test "to_bytes case 224" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%15b","windows":false,"expected":[47,97,21,98]}
    );
}

test "to_bytes case 226" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%16b","windows":false,"expected":[47,97,22,98]}
    );
}

test "to_bytes case 228" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%17b","windows":false,"expected":[47,97,23,98]}
    );
}

test "to_bytes case 230" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%18b","windows":false,"expected":[47,97,24,98]}
    );
}

test "to_bytes case 232" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%19b","windows":false,"expected":[47,97,25,98]}
    );
}

test "to_bytes case 234" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1ab","windows":false,"expected":[47,97,26,98]}
    );
}

test "to_bytes case 236" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1bb","windows":false,"expected":[47,97,27,98]}
    );
}

test "to_bytes case 238" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1cb","windows":false,"expected":[47,97,28,98]}
    );
}

test "to_bytes case 240" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1db","windows":false,"expected":[47,97,29,98]}
    );
}

test "to_bytes case 242" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1eb","windows":false,"expected":[47,97,30,98]}
    );
}

test "to_bytes case 244" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%1fb","windows":false,"expected":[47,97,31,98]}
    );
}

test "to_bytes case 246" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%21b","windows":false,"expected":[47,97,33,98]}
    );
}

test "to_bytes case 248" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%22b","windows":false,"expected":[47,97,34,98]}
    );
}

test "to_bytes case 250" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%23b","windows":false,"expected":[47,97,35,98]}
    );
}

test "to_bytes case 252" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%24b","windows":false,"expected":[47,97,36,98]}
    );
}

test "to_bytes case 254" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%25b","windows":false,"expected":[47,97,37,98]}
    );
}

test "to_bytes case 256" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%26b","windows":false,"expected":[47,97,38,98]}
    );
}

test "to_bytes case 258" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%27b","windows":false,"expected":[47,97,39,98]}
    );
}

test "to_bytes case 260" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%28b","windows":false,"expected":[47,97,40,98]}
    );
}

test "to_bytes case 262" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%29b","windows":false,"expected":[47,97,41,98]}
    );
}

test "to_bytes case 264" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2ab","windows":false,"expected":[47,97,42,98]}
    );
}

test "to_bytes case 266" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2bb","windows":false,"expected":[47,97,43,98]}
    );
}

test "to_bytes case 268" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2cb","windows":false,"expected":[47,97,44,98]}
    );
}

test "to_bytes case 270" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2db","windows":false,"expected":[47,97,45,98]}
    );
}

test "to_bytes case 272" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2eb","windows":false,"expected":[47,97,46,98]}
    );
}

test "to_bytes case 274" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%2fb","windows":false,"expected":[47,97,47,98]}
    );
}

test "to_bytes case 276" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%30b","windows":false,"expected":[47,97,48,98]}
    );
}

test "to_bytes case 278" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%31b","windows":false,"expected":[47,97,49,98]}
    );
}

test "to_bytes case 280" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%32b","windows":false,"expected":[47,97,50,98]}
    );
}

test "to_bytes case 282" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%33b","windows":false,"expected":[47,97,51,98]}
    );
}

test "to_bytes case 284" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%34b","windows":false,"expected":[47,97,52,98]}
    );
}

test "to_bytes case 286" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%35b","windows":false,"expected":[47,97,53,98]}
    );
}

test "to_bytes case 288" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%36b","windows":false,"expected":[47,97,54,98]}
    );
}

test "to_bytes case 290" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%37b","windows":false,"expected":[47,97,55,98]}
    );
}

test "to_bytes case 292" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%38b","windows":false,"expected":[47,97,56,98]}
    );
}

test "to_bytes case 294" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%39b","windows":false,"expected":[47,97,57,98]}
    );
}

test "to_bytes case 296" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3ab","windows":false,"expected":[47,97,58,98]}
    );
}

test "to_bytes case 298" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3bb","windows":false,"expected":[47,97,59,98]}
    );
}

test "to_bytes case 300" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3cb","windows":false,"expected":[47,97,60,98]}
    );
}

test "to_bytes case 302" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3db","windows":false,"expected":[47,97,61,98]}
    );
}

test "to_bytes case 304" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3eb","windows":false,"expected":[47,97,62,98]}
    );
}

test "to_bytes case 306" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%3fb","windows":false,"expected":[47,97,63,98]}
    );
}

test "to_bytes case 308" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%40b","windows":false,"expected":[47,97,64,98]}
    );
}

test "to_bytes case 310" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%41b","windows":false,"expected":[47,97,65,98]}
    );
}

test "to_bytes case 312" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%42b","windows":false,"expected":[47,97,66,98]}
    );
}

test "to_bytes case 314" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%43b","windows":false,"expected":[47,97,67,98]}
    );
}

test "to_bytes case 316" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%44b","windows":false,"expected":[47,97,68,98]}
    );
}

test "to_bytes case 318" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%45b","windows":false,"expected":[47,97,69,98]}
    );
}

test "to_bytes case 320" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%46b","windows":false,"expected":[47,97,70,98]}
    );
}

test "to_bytes case 322" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%47b","windows":false,"expected":[47,97,71,98]}
    );
}

test "to_bytes case 324" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%48b","windows":false,"expected":[47,97,72,98]}
    );
}

test "to_bytes case 326" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%49b","windows":false,"expected":[47,97,73,98]}
    );
}

test "to_bytes case 328" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4ab","windows":false,"expected":[47,97,74,98]}
    );
}

test "to_bytes case 330" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4bb","windows":false,"expected":[47,97,75,98]}
    );
}

test "to_bytes case 332" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4cb","windows":false,"expected":[47,97,76,98]}
    );
}

test "to_bytes case 334" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4db","windows":false,"expected":[47,97,77,98]}
    );
}

test "to_bytes case 336" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4eb","windows":false,"expected":[47,97,78,98]}
    );
}

test "to_bytes case 338" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%4fb","windows":false,"expected":[47,97,79,98]}
    );
}

test "to_bytes case 340" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%50b","windows":false,"expected":[47,97,80,98]}
    );
}

test "to_bytes case 342" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%51b","windows":false,"expected":[47,97,81,98]}
    );
}

test "to_bytes case 344" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%52b","windows":false,"expected":[47,97,82,98]}
    );
}

test "to_bytes case 346" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%53b","windows":false,"expected":[47,97,83,98]}
    );
}

test "to_bytes case 348" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%54b","windows":false,"expected":[47,97,84,98]}
    );
}

test "to_bytes case 350" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%55b","windows":false,"expected":[47,97,85,98]}
    );
}

test "to_bytes case 352" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%56b","windows":false,"expected":[47,97,86,98]}
    );
}

test "to_bytes case 354" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%57b","windows":false,"expected":[47,97,87,98]}
    );
}

test "to_bytes case 356" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%58b","windows":false,"expected":[47,97,88,98]}
    );
}

test "to_bytes case 358" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%59b","windows":false,"expected":[47,97,89,98]}
    );
}

test "to_bytes case 360" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5ab","windows":false,"expected":[47,97,90,98]}
    );
}

test "to_bytes case 362" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5bb","windows":false,"expected":[47,97,91,98]}
    );
}

test "to_bytes case 364" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5cb","windows":false,"expected":[47,97,92,98]}
    );
}

test "to_bytes case 366" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5db","windows":false,"expected":[47,97,93,98]}
    );
}

test "to_bytes case 368" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5eb","windows":false,"expected":[47,97,94,98]}
    );
}

test "to_bytes case 370" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%5fb","windows":false,"expected":[47,97,95,98]}
    );
}

test "to_bytes case 372" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%60b","windows":false,"expected":[47,97,96,98]}
    );
}

test "to_bytes case 374" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%61b","windows":false,"expected":[47,97,97,98]}
    );
}

test "to_bytes case 376" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%62b","windows":false,"expected":[47,97,98,98]}
    );
}

test "to_bytes case 378" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%63b","windows":false,"expected":[47,97,99,98]}
    );
}

test "to_bytes case 380" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%64b","windows":false,"expected":[47,97,100,98]}
    );
}

test "to_bytes case 382" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%65b","windows":false,"expected":[47,97,101,98]}
    );
}

test "to_bytes case 384" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%66b","windows":false,"expected":[47,97,102,98]}
    );
}

test "to_bytes case 386" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%67b","windows":false,"expected":[47,97,103,98]}
    );
}

test "to_bytes case 388" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%68b","windows":false,"expected":[47,97,104,98]}
    );
}

test "to_bytes case 390" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%69b","windows":false,"expected":[47,97,105,98]}
    );
}

test "to_bytes case 392" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6ab","windows":false,"expected":[47,97,106,98]}
    );
}

test "to_bytes case 394" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6bb","windows":false,"expected":[47,97,107,98]}
    );
}

test "to_bytes case 396" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6cb","windows":false,"expected":[47,97,108,98]}
    );
}

test "to_bytes case 398" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6db","windows":false,"expected":[47,97,109,98]}
    );
}

test "to_bytes case 400" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6eb","windows":false,"expected":[47,97,110,98]}
    );
}

test "to_bytes case 402" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%6fb","windows":false,"expected":[47,97,111,98]}
    );
}

test "to_bytes case 404" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%70b","windows":false,"expected":[47,97,112,98]}
    );
}

test "to_bytes case 406" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%71b","windows":false,"expected":[47,97,113,98]}
    );
}

test "to_bytes case 408" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%72b","windows":false,"expected":[47,97,114,98]}
    );
}

test "to_bytes case 410" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%73b","windows":false,"expected":[47,97,115,98]}
    );
}

test "to_bytes case 412" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%74b","windows":false,"expected":[47,97,116,98]}
    );
}

test "to_bytes case 414" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%75b","windows":false,"expected":[47,97,117,98]}
    );
}

test "to_bytes case 416" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%76b","windows":false,"expected":[47,97,118,98]}
    );
}

test "to_bytes case 418" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%77b","windows":false,"expected":[47,97,119,98]}
    );
}

test "to_bytes case 420" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%78b","windows":false,"expected":[47,97,120,98]}
    );
}

test "to_bytes case 422" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%79b","windows":false,"expected":[47,97,121,98]}
    );
}

test "to_bytes case 424" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7ab","windows":false,"expected":[47,97,122,98]}
    );
}

test "to_bytes case 426" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7bb","windows":false,"expected":[47,97,123,98]}
    );
}

test "to_bytes case 428" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7cb","windows":false,"expected":[47,97,124,98]}
    );
}

test "to_bytes case 430" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7db","windows":false,"expected":[47,97,125,98]}
    );
}

test "to_bytes case 432" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7eb","windows":false,"expected":[47,97,126,98]}
    );
}

test "to_bytes case 434" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%7fb","windows":false,"expected":[47,97,127,98]}
    );
}

test "to_bytes case 436" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%80b","windows":false,"expected":[47,97,128,98]}
    );
}

test "to_bytes case 438" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%81b","windows":false,"expected":[47,97,129,98]}
    );
}

test "to_bytes case 440" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%82b","windows":false,"expected":[47,97,130,98]}
    );
}

test "to_bytes case 442" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%83b","windows":false,"expected":[47,97,131,98]}
    );
}

test "to_bytes case 444" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%84b","windows":false,"expected":[47,97,132,98]}
    );
}

test "to_bytes case 446" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%85b","windows":false,"expected":[47,97,133,98]}
    );
}

test "to_bytes case 448" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%86b","windows":false,"expected":[47,97,134,98]}
    );
}

test "to_bytes case 450" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%87b","windows":false,"expected":[47,97,135,98]}
    );
}

test "to_bytes case 452" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%88b","windows":false,"expected":[47,97,136,98]}
    );
}

test "to_bytes case 454" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%89b","windows":false,"expected":[47,97,137,98]}
    );
}

test "to_bytes case 456" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8ab","windows":false,"expected":[47,97,138,98]}
    );
}

test "to_bytes case 458" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8bb","windows":false,"expected":[47,97,139,98]}
    );
}

test "to_bytes case 460" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8cb","windows":false,"expected":[47,97,140,98]}
    );
}

test "to_bytes case 462" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8db","windows":false,"expected":[47,97,141,98]}
    );
}

test "to_bytes case 464" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8eb","windows":false,"expected":[47,97,142,98]}
    );
}

test "to_bytes case 466" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%8fb","windows":false,"expected":[47,97,143,98]}
    );
}

test "to_bytes case 468" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%90b","windows":false,"expected":[47,97,144,98]}
    );
}

test "to_bytes case 470" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%91b","windows":false,"expected":[47,97,145,98]}
    );
}

test "to_bytes case 472" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%92b","windows":false,"expected":[47,97,146,98]}
    );
}

test "to_bytes case 474" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%93b","windows":false,"expected":[47,97,147,98]}
    );
}

test "to_bytes case 476" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%94b","windows":false,"expected":[47,97,148,98]}
    );
}

test "to_bytes case 478" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%95b","windows":false,"expected":[47,97,149,98]}
    );
}

test "to_bytes case 480" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%96b","windows":false,"expected":[47,97,150,98]}
    );
}

test "to_bytes case 482" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%97b","windows":false,"expected":[47,97,151,98]}
    );
}

test "to_bytes case 484" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%98b","windows":false,"expected":[47,97,152,98]}
    );
}

test "to_bytes case 486" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%99b","windows":false,"expected":[47,97,153,98]}
    );
}

test "to_bytes case 488" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9ab","windows":false,"expected":[47,97,154,98]}
    );
}

test "to_bytes case 490" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9bb","windows":false,"expected":[47,97,155,98]}
    );
}

test "to_bytes case 492" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9cb","windows":false,"expected":[47,97,156,98]}
    );
}

test "to_bytes case 494" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9db","windows":false,"expected":[47,97,157,98]}
    );
}

test "to_bytes case 496" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9eb","windows":false,"expected":[47,97,158,98]}
    );
}

test "to_bytes case 498" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%9fb","windows":false,"expected":[47,97,159,98]}
    );
}

test "to_bytes case 500" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a0b","windows":false,"expected":[47,97,160,98]}
    );
}

test "to_bytes case 502" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a1b","windows":false,"expected":[47,97,161,98]}
    );
}

test "to_bytes case 504" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a2b","windows":false,"expected":[47,97,162,98]}
    );
}

test "to_bytes case 506" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a3b","windows":false,"expected":[47,97,163,98]}
    );
}

test "to_bytes case 508" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a4b","windows":false,"expected":[47,97,164,98]}
    );
}

test "to_bytes case 510" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a5b","windows":false,"expected":[47,97,165,98]}
    );
}

test "to_bytes case 512" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a6b","windows":false,"expected":[47,97,166,98]}
    );
}

test "to_bytes case 514" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a7b","windows":false,"expected":[47,97,167,98]}
    );
}

test "to_bytes case 516" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a8b","windows":false,"expected":[47,97,168,98]}
    );
}

test "to_bytes case 518" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%a9b","windows":false,"expected":[47,97,169,98]}
    );
}

test "to_bytes case 520" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%aab","windows":false,"expected":[47,97,170,98]}
    );
}

test "to_bytes case 522" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%abb","windows":false,"expected":[47,97,171,98]}
    );
}

test "to_bytes case 524" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%acb","windows":false,"expected":[47,97,172,98]}
    );
}

test "to_bytes case 526" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%adb","windows":false,"expected":[47,97,173,98]}
    );
}

test "to_bytes case 528" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%aeb","windows":false,"expected":[47,97,174,98]}
    );
}

test "to_bytes case 530" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%afb","windows":false,"expected":[47,97,175,98]}
    );
}

test "to_bytes case 532" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b0b","windows":false,"expected":[47,97,176,98]}
    );
}

test "to_bytes case 534" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b1b","windows":false,"expected":[47,97,177,98]}
    );
}

test "to_bytes case 536" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b2b","windows":false,"expected":[47,97,178,98]}
    );
}

test "to_bytes case 538" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b3b","windows":false,"expected":[47,97,179,98]}
    );
}

test "to_bytes case 540" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b4b","windows":false,"expected":[47,97,180,98]}
    );
}

test "to_bytes case 542" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b5b","windows":false,"expected":[47,97,181,98]}
    );
}

test "to_bytes case 544" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b6b","windows":false,"expected":[47,97,182,98]}
    );
}

test "to_bytes case 546" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b7b","windows":false,"expected":[47,97,183,98]}
    );
}

test "to_bytes case 548" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b8b","windows":false,"expected":[47,97,184,98]}
    );
}

test "to_bytes case 550" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%b9b","windows":false,"expected":[47,97,185,98]}
    );
}

test "to_bytes case 552" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%bab","windows":false,"expected":[47,97,186,98]}
    );
}

test "to_bytes case 554" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%bbb","windows":false,"expected":[47,97,187,98]}
    );
}

test "to_bytes case 556" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%bcb","windows":false,"expected":[47,97,188,98]}
    );
}

test "to_bytes case 558" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%bdb","windows":false,"expected":[47,97,189,98]}
    );
}

test "to_bytes case 560" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%beb","windows":false,"expected":[47,97,190,98]}
    );
}

test "to_bytes case 562" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%bfb","windows":false,"expected":[47,97,191,98]}
    );
}

test "to_bytes case 564" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c0b","windows":false,"expected":[47,97,192,98]}
    );
}

test "to_bytes case 566" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c1b","windows":false,"expected":[47,97,193,98]}
    );
}

test "to_bytes case 568" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c2b","windows":false,"expected":[47,97,194,98]}
    );
}

test "to_bytes case 570" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c3b","windows":false,"expected":[47,97,195,98]}
    );
}

test "to_bytes case 572" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c4b","windows":false,"expected":[47,97,196,98]}
    );
}

test "to_bytes case 574" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c5b","windows":false,"expected":[47,97,197,98]}
    );
}

test "to_bytes case 576" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c6b","windows":false,"expected":[47,97,198,98]}
    );
}

test "to_bytes case 578" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c7b","windows":false,"expected":[47,97,199,98]}
    );
}

test "to_bytes case 580" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c8b","windows":false,"expected":[47,97,200,98]}
    );
}

test "to_bytes case 582" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%c9b","windows":false,"expected":[47,97,201,98]}
    );
}

test "to_bytes case 584" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%cab","windows":false,"expected":[47,97,202,98]}
    );
}

test "to_bytes case 586" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%cbb","windows":false,"expected":[47,97,203,98]}
    );
}

test "to_bytes case 588" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ccb","windows":false,"expected":[47,97,204,98]}
    );
}

test "to_bytes case 590" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%cdb","windows":false,"expected":[47,97,205,98]}
    );
}

test "to_bytes case 592" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ceb","windows":false,"expected":[47,97,206,98]}
    );
}

test "to_bytes case 594" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%cfb","windows":false,"expected":[47,97,207,98]}
    );
}

test "to_bytes case 596" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d0b","windows":false,"expected":[47,97,208,98]}
    );
}

test "to_bytes case 598" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d1b","windows":false,"expected":[47,97,209,98]}
    );
}

test "to_bytes case 600" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d2b","windows":false,"expected":[47,97,210,98]}
    );
}

test "to_bytes case 602" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d3b","windows":false,"expected":[47,97,211,98]}
    );
}

test "to_bytes case 604" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d4b","windows":false,"expected":[47,97,212,98]}
    );
}

test "to_bytes case 606" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d5b","windows":false,"expected":[47,97,213,98]}
    );
}

test "to_bytes case 608" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d6b","windows":false,"expected":[47,97,214,98]}
    );
}

test "to_bytes case 610" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d7b","windows":false,"expected":[47,97,215,98]}
    );
}

test "to_bytes case 612" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d8b","windows":false,"expected":[47,97,216,98]}
    );
}

test "to_bytes case 614" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%d9b","windows":false,"expected":[47,97,217,98]}
    );
}

test "to_bytes case 616" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%dab","windows":false,"expected":[47,97,218,98]}
    );
}

test "to_bytes case 618" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%dbb","windows":false,"expected":[47,97,219,98]}
    );
}

test "to_bytes case 620" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%dcb","windows":false,"expected":[47,97,220,98]}
    );
}

test "to_bytes case 622" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ddb","windows":false,"expected":[47,97,221,98]}
    );
}

test "to_bytes case 624" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%deb","windows":false,"expected":[47,97,222,98]}
    );
}

test "to_bytes case 626" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%dfb","windows":false,"expected":[47,97,223,98]}
    );
}

test "to_bytes case 628" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e0b","windows":false,"expected":[47,97,224,98]}
    );
}

test "to_bytes case 630" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e1b","windows":false,"expected":[47,97,225,98]}
    );
}

test "to_bytes case 632" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e2b","windows":false,"expected":[47,97,226,98]}
    );
}

test "to_bytes case 634" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e3b","windows":false,"expected":[47,97,227,98]}
    );
}

test "to_bytes case 636" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e4b","windows":false,"expected":[47,97,228,98]}
    );
}

test "to_bytes case 638" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e5b","windows":false,"expected":[47,97,229,98]}
    );
}

test "to_bytes case 640" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e6b","windows":false,"expected":[47,97,230,98]}
    );
}

test "to_bytes case 642" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e7b","windows":false,"expected":[47,97,231,98]}
    );
}

test "to_bytes case 644" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e8b","windows":false,"expected":[47,97,232,98]}
    );
}

test "to_bytes case 646" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%e9b","windows":false,"expected":[47,97,233,98]}
    );
}

test "to_bytes case 648" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%eab","windows":false,"expected":[47,97,234,98]}
    );
}

test "to_bytes case 650" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ebb","windows":false,"expected":[47,97,235,98]}
    );
}

test "to_bytes case 652" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ecb","windows":false,"expected":[47,97,236,98]}
    );
}

test "to_bytes case 654" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%edb","windows":false,"expected":[47,97,237,98]}
    );
}

test "to_bytes case 656" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%eeb","windows":false,"expected":[47,97,238,98]}
    );
}

test "to_bytes case 658" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%efb","windows":false,"expected":[47,97,239,98]}
    );
}

test "to_bytes case 660" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f0b","windows":false,"expected":[47,97,240,98]}
    );
}

test "to_bytes case 662" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f1b","windows":false,"expected":[47,97,241,98]}
    );
}

test "to_bytes case 664" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f2b","windows":false,"expected":[47,97,242,98]}
    );
}

test "to_bytes case 666" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f3b","windows":false,"expected":[47,97,243,98]}
    );
}

test "to_bytes case 668" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f4b","windows":false,"expected":[47,97,244,98]}
    );
}

test "to_bytes case 670" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f5b","windows":false,"expected":[47,97,245,98]}
    );
}

test "to_bytes case 672" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f6b","windows":false,"expected":[47,97,246,98]}
    );
}

test "to_bytes case 674" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f7b","windows":false,"expected":[47,97,247,98]}
    );
}

test "to_bytes case 676" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f8b","windows":false,"expected":[47,97,248,98]}
    );
}

test "to_bytes case 678" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%f9b","windows":false,"expected":[47,97,249,98]}
    );
}

test "to_bytes case 680" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%fab","windows":false,"expected":[47,97,250,98]}
    );
}

test "to_bytes case 682" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%fbb","windows":false,"expected":[47,97,251,98]}
    );
}

test "to_bytes case 684" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%fcb","windows":false,"expected":[47,97,252,98]}
    );
}

test "to_bytes case 686" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%fdb","windows":false,"expected":[47,97,253,98]}
    );
}

test "to_bytes case 688" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%feb","windows":false,"expected":[47,97,254,98]}
    );
}

test "to_bytes case 690" {
    try fixture.check(
        \\{"operation":"to_bytes","input":"file:///a%ffb","windows":false,"expected":[47,97,255,98]}
    );
}
