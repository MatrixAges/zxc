const fixture = @import("fixture.zig");

test "module-in-string" {
    try fixture.check(
        \\{"source":"<Module in=\"Input\"/>","path":"flow.rx"}
    );
}

test "module-in-expression" {
    try fixture.check(
        \\{"source":"<Module in={Input}/>","path":"flow.rx","attribute":"in","offset":12}
    );
}

test "module-out-string" {
    try fixture.check(
        \\{"source":"<Module out=\"Output\"/>","path":"flow.rx"}
    );
}

test "module-out-expression" {
    try fixture.check(
        \\{"source":"<Module out={Output}/>","path":"flow.rx","attribute":"out","offset":13}
    );
}

test "import-string" {
    try fixture.check(
        \\{"source":"<Module><Import from=\"worker\"/></Module>","path":"flow.rx"}
    );
}

test "import-expression" {
    try fixture.check(
        \\{"source":"<Module><Import from={worker}/></Module>","path":"flow.rx","attribute":"from","offset":22}
    );
}

test "call-fn-string" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"text\"/></Module>","path":"flow.rx"}
    );
}

test "call-fn-expression" {
    try fixture.check(
        \\{"source":"<Module><Call fn={echo} in=\"text\"/></Module>","path":"flow.rx","attribute":"fn","offset":18}
    );
}

test "call-service-string-rejected" {
    try fixture.check(
        \\{"source":"<Module><Call service=\"worker\" in=\"text\"/></Module>","path":"flow.rx","attribute":"service","code":"unknown_attribute","offset":14}
    );
}

test "call-service-expression-rejected" {
    try fixture.check(
        \\{"source":"<Module><Call service={worker} in=\"text\"/></Module>","path":"flow.rx","attribute":"service","offset":14,"code":"unknown_attribute"}
    );
}

test "call-module-string" {
    try fixture.check(
        \\{"source":"<Module><Call module=\"dep/worker\"/></Module>","path":"flow.rx"}
    );
}

test "call-module-expression" {
    try fixture.check(
        \\{"source":"<Module><Call module={dep/worker}/></Module>","path":"flow.rx","attribute":"module","offset":22}
    );
}

test "call-out-string-rejected" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"text\" out=\"ctx.value\"/></Module>","path":"flow.rx","attribute":"out","code":"unknown_attribute","offset":34}
    );
}

test "call-out-expression-rejected" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"text\" out={ctx.value}/></Module>","path":"flow.rx","attribute":"out","offset":34,"code":"unknown_attribute"}
    );
}

test "task-name-string" {
    try fixture.check(
        \\{"source":"<Module><Task name=\"work\"><Return value=\"text\"/></Task></Module>","path":"flow.rx"}
    );
}

test "task-name-expression" {
    try fixture.check(
        \\{"source":"<Module><Task name={work}><Return value=\"text\"/></Task></Module>","path":"flow.rx","attribute":"name","offset":20}
    );
}

test "task-out-string-rejected" {
    try fixture.check(
        \\{"source":"<Module><Parallel><Task name=\"work\" out=\"ctx.value\"><Call fn=\"echo\" in=\"text\"/></Task></Parallel></Module>","path":"flow.rx","attribute":"out","offset":41}
    );
}

test "task-out-expression-schema" {
    try fixture.check(
        \\{"source":"<Module><Parallel><Task name=\"work\" out={$ctx.echo}><Call fn=\"echo\" in=\"text\"/></Task></Parallel></Module>","path":"flow.rx"}
    );
}

test "emit-event-string" {
    try fixture.check(
        \\{"source":"<Module><Emit event=\"ready\" value=\"text\"/></Module>","path":"flow.rx"}
    );
}

test "emit-event-expression" {
    try fixture.check(
        \\{"source":"<Module><Emit event={ready} value=\"text\"/></Module>","path":"flow.rx","attribute":"event","offset":21}
    );
}

test "store-from-string" {
    try fixture.check(
        \\{"source":"<Module><Store from=\"state\"/></Module>","path":"flow.rx"}
    );
}

test "store-from-expression" {
    try fixture.check(
        \\{"source":"<Module><Store from={state}/></Module>","path":"flow.rx","attribute":"from","offset":21}
    );
}

test "store-as-string" {
    try fixture.check(
        \\{"source":"<Module><Store from=\"state\" as=\"jobs\"/></Module>","path":"flow.rx"}
    );
}

test "store-as-expression" {
    try fixture.check(
        \\{"source":"<Module><Store from=\"state\" as={jobs}/></Module>","path":"flow.rx","attribute":"as","offset":32}
    );
}

test "gateway-name-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"/>","path":"flow.gateway.rx"}
    );
}

test "gateway-name-expression" {
    try fixture.check(
        \\{"source":"<Gateway name={web}/>","path":"flow.gateway.rx","attribute":"name","offset":15}
    );
}

test "gateway-protocol-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" protocol=\"http\"/>","path":"flow.gateway.rx"}
    );
}

test "gateway-protocol-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" protocol={http}/>","path":"flow.gateway.rx","attribute":"protocol","offset":30}
    );
}

test "gateway-listen-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" listen=\"127.0.0.1:8080\"/>","path":"flow.gateway.rx"}
    );
}

test "gateway-listen-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" listen={127.0.0.1:8080}/>","path":"flow.gateway.rx","attribute":"listen","offset":28}
    );
}

test "group-prefix-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Group prefix=\"/api\"><Route path=\"/\" service=\"worker\"/></Group></Gateway>","path":"flow.gateway.rx"}
    );
}

test "group-prefix-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Group prefix={/api}><Route path=\"/\" service=\"worker\"/></Group></Gateway>","path":"flow.gateway.rx","attribute":"prefix","offset":35}
    );
}

test "route-path-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path=\"/a\" service=\"worker\"/></Gateway>","path":"flow.gateway.rx"}
    );
}

test "route-path-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path={/a} service=\"worker\"/></Gateway>","path":"flow.gateway.rx","attribute":"path","offset":33}
    );
}

test "route-service-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path=\"/\" service=\"worker\"/></Gateway>","path":"flow.gateway.rx"}
    );
}

test "route-service-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path=\"/\" service={worker}/></Gateway>","path":"flow.gateway.rx","attribute":"service","offset":45}
    );
}

test "route-method-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path=\"/\" service=\"worker\" method=\"POST\"/></Gateway>","path":"flow.gateway.rx"}
    );
}

test "route-method-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\"><Route path=\"/\" service=\"worker\" method={POST}/></Gateway>","path":"flow.gateway.rx","attribute":"method","offset":61}
    );
}

test "store-name-string" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "store-name-expression" {
    try fixture.check(
        \\{"source":"<Store name={jobs} version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx","attribute":"name","offset":13}
    );
}

test "object-name-string" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "object-name-expression" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name={state}><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx","attribute":"name","offset":45}
    );
}

test "field-name-string" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "field-name-expression" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name={value} type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx","attribute":"name","offset":65}
    );
}

test "field-type-string" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "field-type-expression" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type={string} value=\"\"/></Object></Store>","path":"flow.store.rx","attribute":"type","offset":78}
    );
}

test "setter-string" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"text\" setter=\"[store.jobs.state]\"/></Module>","path":"flow.rx","attribute":"setter","offset":42}
    );
}

test "setter-expression" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"text\" setter={[store.jobs.state]}/></Module>","path":"flow.rx"}
    );
}

test "version-string" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version=\"1\"><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx","attribute":"version","offset":28}
    );
}

test "version-expression" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "header-limit-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" max_header_bytes=\"8192\"/>","path":"flow.gateway.rx","attribute":"max_header_bytes","offset":38}
    );
}

test "header-limit-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" max_header_bytes={8192}/>","path":"flow.gateway.rx"}
    );
}

test "body-limit-string" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" max_body_bytes=\"1024\"/>","path":"flow.gateway.rx","attribute":"max_body_bytes","offset":36}
    );
}

test "body-limit-expression" {
    try fixture.check(
        \\{"source":"<Gateway name=\"web\" max_body_bytes={1024}/>","path":"flow.gateway.rx"}
    );
}

test "call-in-54" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"literal\"/></Module>","path":"flow.rx"}
    );
}

test "call-in-55" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in=\"\"/></Module>","path":"flow.rx"}
    );
}

test "call-in-56" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in={$in}/></Module>","path":"flow.rx"}
    );
}

test "call-in-57" {
    try fixture.check(
        \\{"source":"<Module><Call fn=\"echo\" in={{value: 1}}/></Module>","path":"flow.rx"}
    );
}

test "return-58" {
    try fixture.check(
        \\{"source":"<Module><Return value=\"literal\"/></Module>","path":"flow.rx"}
    );
}

test "return-59" {
    try fixture.check(
        \\{"source":"<Module><Return value=\"\"/></Module>","path":"flow.rx"}
    );
}

test "return-60" {
    try fixture.check(
        \\{"source":"<Module><Return value={$in}/></Module>","path":"flow.rx"}
    );
}

test "return-61" {
    try fixture.check(
        \\{"source":"<Module><Return value={{value: 1}}/></Module>","path":"flow.rx"}
    );
}

test "switch-62" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"literal\"><Case value=\"a\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "switch-63" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"\"><Case value=\"a\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "switch-64" {
    try fixture.check(
        \\{"source":"<Module><Switch on={$in}><Case value=\"a\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "switch-65" {
    try fixture.check(
        \\{"source":"<Module><Switch on={{value: 1}}><Case value=\"a\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "case-66" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"a\"><Case value=\"literal\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "case-67" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"a\"><Case value=\"\"><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "case-68" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"a\"><Case value={$in}><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "case-69" {
    try fixture.check(
        \\{"source":"<Module><Switch on=\"a\"><Case value={{value: 1}}><Return value=\"ok\"/></Case></Switch></Module>","path":"flow.rx"}
    );
}

test "emit-value-70" {
    try fixture.check(
        \\{"source":"<Module><Emit event=\"ready\" value=\"literal\"/></Module>","path":"flow.rx"}
    );
}

test "emit-value-71" {
    try fixture.check(
        \\{"source":"<Module><Emit event=\"ready\" value=\"\"/></Module>","path":"flow.rx"}
    );
}

test "emit-value-72" {
    try fixture.check(
        \\{"source":"<Module><Emit event=\"ready\" value={$in}/></Module>","path":"flow.rx"}
    );
}

test "emit-value-73" {
    try fixture.check(
        \\{"source":"<Module><Emit event=\"ready\" value={{value: 1}}/></Module>","path":"flow.rx"}
    );
}

test "field-value-74" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"literal\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "field-value-75" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value=\"\"/></Object></Store>","path":"flow.store.rx"}
    );
}

test "field-value-76" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value={$in}/></Object></Store>","path":"flow.store.rx"}
    );
}

test "field-value-77" {
    try fixture.check(
        \\{"source":"<Store name=\"jobs\" version={1}><Object name=\"state\"><Field name=\"value\" type=\"string\" value={{value: 1}}/></Object></Store>","path":"flow.store.rx"}
    );
}
