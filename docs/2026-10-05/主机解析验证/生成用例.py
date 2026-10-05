from pathlib import Path
import json
import subprocess
import sys

folder=Path(__file__).resolve().parent
root=folder.parents[2]
target=root/'packages/test/tests/standard/resources/url/host/parser'
valid=[
 ('EXAMPLE.COM','example.com','EXAMPLE.COM'),
 ('example%2Ecom','example.com','example%2Ecom'),
 ('faß.example','xn--fa-hia.example','fa%C3%9F.example'),
 ('0','0.0.0.0','0'),('%30','0.0.0.0','%30'),('0x','0.0.0.0','0x'),
 ('0xffffffff','255.255.255.255','0xffffffff'),('127.1','127.0.0.1','127.1'),
 ('0177.0.0.1','127.0.0.1','0177.0.0.1'),('１２７。１','127.0.0.1','%EF%BC%91%EF%BC%92%EF%BC%97%E3%80%82%EF%BC%91'),
 ('[0:0::1]','[::1]','[::1]'),('[::ffff:192.0.2.128]','[::ffff:c000:280]','[::ffff:c000:280]'),
 ('BÜCHER.example','xn--bcher-kva.example','B%C3%9CCHER.example'),
 ('b%C3%BCcher.example','xn--bcher-kva.example','b%C3%BCcher.example'),
 ('e\u0301.example','xn--9ca.example','e%CC%81.example'),
 ('xn--','xn--','xn--'),('XN--8I7CAA','xn--8i7caa','XN--8I7CAA'),
 ('xn--.example','xn--.example','xn--.example'),('a..b','a..b','a..b'),
 ('-A_.EXAMPLE','-a_.example','-A_.EXAMPLE'),('example.','example.','example.')
]
errors=[
 ('empty special','',False,'InvalidHost'),
 ('invalid octal','09',False,'InvalidIpv4'),('numeric suffix with domain','example.255',False,'InvalidIpv4'),
 ('IPv4 too large','4294967296',False,'InvalidIpv4'),('decoded numeric suffix','example.%32%35%35',False,'InvalidIpv4'),
 ('literal percent','%',False,'InvalidHost'),('invalid escape','%GG',False,'InvalidHost'),
 ('double encoded forbidden','a%2523b',False,'InvalidHost'),('decoded bracket','%5B::1%5D',False,'InvalidHost'),
 ('mapped forbidden','a／b',False,'InvalidHost'),('decoded invalid UTF8','a%FFb',False,'InvalidDomain'),
 ('ASCII ACE with Unicode sibling','xn--.é',False,'InvalidDomain'),
 ('missing IPv6 close','[::1',False,'InvalidHost'),('IPv6 port included','[::1]:80',False,'InvalidHost'),
 ('bad IPv6','[1::2::3]',False,'InvalidIpv6'),('escaped IPv6 digit','[::%31]',False,'InvalidIpv6'),
 ('IPv6 zone','[fe80::1%eth0]',False,'InvalidIpv6'),
 ('opaque bad IPv6','[1::2::3]',True,'InvalidIpv6'),('opaque missing close','[::1',True,'InvalidHost'),
 ('opaque IPv6 zone','[fe80::1%eth0]',True,'InvalidIpv6')
]
extras=[('opaque empty','',True,''),('opaque invalid octal','09',True,'09'),('opaque invalid escape','%GG',True,'%GG'),('opaque NUL escape','a%00b',True,'a%00b'),('opaque numeric suffix','example.255',True,'example.255')]

def quote(value):
 return '"'+''.join({'"':'\\"','\\':'\\\\','\n':'\\n','\t':'\\t','\r':'\\r'}.get(c,f'\\x{ord(c):02x}' if ord(c)<32 or ord(c)==127 else c) for c in value)+'"'

cases=[(f'{index} '+('opaque' if mode else 'special'),input,mode,expected) for index,(input,special,opaque) in enumerate(valid) for mode,expected in [(False,special),(True,opaque)]]+extras
source='pub const valid = [_]struct { input: []const u8, is_opaque: bool, expected: []const u8 }{\n'
for _,input,opaque,expected in cases:
 source+=f'    .{{ .input = {quote(input)}, .is_opaque = {str(opaque).lower()}, .expected = {quote(expected)} }},\n'
source+='};\n\npub const invalid = [_]struct { input: []const u8, is_opaque: bool, expected: anyerror }{\n'
for _,input,opaque,error in errors:
 source+=f'    .{{ .input = {quote(input)}, .is_opaque = {str(opaque).lower()}, .expected = error.{error} }},\n'
source+='};\n'
tests='const std = @import("std");\nconst fixture = @import("fixture.zig");\nconst cases = @import("cases.zig");\n'
for group,entries in [('valid',cases),('invalid',errors)]:
 for index,entry in enumerate(entries):
  fn='success' if group=='valid' else 'rejection'
  tests+=f'\ntest {quote("host "+group+" "+entry[0])} {{\n    const entry = cases.{group}[{index}];\n\n    try fixture.{fn}(std.testing.allocator, entry.input, entry.is_opaque, entry.expected);\n}}\n'
for name,content in [('cases.zig',source),('examples_test.zig',tests)]:
 formatted=subprocess.run(['zig','fmt','--stdin'],input=content,text=True,capture_output=True,check=True).stdout
 if '--check' in sys.argv: assert (target/name).read_text()==formatted,name
 else:(target/name).write_text(formatted)
if '--check' not in sys.argv:
 (folder/'显式案例.json').write_text(json.dumps({'valid':len(cases),'invalid':len(errors)},indent=2)+'\n')
print('Explicit host cases:',len(cases)+len(errors))
