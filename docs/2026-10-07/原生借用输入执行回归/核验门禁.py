# coding: utf-8
from pathlib import Path
import hashlib,json,re,subprocess,shlex

doc=Path(__file__).resolve().parent
root=doc.parents[2]
manifest=json.loads((doc/'输入清单.json').read_text())
worktree=Path(manifest['worktree'])
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=worktree).decode().strip()==manifest['source_commit']
for row in manifest['paths']:
    for base in [root,worktree]:assert hashlib.sha256((base/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
    draft=doc/'草稿'/row['path'].removeprefix('packages/test/')
    assert hashlib.sha256(draft.read_bytes()).hexdigest()==row['sha256']
for row in json.loads((doc/'原有修改清单.json').read_text()):assert hashlib.sha256((root/row['path']).read_bytes()).hexdigest()==row['sha256'],row['path']
expected=re.findall(r'^test "([^"\n]+)"',(root/'packages/test/tests/native/borrowed_runtime/root.zig').read_text(),re.M)
assert len(expected)==8
sets={}
for mode in ['Debug','ReleaseSafe']:
    record=json.loads((doc/(mode+'执行.json')).read_text())
    raw=(doc/(mode+'执行.log')).read_bytes()
    assert record['exit_code']==0 and record['inputs']==manifest['paths'] and record['source_commit']==manifest['source_commit']
    assert hashlib.sha256(raw).hexdigest()==record['log_sha256']
    log=raw.decode()
    assert '38/38 steps succeeded' in log
    assert log.count('All 8 tests passed.')==8
    actual_commands=[]
    for line in log.splitlines():
        if not line.startswith('info(verbose): '):continue
        args=shlex.split(line.removeprefix('info(verbose): '))
        if args[0]=='node' and args[1].endswith('borrowed_runtime/run_test.ts'):actual_commands.append(args)
    items=json.loads((doc/(mode+'生成清单.json')).read_text())
    assert len(items)==8 and len(actual_commands)==8
    assert {tuple(item['node_argv']) for item in items}=={tuple(args) for args in actual_commands}
    assert {(item['mode'],item['route']) for item in items}=={(kind,route) for kind in ['string','list','nested','optional'] for route in ['source','library']}
    assert sum(item['test_count'] for item in items)==64
    collected={}
    for item in items:
        assert item['test_names']==expected and item['value_calls']>=2 and item['buffered_calls']>=1
        files={Path(row['actual_path']).name:row for row in item['files']}
        for row in item['files']:
            assert hashlib.sha256(Path(row['actual_path']).read_bytes()).hexdigest()==row['sha256']
            assert hashlib.sha256((doc/row['saved_path']).read_bytes()).hexdigest()==row['sha256']
        metadata=json.loads((doc/files['execution.json']['saved_path']).read_text())
        assert metadata['status']==0 and metadata['signal'] is None and metadata['error'] is None
        assert metadata['argv'][0]=='test' and '--test-no-exec' not in metadata['argv']
        assert metadata['native_identity'] is None if item['route']=='source' else metadata['native_identity'] is not None
        text=(doc/files['execution.log']['saved_path']).read_text()
        assert re.findall(r'^\d+/\d+ root\.test\.(.*?)\.\.\.OK$',text,re.M)==expected
        for arg in metadata['argv']:
            if not arg.startswith('-M'):continue
            path=Path(arg.split('=',1)[1])
            if path.parent==Path(item['directory']):assert path.name in files,path
        collected[(item['mode'],item['route'])]={name:row['sha256'] for name,row in files.items() if name.endswith('.zig')}
    sets[mode]=collected
assert sets['Debug']==sets['ReleaseSafe'],'Generated Zig must agree across optimizer modes'
for path in doc.rglob('*.md'):assert len(path.read_text().splitlines())<1000
print('Verified: 64 actual Zig checks per optimization mode, 16 generated routes with exact source SHAs, exercised callValue/callBuffered, unchanged foreign files')
