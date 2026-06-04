import re

text = open('app_v2.js', encoding='utf-8').read()
matches = re.findall(r'(?m)^\s*(const|let)\s+(\w+)\s*=', text)
names = [m[1] for m in matches]
duplicates = set([x for x in names if names.count(x) > 1])

print('Duplicates:', duplicates)
