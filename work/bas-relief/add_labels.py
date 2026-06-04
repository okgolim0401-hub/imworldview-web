import os

path = r'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'

with open(path, 'r', encoding='utf-8') as f:
    html = f.read()

target = "<!-- Hover Text Label Overlay -->"

replacement = """<!-- Corner Labels -->
                <div class="absolute bottom-1 left-1.5 md:bottom-2 md:left-2 font-label-mono text-[7px] md:text-[8px] text-white/40 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    TOKTOK SHADOW
                </div>
                <div class="absolute bottom-1 right-1.5 md:bottom-2 md:right-2 font-label-mono text-[7px] md:text-[8px] text-white/20 tracking-[0.2em] z-30 pointer-events-none transition-opacity duration-300 group-hover/light:opacity-0">
                    #MERGE #JOIN
                </div>
                <!-- Hover Text Label Overlay -->"""

if html.count(target) == 16:
    html = html.replace(target, replacement)
    with open(path, 'w', encoding='utf-8') as f:
        f.write(html)
    print("Successfully injected corner labels into all 16 cards!")
else:
    print(f"Failed to inject. Target found {html.count(target)} times instead of 16.")
