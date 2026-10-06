# coding: utf-8
from pathlib import Path
import hashlib,json,re,shlex,subprocess,sys,datetime

doc=Path(__file__).resolve().parent
manifest=json.loads((doc/'输入清单.json').read_text())
mode=sys.argv[1]
record=json.loads((doc/(mode+'执行.json')).read_text())
assert record['exit_code']==0
log=(doc/(mode+'执行.log')).read_text()
paths={}
for line in log.splitlines():
    try: args=shlex.split(line.removeprefix("info(verbose): "))
    except ValueError: continue
    if not args:continue
    match=re.fullmatch(r'native-value-boundary-(borrowing|guards|allocation)',Path(args[0]).name)
    if match and '--listen=-' in args:
        assert match[1] not in paths
        paths[match[1]]=Path(args[0])
assert len(paths)==3,paths
output=[]
for name,binary in paths.items():
    if not binary.is_absolute():binary=Path(record['cwd'])/binary
    assert binary.is_file()
    argv=[str(binary),'--seed=0x26217']
    started=datetime.datetime.now(datetime.timezone.utc).isoformat()
    result=subprocess.run(argv,cwd=record['cwd'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    target=doc/(mode+'产物_'+name+'.log')
    target.write_bytes(result.stdout)
    output.append({'name':name,'binary':str(binary),'binary_sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'argv':argv,'cwd':record['cwd'],'started_at':started,'completed_at':datetime.datetime.now(datetime.timezone.utc).isoformat(),'exit_code':result.returncode,'log':target.name,'log_sha256':hashlib.sha256(result.stdout).hexdigest()})
    assert result.returncode==0,result.stdout.decode()
(doc/(mode+'产物执行.json')).write_text(json.dumps(output,ensure_ascii=False,indent=2)+'\n')
print(mode+': collected 3 actually tested binaries and their complete named-test output')
