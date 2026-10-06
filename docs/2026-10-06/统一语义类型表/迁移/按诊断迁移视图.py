from pathlib import Path
import json
import re
import sys

root = Path(__file__).resolve().parents[4]
log = Path(sys.argv[1]).read_text().splitlines()
changes = {}
records = []
seen = set()


def matching(text, start, left, right):
    depth = 1

    for index in range(start + 1, len(text)):
        if text[index] == left:
            depth += 1
        elif text[index] == right:
            depth -= 1

            if depth == 0:
                return index

    raise ValueError('unbalanced delimiter')


for line_index, diagnostic in enumerate(log):
    match = re.match(r'(packages/[^:]+):(\d+):(\d+): error: (.*)', diagnostic)

    if not match or 'type_table.' not in match[4]:
        continue

    relative, row, column, message = match.groups()
    key = (relative, row, column, message)

    if key in seen:
        continue

    seen.add(key)
    path = root / relative
    source = path.read_text()
    lines = source.splitlines(keepends=True)
    row_index = int(row) - 1
    source_line = lines[row_index].rstrip('\n')

    if line_index + 1 >= len(log) or source_line != log[line_index + 1]:
        continue

    offset = sum(map(len, lines[:row_index]))
    edits = changes.setdefault(relative, [])
    column_index = int(column) - 1

    if "no field named 'len'" in message and source_line[column_index:column_index + 3] == 'len':
        edits.append((offset + column_index, offset + column_index + 3, 'count()'))
    elif "function named 'appendSlice'" in message:
        position = source_line.index('appendSlice')
        edits.append((offset + position, offset + position + 11, 'appendDelta'))
    elif 'does not support indexing' in message:
        found = False

        for target in re.finditer(r'\b[A-Za-z_]\w*(?:\.\w+|\([^()\n]*\))*\s*(?=\[)', source_line):
            opening = target.end()
            closing = matching(source_line, opening, '[', ']')

            if not target.start() <= column_index <= closing:
                continue

            content = source_line[opening + 1:closing]

            if '..' in content:
                continue

            edits.append((offset + target.start(), offset + closing + 1, target.group().rstrip() + '.at(' + content + ')'))
            found = True
            break

        if not found:
            continue
    elif 'is not indexable and not a range' in message:
        loop = re.search(r'\bfor\s*\(', source_line)

        if loop is None:
            continue

        opening = source_line.index('(', loop.start())
        closing = matching(source_line, opening, '(', ')')
        operands = [value.strip() for value in source_line[opening + 1:closing].split(',')]
        captures = re.match(r'\s*\|([^|]+)\|\s*', source_line[closing + 1:])

        if captures is None:
            continue

        names = [name.strip() for name in captures[1].split(',')]
        operand_index = 0
        cursor = opening + 1

        for index, operand in enumerate(operands):
            start = source_line.index(operand, cursor)
            end = start + len(operand)

            if start <= column_index <= end:
                operand_index = index
                break

            cursor = end
        else:
            continue

        value = names[operand_index]

        if value.startswith('*'):
            continue

        target = operands[operand_index]
        length = '.count()' if "'type_table.root'" in message else '.len'
        index_name = 'view_index'

        while re.search(r'\b' + index_name + r'\b', source):
            index_name += '_next'

        operands[operand_index] = '0..' + target + length
        names[operand_index] = '_' if value == '_' else index_name
        header = 'for (' + ', '.join(operands) + ') |' + ', '.join(names) + '|'
        body_start = closing + 1 + captures.end()
        indent = re.match(r'\s*', source_line).group()
        binding = '' if value == '_' else '\n' + indent + '    const ' + value + ' = ' + target + '.at(' + index_name + ');\n'

        if source_line[body_start:body_start + 1] == '{':
            edits.append((offset + loop.start(), offset + body_start + 1, header + ' {' + binding))
        elif source_line.rstrip().endswith(';'):
            body = source_line[body_start:].strip()
            replacement = header + ' {' + binding + '\n' + indent + '    ' + body + '\n' + indent + '}'
            edits.append((offset + loop.start(), offset + len(source_line), replacement))
        else:
            continue
    else:
        continue

    records.append({'文件': relative, '行': int(row), '诊断': message})

for relative, edits in changes.items():
    path = root / relative
    source = path.read_text()
    previous = len(source) + 1

    for start, end, replacement in sorted(set(edits), reverse=True):
        if end > previous:
            continue

        source = source[:start] + replacement + source[end:]
        previous = start

    path.write_text(source)

report = Path(sys.argv[1]).stem + '.json'
Path(__file__).with_name(report).write_text(json.dumps(records, ensure_ascii=False, indent=4) + '\n')
print(f'Applied {len(records)} diagnosed view edits')
