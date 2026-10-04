# -*- coding: utf-8 -*-
import json
import re
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text()
summary = re.findall(r"^Build Summary: .*$", text, re.M)
counts = {}

for name in ['tests', 'pass', 'fail', 'cancelled', 'skipped', 'todo']:
    values = [int(value) for value in re.findall(r'^(?:ℹ|#) ' + name + r' (\d+)$', text, re.M)]
    counts[name] = sum(values)
    counts[name + '_reports'] = len(values)

result = {
    'build_summary': summary,
    'node_reports': counts,
    'custom_scenario_reports': re.findall(r'^.*(?:scenarios passed|checks passed).*$', text, re.M),
    'failed_commands': re.findall(r'^failed command: .*$', text, re.M),
}

print(json.dumps(result, ensure_ascii=False, indent=2))
