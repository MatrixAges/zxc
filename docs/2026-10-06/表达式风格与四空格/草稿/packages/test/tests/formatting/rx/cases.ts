type Case = { name: string; file: string; source: string; expected?: string }

const cases: Array<Case> = [
    {
        name: 'same shape compacts adjacent calls',
        file: 'module.rx',
        source: '<Module>\n  <Call fn="a" in="$in" out="ctx.a" />\n\n\n  <Call fn="b" in="$in" out="ctx.b" />\n</Module>\n',
        expected:
            '<Module>\n    <Call fn="a" in="$in" out="ctx.a" />\n    <Call fn="b" in="$in" out="ctx.b" />\n</Module>\n'
    },
    {
        name: 'different tags separate',
        file: 'module.rx',
        source: '<Module>\n  <Call fn="missing" />\n  <Return value="$in" />\n</Module>\n',
        expected: '<Module>\n    <Call fn="missing" />\n\n    <Return value="$in" />\n</Module>\n'
    },
    {
        name: 'different attribute names separate',
        file: 'module.rx',
        source: '<Module>\n <Call fn="a" />\n <Call service="a" />\n</Module>',
        expected: '<Module>\n    <Call fn="a" />\n\n    <Call service="a" />\n</Module>'
    },
    {
        name: 'attribute order is preserved and part of shape',
        file: 'module.rx',
        source: '<Module>\n <Call fn="a" in="$in" />\n <Call in="$in" fn="b" />\n</Module>',
        expected: '<Module>\n    <Call fn="a" in="$in" />\n\n    <Call in="$in" fn="b" />\n</Module>'
    },
    {
        name: 'nested multiline blocks separate and trim edges',
        file: 'module.rx',
        source: '<Module>\n\n <Task>\n\n  <Call fn="a" />\n\n </Task>\n <Task>\n  <Call fn="b" />\n </Task>\n\n</Module>\n',
        expected:
            '<Module>\n    <Task>\n        <Call fn="a" />\n    </Task>\n\n    <Task>\n        <Call fn="b" />\n    </Task>\n</Module>\n'
    },
    {
        name: 'same physical line remains unchanged',
        file: 'module.rx',
        source: '<Module><Call fn="a"/><Return value="$in"/></Module>'
    },
    {
        name: 'standalone comment stays with following group',
        file: 'module.rx',
        source: '<Module>\n <Call fn="a" />\n <!-- 后一组 > 不改变 -->\n <Return value="$in" />\n</Module>\n',
        expected:
            '<Module>\n    <Call fn="a" />\n\n    <!-- 后一组 > 不改变 -->\n    <Return value="$in" />\n</Module>\n'
    },
    {
        name: 'trailing comment stays with previous group',
        file: 'module.rx',
        source: '<Module>\n <Call fn="a" /> <!-- keep -->\n <Return value="$in" />\n</Module>\n',
        expected: '<Module>\n    <Call fn="a" /> <!-- keep -->\n\n    <Return value="$in" />\n</Module>\n'
    },
    {
        name: 'quotes entities and angle brackets remain verbatim',
        file: 'module.rx',
        source: '<Unknown>\n <A value=\'a > b &amp; c " /&gt;\' />\n <B value="&quot;文本&quot; &lt;x&gt;" />\n</Unknown>\n',
        expected:
            '<Unknown>\n    <A value=\'a > b &amp; c " /&gt;\' />\n\n    <B value="&quot;文本&quot; &lt;x&gt;" />\n</Unknown>\n'
    },
    {
        name: 'CDATA retains tags and internal blank lines',
        file: 'module.rx',
        source: '<Module>\n <![CDATA[<Call>\n\n  keep > & raw\n</Call>]]>\n\n <Return value="$in" />\n</Module>\n'
    },
    {
        name: 'mixed text retains parent gaps',
        file: 'module.rx',
        source: '<Unknown>before\n\n <A />\n\n middle\n <B />\n\n after</Unknown>\n'
    },
    {
        name: 'multiline attribute names use four space indentation',
        file: 'module.rx',
        source: '<Module>\n <Call\n   fn="a"\n   in="$in" />\n <Call fn="b" in="$in" />\n</Module>\n',
        expected:
            '<Module>\n    <Call\n        fn="a"\n        in="$in" />\n\n    <Call fn="b" in="$in" />\n</Module>\n'
    },
    {
        name: 'empty paired root trims interior blank lines',
        file: 'module.rx',
        source: '<Module>\n\n\n</Module>\n',
        expected: '<Module>\n</Module>\n'
    },
    {
        name: 'self closing root is stable',
        file: 'module.rx',
        source: '<Module />\n'
    },
    {
        name: 'Store suffix does not trigger orchestration build',
        file: 'state.store.rx',
        source: '<Store version="1">\n <Object name="counter">\n  <Field name="value" type="u64" value="0" />\n\n </Object>\n <Object name="settings">\n  <Field name="enabled" type="bool" value="true" />\n </Object>\n</Store>\n',
        expected:
            '<Store version="1">\n    <Object name="counter">\n        <Field name="value" type="u64" value="0" />\n    </Object>\n\n    <Object name="settings">\n        <Field name="enabled" type="bool" value="true" />\n    </Object>\n</Store>\n'
    },
    {
        name: 'Gateway suffix and nonexistent services remain formatable',
        file: 'http.gateway.rx',
        source: '<Gateway>\n\n <Route method="GET" path="/a" service="missing" />\n\n <Route method="POST" path="/b" service="absent" />\n</Gateway>\n',
        expected:
            '<Gateway>\n    <Route method="GET" path="/a" service="missing" />\n    <Route method="POST" path="/b" service="absent" />\n</Gateway>\n'
    }
]

export default cases
