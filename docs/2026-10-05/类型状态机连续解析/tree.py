def expand(source, tree, index):
    assert 0 <= index < len(tree["nodes"])
    node = tree["nodes"][index]
    kind = node["kind"]

    def name(span):
        assert 0 <= span["start"] <= span["end"] <= len(source)
        return {"text": source[span["start"]:span["end"]].decode(), "span": span}

    if kind == "Named":
        return {"named": name(node["name"])}

    if kind in ("Optional", "List", "Application"):
        assert node["child"] < index
        child = expand(source, tree, node["child"])
        if kind == "Application":
            return {"application": {"name": name(node["name"]), "argument": child}}
        return {kind.lower(): child}

    assert kind in ("Object", "Tuple")
    edges = tree["fields"] if kind == "Object" else tree["items"]
    head = node["head"]
    values = []

    for _ in range(node["count"]):
        assert 0 < head <= len(edges)
        edge = edges[head - 1]
        assert edge["previous"] < head
        assert edge["value"] < index
        value = expand(source, tree, edge["value"])
        values.append({"name": name(edge["name"]), "value": value} if kind == "Object" else value)
        head = edge["previous"]

    assert head == 0
    return {kind.lower(): list(reversed(values))}

