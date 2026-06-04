import sys

try:
    with open('app.js', 'r', encoding='utf-8-sig') as f:
        lines = f.readlines()
    for i, line in enumerate(lines):
        non_ascii = [(j, char, ord(char)) for j, char in enumerate(line) if ord(char) > 127]
        if non_ascii:
            print(f"Line {i+1}: {line.strip()}")
            print(f"  Non-ASCII: {non_ascii}")
except Exception as e:
    print("Error:", e)
