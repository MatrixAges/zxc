import json, pathlib, shutil, struct, subprocess, tempfile
repo=pathlib.Path('/Users/xiewendao/Documents/MatrixAges/zxc')
root=pathlib.Path(tempfile.mkdtemp(prefix='zxc-listen-probe-'))
original=json.loads((repo/'.zxc/build/c63a712789021ac9a4090fd0dcdddcd554cf89fa9c85cb11560f3de3e927855a/command.json').read_text())
args=[]
for arg in original:
    if arg.startswith('-femit-bin='): continue
    elif arg.startswith('-femit-asm='): continue
    elif arg.startswith('-M') and '=' in arg:
        key, name=arg.split('=',1); source=pathlib.Path(name)
        if not source.is_absolute(): source=repo/source
        target=root/(key[2:]+'.zig'); shutil.copyfile(source,target); args.append(key+'='+str(target))
    else: args.append(arg)
args += ['--cache-dir',str(root/'cache'),'--listen=-']
(root/'args.json').write_text(json.dumps(args,ensure_ascii=False,indent=2))
(root/'repo.txt').write_text(str(repo))
print(root,flush=True)
def run(label):
    p=subprocess.run(args,input=struct.pack('<II',1,0)+struct.pack('<II',0,0),capture_output=True,cwd=root,timeout=120)
    (root/(label+'.bin')).write_bytes(p.stdout); (root/(label+'.stderr')).write_bytes(p.stderr)
    pos=0; messages=[]
    while pos+8<=len(p.stdout):
        tag,n=struct.unpack_from('<II',p.stdout,pos); pos+=8; body=p.stdout[pos:pos+n]; pos+=n
        row={'tag':tag,'size':n}
        if tag==0: row['version']=body.decode(errors='replace')
        if tag==2: row['cache_hit']=bool(body[0]&1)
        if tag==6: row['inputs']=[{'prefix':v[0]-1,'path':v[1:].decode(errors='replace')} for v in body.split(b'\0') if v]
        if tag==1: row['error_bundle_head']=body[:8].hex()
        messages.append(row)
    result={'label':label,'exit':p.returncode,'messages':messages,'stderr':p.stderr.decode(errors='replace')}
    (root/(label+'.json')).write_text(json.dumps(result,ensure_ascii=False,indent=2)); print(json.dumps(result,ensure_ascii=False),flush=True)
run('cold')
run('warm')
