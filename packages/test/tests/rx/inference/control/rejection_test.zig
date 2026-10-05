const h = @import("../check.zig");

test "RX control rejects nonvoid incomplete bool path" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={true}><Return value={1}/></Case></Switch></Module>", .code = "return_path" });
}

test "RX control rejects terminating Task followed by Return" {
    try h.run(.{ .source = "<Module><Task name='finish'><Return value={1}/></Task><Return value={2}/></Module>", .code = "return_path" });
}

test "RX control rejects terminating Default Switch followed by Return" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={true}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch><Return value={3}/></Module>", .code = "return_path" });
}

test "RX control rejects exhaustive bool followed by Return" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={true}><Return value={1}/></Case><Case value={false}><Return value={2}/></Case></Switch><Return value={3}/></Module>", .code = "return_path" });
}

test "RX control rejects conflicting branch output types" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={true}><Return value={1}/></Case><Default><Return value={\"text\"}/></Default></Switch></Module>", .code = "type_mismatch" });
}

test "RX control rejects floating Switch subject" {
    try h.run(.{ .source = "<Module><Switch on={1.5}><Case value={1.5}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Module>", .code = "type_mismatch" });
}

test "RX control rejects arithmetic Case label" {
    try h.run(.{ .source = "<Module><Switch on={2}><Case value={1 + 1}><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Module>", .code = "type_mismatch" });
}

test "RX control rejects unsigned subject negative zero label" {
    try h.run(.{ .source = "<Module><Switch on={0}><Case value={0}><Return value={1}/></Case><Case value={-0}><Return value={2}/></Case><Default><Return value={3}/></Default></Switch></Module>", .code = "type_mismatch" });
}

test "RX control rejects unselected missing module" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={false}><Call module='./missing.rx' in={1}/><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Module>", .code = "context" });
}

test "RX control rejects unselected self module" {
    try h.run(.{ .source = "<Module><Switch on={true}><Case value={false}><Call module='./main.rx' in={1}/><Return value={1}/></Case><Default><Return value={2}/></Default></Switch></Module>", .code = "context" });
}

test "RX control rejects signed positive and negative zero duplicate labels" {
    try h.run(.{ .source = "<Module><Switch on={-1}><Case value={0}><Return value={1}/></Case><Case value={-0}><Return value={2}/></Case><Default><Return value={3}/></Default></Switch></Module>", .code = "name" });
}
