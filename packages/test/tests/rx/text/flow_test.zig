const std = @import("std");
const rx = @import("rx");
const h = @import("flow_check.zig");

test "RX text Module rejects custom name" {
    try h.reject("<Module name='x'/>", .unknown_attribute, "name");
}

test "RX text Module rejects Pipeline" {
    try h.reject("<Module><Pipeline/></Module>", .unexpected_element, null);
}

test "RX text Call requires input" {
    try h.reject("<Module><Call fn='load'/></Module>", .missing_attribute, "in");
}

test "RX text Call requires target" {
    try h.reject("<Module><Call in={$in}/></Module>", .context, "module");
}

test "RX text Call forbids two targets" {
    try h.reject("<Module><Call fn='load' module='./load' in={$in}/></Module>", .context, "module");
}

test "RX text Call rejects absolute module" {
    try h.reject("<Module><Call module='/load' in={$in}/></Module>", .context, "module");
}

test "RX text module Call rejects setter" {
    try h.reject("<Module><Call module='./load' in={$in} setter={store.jobs}/></Module>", .context, "setter");
}

test "RX text Call rejects blank function" {
    try h.reject("<Module><Call fn=' ' in={$in}/></Module>", .context, "fn");
}

test "RX text Return requires value" {
    try h.reject("<Module><Return/></Module>", .missing_attribute, "value");
}

test "RX text Emit requires event" {
    try h.reject("<Module><Emit value={$in}/></Module>", .missing_attribute, "event");
}

test "RX text Emit requires value" {
    try h.reject("<Module><Emit event='ready'/></Module>", .missing_attribute, "value");
}

test "RX text Task requires children" {
    try h.reject("<Module><Task name='work'/></Module>", .child_count, null);
}

test "RX text Parallel requires children" {
    try h.reject("<Module><Parallel/></Module>", .child_count, null);
}

test "RX text Switch requires branches" {
    try h.reject("<Module><Switch on={$in}/></Module>", .child_count, null);
}

test "RX text Case requires body" {
    try h.reject("<Module><Switch on={$in}><Case value={x}/></Switch></Module>", .child_count, null);
}

test "RX text Default requires body" {
    try h.reject("<Module><Switch on={$in}><Default/></Switch></Module>", .child_count, null);
}

test "RX text Task rejects direct Task" {
    try h.reject("<Module><Task name='outer'><Task name='inner'><Return value={$in}/></Task></Task></Module>", .unexpected_element, null);
}

test "RX text Task rejects Store" {
    try h.reject("<Module><Task name='work'><Store from='jobs'/></Task></Module>", .unexpected_element, null);
}

test "RX text Parallel rejects Return" {
    try h.reject("<Module><Parallel><Return value={$in}/></Parallel></Module>", .unexpected_element, null);
}

test "RX text Parallel rejects Emit" {
    try h.reject("<Module><Parallel><Emit event='ready' value={$in}/></Parallel></Module>", .unexpected_element, null);
}

test "RX text Parallel rejects Switch" {
    try h.reject("<Module><Parallel><Switch on={$in}><Default><Return value={$in}/></Default></Switch></Parallel></Module>", .unexpected_element, null);
}

test "RX text Switch rejects Call" {
    try h.reject("<Module><Switch on={$in}><Call fn='load' in={$in}/></Switch></Module>", .unexpected_element, null);
}

test "RX text Module rejects direct Case" {
    try h.reject("<Module><Case value={x}><Return value={$in}/></Case></Module>", .unexpected_element, null);
}

test "RX text Switch rejects duplicate Case" {
    try h.reject("<Module><Switch on={$in}><Case value={x}><Return value={1}/></Case><Case value={x}><Return value={2}/></Case></Switch></Module>", .context, "value");
}

test "RX text Switch rejects duplicate Default" {
    try h.reject("<Module><Switch on={$in}><Default><Return value={1}/></Default><Default><Return value={2}/></Default></Switch></Module>", .context, null);
}

test "RX text Module rejects duplicate Store alias" {
    try h.reject("<Module><Store from='jobs'/><Store from='backup' as='jobs'/></Module>", .context, "as");
}

test "RX text Call rejects child" {
    try h.reject("<Module><Call fn='load' in={$in}><Return value={$in}/></Call></Module>", .child_count, null);
}

test "RX text Return rejects text" {
    try h.reject("<Module><Return value={$in}>execute()</Return></Module>", .unexpected_text, null);
}

test "RX text preserves composed flow data" {
    const source =
        \\<Module in="Input" out="Output">
        \\  <Store from="scheduler" as="jobs"/>
        \\  <Task name="validate">
        \\    <Switch on={$ctx.status}>
        \\      <Case value={blocked}><Return value={false}/></Case>
        \\      <Default><Task name="fallback"><Call fn="load" in={$in}/></Task></Default>
        \\    </Switch>
        \\  </Task>
        \\  <Parallel><Call fn="load" in={$in}/><Task name="query"><Call fn="load" in={$in}/></Task></Parallel>
        \\  <Emit event="order.created" value={$ctx.order}/>
        \\  <Call fn="advance" in={$in} setter={[store.jobs.dispatcher]}/>
        \\</Module>
    ;
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "flow.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .data);

    const data = result.value.data.module;

    try std.testing.expectEqualStrings("Input", data.attributes.in.?);
    try std.testing.expectEqualStrings("Output", data.attributes.out.?);
    try std.testing.expectEqualStrings("jobs", data.children[0].store.attributes.as.?);
    try std.testing.expectEqualStrings("$ctx.status", data.children[1].task.children[0].@"switch".attributes.on);
    try std.testing.expectEqual(@as(usize, 2), data.children[2].parallel.children.len);
    try std.testing.expectEqualStrings("order.created", data.children[3].emit.attributes.event);
    try std.testing.expectEqualStrings("[store.jobs.dispatcher]", data.children[4].call.attributes.setter.?);
}

test "RX text empty attribute reports original value position" {
    var parsed = try rx.parseXml(std.testing.allocator, "<Module>\r\n  <Call fn=' ' in={$in}/>\r\n</Module>");

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "flow.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);

    const issue = result.value.diagnostic;

    try std.testing.expectEqual(.context, issue.code);
    try std.testing.expectEqualStrings("fn", issue.attribute.?);
    try std.testing.expectEqualDeep(rx.ast.Location{ .offset = 22, .line = 2, .column = 13 }, issue.location);
}

test "RX text Call rejects removed output and args attributes" {
    try h.reject("<Module><Call fn='load' in={$in} out='ctx.value'/></Module>", .unknown_attribute, "out");
    try h.reject("<Module><Call fn='load' args={$in}/></Module>", .unknown_attribute, "args");
}

test "RX text Call rejects removed name and service attributes" {
    try h.reject("<Module><Call fn='load' in={$in} name='value'/></Module>", .unknown_attribute, "name");
    try h.reject("<Module><Call service='./load' in={$in}/></Module>", .unknown_attribute, "service");
}
