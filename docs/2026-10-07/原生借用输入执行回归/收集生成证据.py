# coding: utf-8
from pathlib import Path
import json,hashlib,re,shlex,shutil,sys

doc=Path(__file__).resolve().parent
manifest=json.loads((doc/'输入清单.json').read_text())
mode=sys.argv[1]
record=json.loads((doc/(mode+'执行.json')).read_text())
assert record['exit_code']==0 and record['inputs']==manifest['paths']
commands=[]
for line in (doc/(mode+'执行.log')).read_text().splitlines():
    if not line.startswith('info(verbose): '):continue
    args=shlex.split(line.removeprefix('info(verbose): '))
    if args and args[0]=='node' and args[1].endswith('borrowed_runtime/run_test.ts'):
        commands.append(args)
assert len(commands)==8
source=Path(manifest['worktree'])/'packages/test/tests/native/borrowed_runtime/root.zig'
expected=re.findall(r'^test "([^"\n]+)"',source.read_text(),re.M)
assert len(expected)==8
output=[]
for args in commands:
    directory=Path(args[3])
    label=directory.name
    assert label in {kind+'-'+route for kind in ['string','list','nested','optional'] for route in ['source','library']}
    metadata=json.loads((directory/'execution.json').read_text())
    assert metadata['status']==0 and metadata['signal'] is None and metadata['error'] is None
    actual=re.findall(r'^\d+/\d+ root\.test\.(.*?)\.\.\.OK$',(directory/'execution.log').read_text(),re.M)
    assert actual==expected,(label,actual)
    assert metadata['argv'][0]=='test' and '--test-no-exec' not in metadata['argv']
    target=doc/'生成产物'/manifest['source_commit'][:8]/mode/label
    target.mkdir(parents=True,exist_ok=True)
    paths=[]
    for path in sorted(directory.iterdir()):
        if not path.is_file() or path.suffix not in ['.zig','.json','.log']:continue
        saved=target/(path.name+".txt")
        shutil.copyfile(path,saved)
        paths.append({'actual_path':str(path),'saved_path':str(saved.relative_to(doc)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    generated={p['actual_path'] for p in paths if p['actual_path'].endswith('.zig')}
    for argument in metadata['argv']:
        if not argument.startswith('-M'):continue
        file=argument.split('=',1)[1]
        if str(Path(file).parent)==str(directory):assert file in generated,file
    text='\n'.join(Path(p['actual_path']).read_text() for p in paths if p['actual_path'].endswith('.zig'))
    assert text.count('.callValue(')>=2 and text.count('.callBuffered(')>=1,label
    output.append({'mode':args[8],'route':label.rsplit('-',1)[1],'directory':str(directory),'node_argv':args,'zig':args[2],'test_names':actual,'test_count':len(actual),'value_calls':text.count('.callValue('),'buffered_calls':text.count('.callBuffered('),'files':paths})
assert len({(item['mode'],item['route']) for item in output})==8
(doc/(mode+'生成清单.json')).write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
print(mode+': archived 8 generated routes, 64 actually executed named Zig tests, and complete execution metadata')
