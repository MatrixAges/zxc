import json,pathlib,struct,subprocess
root=pathlib.Path('/var/folders/lf/4g9rspms3hq7smqmfx_vfpc80000gn/T/zxc-listen-probe-o_mlxmlu')
args=json.loads((root/'persistent-args.json').read_text())
def run(label):
    p=subprocess.run(args,input=struct.pack('<II',1,0)+struct.pack('<II',0,0),capture_output=True,cwd=root,timeout=120)
    (root/(label+'.bin')).write_bytes(p.stdout);(root/(label+'.stderr')).write_bytes(p.stderr)
    pos=0;messages=[]
    while pos+8<=len(p.stdout):
        tag,n=struct.unpack_from('<II',p.stdout,pos);pos+=8;body=p.stdout[pos:pos+n];pos+=n
        row={'tag':tag,'size':n}
        if tag==0:row['version']=body.decode(errors='replace')
        if tag==2:row['cache_hit']=bool(body[0]&1);row['emit_digest']=body[1:].hex()
        if tag==6:row['inputs']=[{'prefix':v[0]-1,'path':v[1:].decode(errors='replace')} for v in body.split(b'\0') if v]
        if tag==1:row['error_bundle_head']=body[:8].hex();row['error_text']=body[8:].decode(errors='replace') if n>8 else ''
        messages.append(row)
    result={'label':label,'exit':p.returncode,'messages':messages,'stderr':p.stderr.decode(errors='replace')}
    (root/(label+'.json')).write_text(json.dumps(result,ensure_ascii=False,indent=2))
    print(json.dumps({'label':label,'exit':p.returncode,'tags':[m['tag'] for m in messages],'hits':[m['cache_hit'] for m in messages if m['tag']==2],'inputs':[len(m['inputs']) for m in messages if m['tag']==6],'headers':[v for m in messages if m['tag']==6 for v in m['inputs'] if v['path'].endswith('.h')],'errors':[m['error_bundle_head'] for m in messages if m['tag']==1],'stderr':result['stderr']},ensure_ascii=False),flush=True)
run('persistent-newprocess-restored')
