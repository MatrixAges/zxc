from pathlib import Path
import json
import re

root = Path(__file__).resolve().parents[4]
changed = []


def mask(source):
    pattern = r'//[^\n]*|"(?:\\.|[^"\\])*"|\x27(?:\\.|[^\x27\\])*\x27'
    return re.sub(pattern, lambda match: re.sub(r'[^\n]', ' ', match.group()), source)


def close(text, start, left, right):
    depth = 1

    for index in range(start + 1, len(text)):
        if text[index] == left:
            depth += 1
        elif text[index] == right:
            depth -= 1

            if depth == 0:
                return index

    raise ValueError(f'Unbalanced {left} at {start}')


for package in ['core', 'compiler', 'genz', 'napi']:
    for path in (root / 'packages' / package / 'src').rglob('*.zig'):
        source = path.read_text()
        source = re.sub(r'(ir\.TypeTable\s*=\s*)&\.\{\}', r'\1.{}', source)
        masked = mask(source)
        scopes = [(0, len(source), ['program.types', 'self.program.types'])]
        fields = re.findall(r'^\s*(\w+): ir\.TypeTable\b', masked, re.M)
        scopes.append((0, len(source), ['self.' + name for name in fields]))

        for function in re.finditer(r'\bfn\s+\w+\s*\(', masked):
            opening = masked.index('(', function.start())
            end_parameters = close(masked, opening, '(', ')')
            names = re.findall(r'\b(\w+): ir\.TypeTable\b', masked[opening:end_parameters])

            if not names:
                continue

            start = masked.index('{', end_parameters)
            end = close(masked, start, '{', '}')
            scopes.append((start, end, names))

        edits = {}

        for start, end, names in scopes:
            for name in names:
                target = r'(?<![\w.])' + re.escape(name)

                for match in re.finditer(target + r'\.len\b', masked[start:end]):
                    offset = start + match.start()
                    edits[(offset, start + match.end())] = name + '.count()'

                for match in re.finditer(target + r'\[', masked[start:end]):
                    offset = start + match.start()
                    opening = start + match.end() - 1
                    closing = close(masked, opening, '[', ']')
                    content = source[opening + 1:closing]

                    if '..' not in content:
                        edits[(offset, closing + 1)] = name + '.at(' + content + ')'
                    elif content.startswith('0..'):
                        edits[(offset, closing + 1)] = name + '.prefix(' + content[3:] + ')'

                pattern = r'for\s*\(\s*' + re.escape(name) + r'\s*(,\s*0\.\.)?\s*\)\s*\|\s*(\w+)\s*(?:,\s*(\w+)\s*)?\|\s*\{'

                for match in re.finditer(pattern, masked[start:end]):
                    offset = start + match.start()
                    stop = start + match.end()
                    value = match.group(2)
                    index = match.group(3)

                    if index is None:
                        index = 'table_index'

                        while re.search(r'\b' + index + r'\b', masked):
                            index += '_next'

                    line = source.rfind('\n', 0, offset) + 1
                    indentation = re.match(r'\s*', source[line:offset]).group()
                    declaration = '' if value == '_' else '\n' + indentation + '    const ' + value + ' = ' + name + '.at(' + index + ');\n'
                    edits[(offset, stop)] = 'for (0..' + name + '.count()) |' + index + '| {' + declaration

        previous = len(source) + 1

        for (start, end), replacement in sorted(edits.items(), reverse=True):
            if end > previous:
                continue

            source = source[:start] + replacement + source[end:]
            previous = start

        if source != path.read_text():
            path.write_text(source)
            changed.append(str(path.relative_to(root)))

Path(__file__).with_name('读取迁移清单.json').write_text(json.dumps(changed, ensure_ascii=False, indent=4) + '\n')
print(f'Migrated {len(changed)} read sites files')
