const fixture = @import("fixture.zig");

test "to_path case 141" {
    try fixture.check(
        \\{"operation":"to_path","input":"https://example.org/a","windows":false,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_path case 143" {
    try fixture.check(
        \\{"operation":"to_path","input":"data:text/plain,a","windows":false,"error":"ERR_INVALID_URL_SCHEME"}
    );
}

test "to_path case 145" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///","windows":false,"expected":[47]}
    );
}

test "to_path case 147" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/","windows":false,"expected":[47,67,58,47]}
    );
}

test "to_path case 149" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/dir/a","windows":false,"expected":[47,67,58,47,100,105,114,47,97]}
    );
}

test "to_path case 151" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C|/dir/a","windows":false,"expected":[47,67,58,47,100,105,114,47,97]}
    );
}

test "to_path case 153" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///c:/a?query#hash","windows":false,"expected":[47,99,58,47,97]}
    );
}

test "to_path case 155" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://localhost/C:/a","windows":false,"expected":[47,67,58,47,97]}
    );
}

test "to_path case 157" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://server/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_path case 159" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://xn--6qq79v/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_path case 161" {
    try fixture.check(
        \\{"operation":"to_path","input":"file://[::1]/share/a","windows":false,"error":"ERR_INVALID_FILE_URL_HOST"}
    );
}

test "to_path case 163" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%20b","windows":false,"expected":[47,97,32,98]}
    );
}

test "to_path case 165" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%","windows":false,"error":"URIError"}
    );
}

test "to_path case 167" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%2","windows":false,"error":"URIError"}
    );
}

test "to_path case 169" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%GG","windows":false,"error":"URIError"}
    );
}

test "to_path case 171" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/a%252Fb","windows":false,"expected":[47,67,58,47,97,37,50,70,98]}
    );
}

test "to_path case 173" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%E4%BD%A0%E5%A5%BD","windows":false,"expected":[47,67,58,47,228,189,160,229,165,189]}
    );
}

test "to_path case 175" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%C0%AF","windows":false,"error":"URIError"}
    );
}

test "to_path case 177" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%ED%A0%80","windows":false,"error":"URIError"}
    );
}

test "to_path case 179" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///C:/%F4%90%80%80","windows":false,"error":"URIError"}
    );
}

test "to_path case 181" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%00b","windows":false,"expected":[47,97,0,98]}
    );
}

test "to_path case 183" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%01b","windows":false,"expected":[47,97,1,98]}
    );
}

test "to_path case 185" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%02b","windows":false,"expected":[47,97,2,98]}
    );
}

test "to_path case 187" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%03b","windows":false,"expected":[47,97,3,98]}
    );
}

test "to_path case 189" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%04b","windows":false,"expected":[47,97,4,98]}
    );
}

test "to_path case 191" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%05b","windows":false,"expected":[47,97,5,98]}
    );
}

test "to_path case 193" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%06b","windows":false,"expected":[47,97,6,98]}
    );
}

test "to_path case 195" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%07b","windows":false,"expected":[47,97,7,98]}
    );
}

test "to_path case 197" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%08b","windows":false,"expected":[47,97,8,98]}
    );
}

test "to_path case 199" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%09b","windows":false,"expected":[47,97,9,98]}
    );
}

test "to_path case 201" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0ab","windows":false,"expected":[47,97,10,98]}
    );
}

test "to_path case 203" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0bb","windows":false,"expected":[47,97,11,98]}
    );
}

test "to_path case 205" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0cb","windows":false,"expected":[47,97,12,98]}
    );
}

test "to_path case 207" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0db","windows":false,"expected":[47,97,13,98]}
    );
}

test "to_path case 209" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0eb","windows":false,"expected":[47,97,14,98]}
    );
}

test "to_path case 211" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%0fb","windows":false,"expected":[47,97,15,98]}
    );
}

test "to_path case 213" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%10b","windows":false,"expected":[47,97,16,98]}
    );
}

test "to_path case 215" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%11b","windows":false,"expected":[47,97,17,98]}
    );
}

test "to_path case 217" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%12b","windows":false,"expected":[47,97,18,98]}
    );
}

test "to_path case 219" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%13b","windows":false,"expected":[47,97,19,98]}
    );
}

test "to_path case 221" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%14b","windows":false,"expected":[47,97,20,98]}
    );
}

test "to_path case 223" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%15b","windows":false,"expected":[47,97,21,98]}
    );
}

test "to_path case 225" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%16b","windows":false,"expected":[47,97,22,98]}
    );
}

test "to_path case 227" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%17b","windows":false,"expected":[47,97,23,98]}
    );
}

test "to_path case 229" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%18b","windows":false,"expected":[47,97,24,98]}
    );
}

test "to_path case 231" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%19b","windows":false,"expected":[47,97,25,98]}
    );
}

test "to_path case 233" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1ab","windows":false,"expected":[47,97,26,98]}
    );
}

test "to_path case 235" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1bb","windows":false,"expected":[47,97,27,98]}
    );
}

test "to_path case 237" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1cb","windows":false,"expected":[47,97,28,98]}
    );
}

test "to_path case 239" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1db","windows":false,"expected":[47,97,29,98]}
    );
}

test "to_path case 241" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1eb","windows":false,"expected":[47,97,30,98]}
    );
}

test "to_path case 243" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%1fb","windows":false,"expected":[47,97,31,98]}
    );
}

test "to_path case 245" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%21b","windows":false,"expected":[47,97,33,98]}
    );
}

test "to_path case 247" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%22b","windows":false,"expected":[47,97,34,98]}
    );
}

test "to_path case 249" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%23b","windows":false,"expected":[47,97,35,98]}
    );
}

test "to_path case 251" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%24b","windows":false,"expected":[47,97,36,98]}
    );
}

test "to_path case 253" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%25b","windows":false,"expected":[47,97,37,98]}
    );
}

test "to_path case 255" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%26b","windows":false,"expected":[47,97,38,98]}
    );
}

test "to_path case 257" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%27b","windows":false,"expected":[47,97,39,98]}
    );
}

test "to_path case 259" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%28b","windows":false,"expected":[47,97,40,98]}
    );
}

test "to_path case 261" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%29b","windows":false,"expected":[47,97,41,98]}
    );
}

test "to_path case 263" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2ab","windows":false,"expected":[47,97,42,98]}
    );
}

test "to_path case 265" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2bb","windows":false,"expected":[47,97,43,98]}
    );
}

test "to_path case 267" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2cb","windows":false,"expected":[47,97,44,98]}
    );
}

test "to_path case 269" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2db","windows":false,"expected":[47,97,45,98]}
    );
}

test "to_path case 271" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2eb","windows":false,"expected":[47,97,46,98]}
    );
}

test "to_path case 273" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%2fb","windows":false,"error":"ERR_INVALID_FILE_URL_PATH"}
    );
}

test "to_path case 275" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%30b","windows":false,"expected":[47,97,48,98]}
    );
}

test "to_path case 277" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%31b","windows":false,"expected":[47,97,49,98]}
    );
}

test "to_path case 279" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%32b","windows":false,"expected":[47,97,50,98]}
    );
}

test "to_path case 281" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%33b","windows":false,"expected":[47,97,51,98]}
    );
}

test "to_path case 283" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%34b","windows":false,"expected":[47,97,52,98]}
    );
}

test "to_path case 285" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%35b","windows":false,"expected":[47,97,53,98]}
    );
}

test "to_path case 287" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%36b","windows":false,"expected":[47,97,54,98]}
    );
}

test "to_path case 289" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%37b","windows":false,"expected":[47,97,55,98]}
    );
}

test "to_path case 291" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%38b","windows":false,"expected":[47,97,56,98]}
    );
}

test "to_path case 293" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%39b","windows":false,"expected":[47,97,57,98]}
    );
}

test "to_path case 295" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3ab","windows":false,"expected":[47,97,58,98]}
    );
}

test "to_path case 297" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3bb","windows":false,"expected":[47,97,59,98]}
    );
}

test "to_path case 299" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3cb","windows":false,"expected":[47,97,60,98]}
    );
}

test "to_path case 301" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3db","windows":false,"expected":[47,97,61,98]}
    );
}

test "to_path case 303" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3eb","windows":false,"expected":[47,97,62,98]}
    );
}

test "to_path case 305" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%3fb","windows":false,"expected":[47,97,63,98]}
    );
}

test "to_path case 307" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%40b","windows":false,"expected":[47,97,64,98]}
    );
}

test "to_path case 309" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%41b","windows":false,"expected":[47,97,65,98]}
    );
}

test "to_path case 311" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%42b","windows":false,"expected":[47,97,66,98]}
    );
}

test "to_path case 313" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%43b","windows":false,"expected":[47,97,67,98]}
    );
}

test "to_path case 315" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%44b","windows":false,"expected":[47,97,68,98]}
    );
}

test "to_path case 317" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%45b","windows":false,"expected":[47,97,69,98]}
    );
}

test "to_path case 319" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%46b","windows":false,"expected":[47,97,70,98]}
    );
}

test "to_path case 321" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%47b","windows":false,"expected":[47,97,71,98]}
    );
}

test "to_path case 323" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%48b","windows":false,"expected":[47,97,72,98]}
    );
}

test "to_path case 325" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%49b","windows":false,"expected":[47,97,73,98]}
    );
}

test "to_path case 327" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4ab","windows":false,"expected":[47,97,74,98]}
    );
}

test "to_path case 329" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4bb","windows":false,"expected":[47,97,75,98]}
    );
}

test "to_path case 331" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4cb","windows":false,"expected":[47,97,76,98]}
    );
}

test "to_path case 333" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4db","windows":false,"expected":[47,97,77,98]}
    );
}

test "to_path case 335" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4eb","windows":false,"expected":[47,97,78,98]}
    );
}

test "to_path case 337" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%4fb","windows":false,"expected":[47,97,79,98]}
    );
}

test "to_path case 339" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%50b","windows":false,"expected":[47,97,80,98]}
    );
}

test "to_path case 341" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%51b","windows":false,"expected":[47,97,81,98]}
    );
}

test "to_path case 343" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%52b","windows":false,"expected":[47,97,82,98]}
    );
}

test "to_path case 345" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%53b","windows":false,"expected":[47,97,83,98]}
    );
}

test "to_path case 347" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%54b","windows":false,"expected":[47,97,84,98]}
    );
}

test "to_path case 349" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%55b","windows":false,"expected":[47,97,85,98]}
    );
}

test "to_path case 351" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%56b","windows":false,"expected":[47,97,86,98]}
    );
}

test "to_path case 353" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%57b","windows":false,"expected":[47,97,87,98]}
    );
}

test "to_path case 355" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%58b","windows":false,"expected":[47,97,88,98]}
    );
}

test "to_path case 357" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%59b","windows":false,"expected":[47,97,89,98]}
    );
}

test "to_path case 359" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5ab","windows":false,"expected":[47,97,90,98]}
    );
}

test "to_path case 361" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5bb","windows":false,"expected":[47,97,91,98]}
    );
}

test "to_path case 363" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5cb","windows":false,"expected":[47,97,92,98]}
    );
}

test "to_path case 365" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5db","windows":false,"expected":[47,97,93,98]}
    );
}

test "to_path case 367" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5eb","windows":false,"expected":[47,97,94,98]}
    );
}

test "to_path case 369" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%5fb","windows":false,"expected":[47,97,95,98]}
    );
}

test "to_path case 371" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%60b","windows":false,"expected":[47,97,96,98]}
    );
}

test "to_path case 373" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%61b","windows":false,"expected":[47,97,97,98]}
    );
}

test "to_path case 375" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%62b","windows":false,"expected":[47,97,98,98]}
    );
}

test "to_path case 377" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%63b","windows":false,"expected":[47,97,99,98]}
    );
}

test "to_path case 379" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%64b","windows":false,"expected":[47,97,100,98]}
    );
}

test "to_path case 381" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%65b","windows":false,"expected":[47,97,101,98]}
    );
}

test "to_path case 383" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%66b","windows":false,"expected":[47,97,102,98]}
    );
}

test "to_path case 385" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%67b","windows":false,"expected":[47,97,103,98]}
    );
}

test "to_path case 387" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%68b","windows":false,"expected":[47,97,104,98]}
    );
}

test "to_path case 389" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%69b","windows":false,"expected":[47,97,105,98]}
    );
}

test "to_path case 391" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6ab","windows":false,"expected":[47,97,106,98]}
    );
}

test "to_path case 393" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6bb","windows":false,"expected":[47,97,107,98]}
    );
}

test "to_path case 395" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6cb","windows":false,"expected":[47,97,108,98]}
    );
}

test "to_path case 397" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6db","windows":false,"expected":[47,97,109,98]}
    );
}

test "to_path case 399" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6eb","windows":false,"expected":[47,97,110,98]}
    );
}

test "to_path case 401" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%6fb","windows":false,"expected":[47,97,111,98]}
    );
}

test "to_path case 403" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%70b","windows":false,"expected":[47,97,112,98]}
    );
}

test "to_path case 405" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%71b","windows":false,"expected":[47,97,113,98]}
    );
}

test "to_path case 407" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%72b","windows":false,"expected":[47,97,114,98]}
    );
}

test "to_path case 409" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%73b","windows":false,"expected":[47,97,115,98]}
    );
}

test "to_path case 411" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%74b","windows":false,"expected":[47,97,116,98]}
    );
}

test "to_path case 413" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%75b","windows":false,"expected":[47,97,117,98]}
    );
}

test "to_path case 415" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%76b","windows":false,"expected":[47,97,118,98]}
    );
}

test "to_path case 417" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%77b","windows":false,"expected":[47,97,119,98]}
    );
}

test "to_path case 419" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%78b","windows":false,"expected":[47,97,120,98]}
    );
}

test "to_path case 421" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%79b","windows":false,"expected":[47,97,121,98]}
    );
}

test "to_path case 423" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7ab","windows":false,"expected":[47,97,122,98]}
    );
}

test "to_path case 425" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7bb","windows":false,"expected":[47,97,123,98]}
    );
}

test "to_path case 427" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7cb","windows":false,"expected":[47,97,124,98]}
    );
}

test "to_path case 429" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7db","windows":false,"expected":[47,97,125,98]}
    );
}

test "to_path case 431" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7eb","windows":false,"expected":[47,97,126,98]}
    );
}

test "to_path case 433" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%7fb","windows":false,"expected":[47,97,127,98]}
    );
}

test "to_path case 435" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%80b","windows":false,"error":"URIError"}
    );
}

test "to_path case 437" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%81b","windows":false,"error":"URIError"}
    );
}

test "to_path case 439" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%82b","windows":false,"error":"URIError"}
    );
}

test "to_path case 441" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%83b","windows":false,"error":"URIError"}
    );
}

test "to_path case 443" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%84b","windows":false,"error":"URIError"}
    );
}

test "to_path case 445" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%85b","windows":false,"error":"URIError"}
    );
}

test "to_path case 447" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%86b","windows":false,"error":"URIError"}
    );
}

test "to_path case 449" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%87b","windows":false,"error":"URIError"}
    );
}

test "to_path case 451" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%88b","windows":false,"error":"URIError"}
    );
}

test "to_path case 453" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%89b","windows":false,"error":"URIError"}
    );
}

test "to_path case 455" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8ab","windows":false,"error":"URIError"}
    );
}

test "to_path case 457" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8bb","windows":false,"error":"URIError"}
    );
}

test "to_path case 459" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8cb","windows":false,"error":"URIError"}
    );
}

test "to_path case 461" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8db","windows":false,"error":"URIError"}
    );
}

test "to_path case 463" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8eb","windows":false,"error":"URIError"}
    );
}

test "to_path case 465" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%8fb","windows":false,"error":"URIError"}
    );
}

test "to_path case 467" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%90b","windows":false,"error":"URIError"}
    );
}

test "to_path case 469" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%91b","windows":false,"error":"URIError"}
    );
}

test "to_path case 471" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%92b","windows":false,"error":"URIError"}
    );
}

test "to_path case 473" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%93b","windows":false,"error":"URIError"}
    );
}

test "to_path case 475" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%94b","windows":false,"error":"URIError"}
    );
}

test "to_path case 477" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%95b","windows":false,"error":"URIError"}
    );
}

test "to_path case 479" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%96b","windows":false,"error":"URIError"}
    );
}

test "to_path case 481" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%97b","windows":false,"error":"URIError"}
    );
}

test "to_path case 483" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%98b","windows":false,"error":"URIError"}
    );
}

test "to_path case 485" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%99b","windows":false,"error":"URIError"}
    );
}

test "to_path case 487" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9ab","windows":false,"error":"URIError"}
    );
}

test "to_path case 489" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9bb","windows":false,"error":"URIError"}
    );
}

test "to_path case 491" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9cb","windows":false,"error":"URIError"}
    );
}

test "to_path case 493" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9db","windows":false,"error":"URIError"}
    );
}

test "to_path case 495" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9eb","windows":false,"error":"URIError"}
    );
}

test "to_path case 497" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%9fb","windows":false,"error":"URIError"}
    );
}

test "to_path case 499" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 501" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 503" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 505" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 507" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 509" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 511" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 513" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 515" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 517" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%a9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 519" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%aab","windows":false,"error":"URIError"}
    );
}

test "to_path case 521" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%abb","windows":false,"error":"URIError"}
    );
}

test "to_path case 523" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%acb","windows":false,"error":"URIError"}
    );
}

test "to_path case 525" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%adb","windows":false,"error":"URIError"}
    );
}

test "to_path case 527" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%aeb","windows":false,"error":"URIError"}
    );
}

test "to_path case 529" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%afb","windows":false,"error":"URIError"}
    );
}

test "to_path case 531" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 533" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 535" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 537" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 539" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 541" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 543" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 545" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 547" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 549" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%b9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 551" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%bab","windows":false,"error":"URIError"}
    );
}

test "to_path case 553" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%bbb","windows":false,"error":"URIError"}
    );
}

test "to_path case 555" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%bcb","windows":false,"error":"URIError"}
    );
}

test "to_path case 557" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%bdb","windows":false,"error":"URIError"}
    );
}

test "to_path case 559" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%beb","windows":false,"error":"URIError"}
    );
}

test "to_path case 561" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%bfb","windows":false,"error":"URIError"}
    );
}

test "to_path case 563" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 565" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 567" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 569" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 571" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 573" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 575" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 577" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 579" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 581" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%c9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 583" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%cab","windows":false,"error":"URIError"}
    );
}

test "to_path case 585" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%cbb","windows":false,"error":"URIError"}
    );
}

test "to_path case 587" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ccb","windows":false,"error":"URIError"}
    );
}

test "to_path case 589" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%cdb","windows":false,"error":"URIError"}
    );
}

test "to_path case 591" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ceb","windows":false,"error":"URIError"}
    );
}

test "to_path case 593" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%cfb","windows":false,"error":"URIError"}
    );
}

test "to_path case 595" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 597" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 599" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 601" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 603" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 605" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 607" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 609" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 611" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 613" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%d9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 615" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%dab","windows":false,"error":"URIError"}
    );
}

test "to_path case 617" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%dbb","windows":false,"error":"URIError"}
    );
}

test "to_path case 619" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%dcb","windows":false,"error":"URIError"}
    );
}

test "to_path case 621" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ddb","windows":false,"error":"URIError"}
    );
}

test "to_path case 623" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%deb","windows":false,"error":"URIError"}
    );
}

test "to_path case 625" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%dfb","windows":false,"error":"URIError"}
    );
}

test "to_path case 627" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 629" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 631" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 633" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 635" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 637" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 639" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 641" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 643" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 645" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%e9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 647" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%eab","windows":false,"error":"URIError"}
    );
}

test "to_path case 649" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ebb","windows":false,"error":"URIError"}
    );
}

test "to_path case 651" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ecb","windows":false,"error":"URIError"}
    );
}

test "to_path case 653" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%edb","windows":false,"error":"URIError"}
    );
}

test "to_path case 655" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%eeb","windows":false,"error":"URIError"}
    );
}

test "to_path case 657" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%efb","windows":false,"error":"URIError"}
    );
}

test "to_path case 659" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f0b","windows":false,"error":"URIError"}
    );
}

test "to_path case 661" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f1b","windows":false,"error":"URIError"}
    );
}

test "to_path case 663" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f2b","windows":false,"error":"URIError"}
    );
}

test "to_path case 665" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f3b","windows":false,"error":"URIError"}
    );
}

test "to_path case 667" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f4b","windows":false,"error":"URIError"}
    );
}

test "to_path case 669" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f5b","windows":false,"error":"URIError"}
    );
}

test "to_path case 671" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f6b","windows":false,"error":"URIError"}
    );
}

test "to_path case 673" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f7b","windows":false,"error":"URIError"}
    );
}

test "to_path case 675" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f8b","windows":false,"error":"URIError"}
    );
}

test "to_path case 677" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%f9b","windows":false,"error":"URIError"}
    );
}

test "to_path case 679" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%fab","windows":false,"error":"URIError"}
    );
}

test "to_path case 681" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%fbb","windows":false,"error":"URIError"}
    );
}

test "to_path case 683" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%fcb","windows":false,"error":"URIError"}
    );
}

test "to_path case 685" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%fdb","windows":false,"error":"URIError"}
    );
}

test "to_path case 687" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%feb","windows":false,"error":"URIError"}
    );
}

test "to_path case 689" {
    try fixture.check(
        \\{"operation":"to_path","input":"file:///a%ffb","windows":false,"error":"URIError"}
    );
}
