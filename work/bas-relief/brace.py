content = open(app.js, r, encoding=utf-8).readlines()
stack = []
for i, line in enumerate(content):
    for char in line:
        if char == {: stack.append(i+1)
        elif char == }: 
            if stack: stack.pop()
print(Unmatched open braces at lines:, stack)
