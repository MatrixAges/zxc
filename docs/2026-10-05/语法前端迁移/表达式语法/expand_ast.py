def name(source, span):
    return {"text": source[span["start"]:span["end"]].decode(), "span": span}


def expand_type(source, tree, index):
    node = tree["nodes"][index]
    kind = node["kind"]

    if kind == "Named":
        return {"named": name(source, node["name"])}

    if kind == "Optional" or kind == "List":
        return {kind.lower(): expand_type(source, tree, node["child"])}

    if kind == "Application":
        return {"application": {"name": name(source, node["name"]), "argument": expand_type(source, tree, node["child"])}}

    table = tree["fields"] if kind == "Object" else tree["items"]
    head = node["head"]
    values = []

    for _ in range(node["count"]):
        assert head != 0
        edge = table[head - 1]
        value = expand_type(source, tree, edge["value"])
        values.append({"name": name(source, edge["name"]), "value": value} if kind == "Object" else value)
        head = edge["previous"]

    assert head == 0
    values.reverse()
    return {kind.lower(): values}



def expand_expression(source, tree, types, index, block=None):
    node = tree["nodes"][index]
    kind = node["kind"]

    def expr(child):
        return expand_expression(source, tree, types, child, block)

    def text(span):
        return source[span["start"]:span["end"]].decode()

    def chain(table):
        head = node["head"]
        values = []

        for _ in range(node["count"]):
            assert head != 0
            edge = tree[table][head - 1]
            values.append(edge)
            head = edge["previous"]

        assert head == 0
        return list(reversed(values))

    if kind in ("Number", "String"):
        value = {kind.lower(): text(node["name"])}
    elif kind == "Boolean":
        value = {"boolean": node["flag"]}
    elif kind == "Null":
        value = {"null_value": {}}
    elif kind == "Identifier":
        value = {"identifier": name(source, node["name"])}
    elif kind == "Field":
        value = {"field": {"target": expr(node["first"]), "name": name(source, node["name"])}}
    elif kind == "Index":
        value = {"index": {"target": expr(node["first"]), "index": expr(node["second"])}}
    elif kind == "List":
        value = {"list": [expr(edge["value"]) for edge in chain("items")]}
    elif kind == "Call":
        value = {"call": {"callee": expr(node["first"]), "arguments": [expr(edge["value"]) for edge in chain("items")], "type_argument": expand_type(source, types, node["type_argument"] - 1) if node["type_argument"] else None}}
    elif kind == "Lambda":
        value = {"lambda": {"parameters": [name(source, edge["name"]) for edge in chain("parameters")], "body": expr(node["first"])}}
    elif kind == "StateBlock":
        if block is None:
            raise ValueError("StateBlock requires a block table")

        value = {"state_block": block(node["first"])}
    elif kind == "Template":
        value = {"template": [{"expression": expr(edge["value"])} if edge["expression"] else {"text": text(edge["span"])} for edge in chain("parts")]}
    elif kind == "Unary":
        value = {"unary": {"operator": "negate" if node["flag"] else "not", "operand": expr(node["first"])}}
    elif kind == "Binary":
        operators = {"And": "logical_and", "Or": "logical_or", "NotEqual": "not_equal", "LessEqual": "less_equal", "GreaterEqual": "greater_equal"}
        value = {"binary": {"operator": operators.get(node["operator"], node["operator"].lower()), "left": expr(node["first"]), "right": expr(node["second"])}}
    elif kind == "Conditional":
        value = {"conditional": {"condition": expr(node["first"]), "yes": expr(node["second"]), "no": expr(node["third"])}}
    elif kind == "Match":
        value = {"match_expr": {"subject": expr(node["first"] - 1) if node["first"] else None, "arms": [{"condition": expr(edge["condition"]), "result": expr(edge["result"])} for edge in chain("arms")], "fallback": expr(node["second"])}}
    elif kind == "Object":
        value = {"object": [{"name": {"text": "", "span": edge["name"]} if edge["spread"] else name(source, edge["name"]), "value": expr(edge["value"]), "spread": edge["spread"]} for edge in chain("fields")]}
    else:
        raise ValueError(kind)

    return {"span": node["span"], "depth": node["depth"], "value": value}
