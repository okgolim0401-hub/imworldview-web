import re

with open('C:\\Users\\PC\\Desktop\\IMWV\\WEB\\TokTokShadow_Bas_Relief\\index.html', 'r', encoding='utf-8', errors='replace') as f:
    html = f.read()

# Fix OVERVIEW 01
ko_01 = "<TokTok Shadow>의 후속작으로, 16명의 디자이너가 설계한 개별 조명기구의 조형 언어를 해체하여 하나의 부조(Bas-relief)로 구현한 작품입니다. 본래 공간을 밝히고 빛을 발산하던 기능적 오브제들은 그 본연의 효용성을 거세당한 채, 오직 형태와 구조만을 남긴 채 재조립되었습니다."
html = re.sub(r'(<p class="[^"]*mobile-ko-text[^"]*">\s*)&lt;TokTok Shadow&gt;[^\n]*\n[^\n]*\n[^\n]*(\s*</p>)', rf'\1{ko_01}\2', html, count=1)

# Fix MATERIALITY 02
ko_02 = "<TokTok Shadow>의 핵심 정체성인 SLS 나일론 3D 프린팅 기법을 이어받아 개별 오브제의 디테일한 조형을 구현했습니다. 이와 동시에 대형 스케일이 요구하는 거대한 매스(Mass)를 확보하고자 가공된 폼(Foam) 소재를 베이스로 결합하였습니다. 이러한 고정밀 3D 프린트 파트와 거대 매스 구조의 융합을 통해, 부조 특유의 묵직한 부피감과 섬세한 질감을 표현했습니다."
html = re.sub(r'(<p class="[^"]*mobile-ko-text[^"]*">\s*)&lt;TokTok Shadow&gt;[^\n]*\n[^\n]*\n[^\n]*(\s*</p>)', rf'\1{ko_02}\2', html, count=1)
en_02 = "Inheriting the SLS nylon 3D printing technique—the core identity of &lt;TokTok Shadow&gt;—we realized the detailed forms of individual objects. Simultaneously, to secure the massive three-dimensional volume required by the large scale, machined foam material was integrated as a base. Through this structural fusion of high-precision 3D printed parts and the substantial mass, we expressed the heavy sense of volume and delicate textures characteristic of bas-relief."
html = re.sub(r'(<p class="[^"]*mobile-en-text[^"]*">\s*)Inheriting the SLS nylon 3D printing technique[^\n]*\n[^\n]*\n[^\n]*\n[^\n]*(\s*</p>)', rf'\1{en_02}\2', html, count=1)

# Fix PRODUCTION LOG 03
ko_03 = "프로덕션 로그에 글은, 조형물 조립, CNC 가공, 도색, 배선 작업 및 최종 인스톨레이션 구축까지 주요 제작 공정과정을 모니터링 체계로 재구성하여 물리적 질량으로 치환되는 과정을 타임랩스로 보여주고 있다. &lt;TOKTOK SHADOW : BAS-RELIEF&gt;는 GIAF 2024(경남아트페어)에서 첫 선을 보였다."
html = re.sub(r'(<p class="[^"]*mobile-ko-text[^"]*">\s*).?조형\?\?\?.*?GIAF 2024.*?\n[^\n]*(\s*</p>)', rf'\1{ko_03}\2', html, count=1, flags=re.DOTALL)
en_03 = "The production log reorganizes the main manufacturing processes—from sculpture assembly, CNC machining, painting, wiring, to the final installation—into a monitoring system, showcasing the timelapse of its translation into physical mass. &lt;TOKTOK SHADOW : BAS-RELIEF&gt; debuted at GIAF 2024 (Gyeongnam Art Fair)."
html = re.sub(r'(<p class="[^"]*mobile-en-text[^"]*">\s*)This log documents the primary fabrication processes.*?\n.*?\n[^\n]*(\s*</p>)', rf'\1{en_03}\2', html, count=1, flags=re.DOTALL)

# Fix the grid structure
html = re.sub(r'(<img alt="PRODUCTION LOG \d+" class="w-full h-auto block" src="Bas_test_0[4-9]\.png"/>\s*)', r'\1</div>', html)

with open('C:\\Users\\PC\\Desktop\\IMWV\\WEB\\TokTokShadow_Bas_Relief\\index.html', 'w', encoding='utf-8') as f:
    f.write(html)
print("Regex replace complete.")
