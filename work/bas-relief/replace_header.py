import re

with open('C:\\Users\\PC\\Desktop\\IMWV\\WEB\\StellarRestomod\\index.html', 'r', encoding='utf-8') as f:
    stellar = f.read()

nav_match = re.search(r'(?s)<!-- TopNavBar -->\s*<nav.*?</nav>', stellar)
if not nav_match:
    print("Could not find TopNavBar in StellarRestomod")
    exit(1)

nav_html = nav_match.group(0)

with open('C:\\Users\\PC\\Desktop\\IMWV\\WEB\\TokTokShadow_Bas_Relief\\index.html', 'r', encoding='utf-8') as f:
    toktok = f.read()

# TokTok currently has <header ... id="main-header"> ... </header>
# Let's replace the entire <header> block with the <nav> block
new_toktok = re.sub(r'(?s)<header.*?id="main-header">.*?</header>', nav_html, toktok)

with open('C:\\Users\\PC\\Desktop\\IMWV\\WEB\\TokTokShadow_Bas_Relief\\index.html', 'w', encoding='utf-8') as f:
    f.write(new_toktok)

print("Header replaced successfully.")
