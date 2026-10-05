import re


def value_end(text, start):
    quote = text[start]

    if quote in "\"'`":
        index = start + 1

        while index < len(text):
            if text[index] == "\\":
                index += 2
            elif text[index] == quote:
                return index + 1
            else:
                index += 1

        return len(text)

    if quote == "{":
        depth = 1
        index = start + 1

        while index < len(text) and depth:
            if text.startswith("/*", index):
                end = text.find("*/", index + 2)
                index = len(text) if end < 0 else end + 2
            elif text.startswith("//", index):
                end = text.find("\n", index + 2)
                index = len(text) if end < 0 else end
            elif text[index] in "\"'`":
                index = value_end(text, index)
            else:
                depth += (text[index] == "{") - (text[index] == "}")
                index += 1

        return index

    match = re.match(r"[^\s>]+", text[start:])

    return start + len(match.group()) if match else start


def tags(text):
    index = 0

    while index < len(text):
        start = text.find("<", index)

        if start < 0:
            return

        if text.startswith("<!--", start):
            end = text.find("-->", start + 4)
            index = len(text) if end < 0 else end + 3
            continue

        match = re.match(r"</?([A-Za-z][\w.-]*)\b", text[start:])

        if not match:
            index = start + 1
            continue

        cursor = start + match.end()
        attributes = []

        while cursor < len(text) and text[cursor] != ">":
            attr = re.match(r"\s+([A-Za-z_$][\w.$:-]*)\s*=\s*", text[cursor:])

            if not attr:
                cursor += 1
                continue

            attr_start = cursor
            key_start = cursor + attr.start(1)
            key_end = cursor + attr.end(1)
            val_start = cursor + attr.end()
            val_end = value_end(text, val_start)
            attributes.append({
                "key": attr.group(1), "start": attr_start,
                "key_start": key_start, "key_end": key_end,
                "value_start": val_start, "value_end": val_end,
                "raw": text[val_start:val_end],
            })
            cursor = val_end

        index = min(cursor + 1, len(text))
        yield {"name": match.group(1), "start": start, "end": index, "attrs": attributes}


def expression(text, bindings):
    keys = [key for key, value in bindings.items() if key != value]

    if not keys:
        return text

    pattern = re.compile(r"(?<![A-Za-z0-9_$.])(" + "|".join(re.escape(key) for key in sorted(keys, key=len, reverse=True)) + r")(?![A-Za-z0-9_$])")
    output = []
    index = 0

    while index < len(text):
        if text[index] in "\"'":
            end = value_end(text, index)
            output.append(text[index:end])
            index = end
        elif text[index] == "`":
            output.append("`")
            index += 1

            while index < len(text):
                if text[index] == "\\":
                    output.append(text[index:index + 2])
                    index += 2
                elif text.startswith("${", index):
                    end = value_end(text, index + 1)
                    output.append("${" + expression(text[index + 2:end - 1], bindings) + "}")
                    index = end
                elif text[index] == "`":
                    output.append("`")
                    index += 1
                    break
                else:
                    output.append(text[index])
                    index += 1
        else:
            end = index

            while end < len(text) and text[end] not in "\"'`":
                end += 1

            def reference(match):
                before = text[:index + match.start()].rstrip()
                after = text[index + match.end():].lstrip()

                if after.startswith(":") and before.endswith(("{", ",")):
                    return match.group(1)

                if after.startswith("=>"):
                    return match.group(1)

                return bindings[match.group(1)]

            output.append(pattern.sub(reference, text[index:end]))
            index = end

    return "".join(output)


def quoted(text, zig=False):
    output = ['"']

    for char in text:
        if char == '"':
            output.append('\\"')
        elif char == "\\":
            output.append("\\\\")
        elif char == "\n":
            output.append("\\n")
        elif char == "\r":
            output.append("\\r")
        elif char == "\t":
            output.append("\\t")
        elif ord(char) < 32:
            output.append(f"\\x{ord(char):02x}" if zig else f"\\u{ord(char):04x}")
        else:
            output.append(char)

    output.append('"')

    return "".join(output)
