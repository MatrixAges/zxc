from expand_ast import expand_expression, expand_type, name


def expand_body(source, state, root=None):
    tree = state["tree"]

    def expr(index):
        return expand_expression(source, state["expressions"], state["types"], index, block)

    def chain(node, table):
        result = []
        head = node["head"]

        for _ in range(node["count"]):
            assert head
            edge = tree[table][head - 1]
            result.append(edge)
            head = edge["previous"]

        assert not head
        return result[::-1]

    def block(index):
        node = tree["blocks"][index]
        return {"span": node["span"], "statements": [statement(edge["value"]) for edge in chain(node, "items")]}

    def statement(index):
        node = tree["statements"][index]
        kind = node["kind"]
        first, second, third = (node[key] for key in ["first", "second", "third"])

        if kind == "Constant":
            annotation = expand_type(source, state["types"], node["annotation"] - 1) if node["annotation"] else None
            value = {"constant": {"name": name(source, node["name"]), "annotation": annotation, "value": expr(first)}}
        elif kind == "Destructure":
            value = {"destructure": {"names": [name(source, edge["span"]) for edge in chain(node, "names")], "value": expr(first)}}
        elif kind == "Result":
            value = {"result": expr(first - 1) if first else None}
        elif kind == "Branch":
            value = {"branch": {"condition": expr(first), "yes": block(second), "no": block(third - 1) if third else None}}
        elif kind == "Switch":
            cases = [{"value": expr(edge["value"] - 1) if edge["value"] else None, "body": block(edge["body"]), "span": edge["span"]} for edge in chain(node, "cases")]
            value = {"switch_stmt": {"subject": expr(first), "cases": cases}}
        elif kind == "StoreSet":
            value = {"store_set": {"target": expr(first), "value": expr(second)}}
        elif kind == "StateUpdate":
            value = {"state_update": {"target": expr(first), "value": expr(second), "operator": node["operator"].lower() if node["operator"] != "None" else None}}
        elif kind == "Evaluate":
            value = {"evaluate": expr(first)}
        else:
            raise ValueError(kind)

        return {"span": node["span"], "value": value}

    return block(state["result"] if root is None else root)
