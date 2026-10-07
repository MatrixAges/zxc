# coding: utf-8
from pathlib import Path
import hashlib
import json
import re
import subprocess

doc = Path(__file__).resolve().parent
manifest = json.loads((doc / '输入清单.json').read_text())
positive = json.loads((doc / 'Debug产物清单.json').read_text())
records = []

for method, selected, result, calls in [('every', 'original_predicate', 'false', 3), ('some', 'original_single', 'true', 2)]:
    original = next(row for row in positive['executions'] if row['kind'] == method + '-source')
    argv = original['metadata']['argv']
    program = Path(next(arg.removeprefix('-Mprogram=') for arg in argv if arg.startswith('-Mprogram=')))
    source = program.read_text()
    callback = re.search(r'if \(\(\((try .+)\) != (?:true|false)\)\) \{', source)
    assert callback is not None
    statement = re.search(r'(?m)^([ ]+)(break :predicate_\d+ (?:true|false);)', source)
    assert statement is not None
    changed = source[:statement.start()] + statement.group(1) + '_ = ' + callback.group(1) + ';\n' + source[statement.start():]

    directory = Path('/tmp/zxc-predicate-reviews-negative-' + manifest['source_commit'][:8]) / method
    directory.mkdir(parents=True, exist_ok=True)
    mutated = directory / 'program.zig'
    mutated.write_text(changed)
    test_source = Path(original['metadata']['source'])
    tests = test_source.read_text()
    line = '    const result = program.execute(&arena, storage[1..][0..args.input.len]);'
    assert tests.count(line) == 1
    tests = tests.replace(line, line + '\n    std.debug.print("observed result={any}, calls={d}\\n", .{ try result, host.calls });')
    root = directory / 'cases.zig'
    root.write_text(tests)
    binary = directory / 'negative-predicate-tests'
    compile_argv = [original['node_argv'][2], *[('-Mprogram=' + str(mutated)) if arg.startswith('-Mprogram=') else ('-Mroot=' + str(root)) if arg.startswith('-Mroot=') else arg for arg in argv],
                    '--test-filter', selected, '--test-no-exec', '-femit-bin=' + str(binary)]
    compiled = subprocess.run(compile_argv, cwd=directory, capture_output=True)
    compile_log = doc / (method + '负向构建.txt')
    compile_log.write_bytes(compiled.stdout + compiled.stderr)
    assert compiled.returncode == 0, compile_log
    executed = subprocess.run([str(binary)], cwd=directory, capture_output=True)
    output = executed.stdout + executed.stderr
    log = doc / (method + '负向执行.txt')
    log.write_bytes(output)
    assert executed.returncode != 0
    assert ('observed result=' + result + ', calls=' + str(calls)) in output.decode()
    assert 'expected ' + str(calls - 1) + ', found ' + str(calls) in output.decode()
    assert '0 passed; 0 skipped; 1 failed.' in output.decode()
    for file in [mutated, root]:
        (doc / (method + '负向' + file.name + '.txt')).write_bytes(file.read_bytes())
    records.append({'method': method, 'case': selected, 'source_commit': manifest['source_commit'],
                    'original_program_sha256': hashlib.sha256(program.read_bytes()).hexdigest(),
                    'mutated_program_sha256': hashlib.sha256(mutated.read_bytes()).hexdigest(),
                    'mutated_program': method + '负向program.zig.txt', 'compile_argv': compile_argv,
                    'compile_status': compiled.returncode, 'argv': [str(binary)], 'status': executed.returncode,
                    'binary_sha256': hashlib.sha256(binary.read_bytes()).hexdigest(), 'log': log.name,
                    'log_sha256': hashlib.sha256(output).hexdigest(), 'observed_result': result,
                    'observed_calls': calls, 'expected_calls': calls - 1})

(doc / '负向观察结果.json').write_text(json.dumps(records, ensure_ascii=False, indent=2) + '\n')
print('Two intentional mutants rejected: unchanged bool results with one extra decisive callback')
