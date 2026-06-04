$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
# Read original corrupted file
$content = Get-Content $path -Raw

# 1. Fix the broken grid structure.
# Replace the first matched image with image + closing </div> to restore the missing closing tags.
$content = [regex]::Replace($content, '(<img alt="PRODUCTION LOG \d+" class="w-full h-auto block" src="Bas_test_0[4-9]\.png"/>\s*)', "`$1</div>")

# 2. Fix the corrupted texts.
$ko_01 = "&lt;TokTok Shadow&gt;의 후속작으로, 16명의 디자이너가 설계한 개별 조명기구의 조형 언어를 해체하여 하나의 부조(Bas-relief)로 구현한 작품입니다. 본래 공간을 밝히고 빛을 발산하던 기능적 오브제들은 그 본연의 효용성을 거세당한 채, 오직 형태와 구조만을 남긴 채 재조립되었습니다."
$en_01 = "As a sequel to &lt;TokTok Shadow&gt;, this artwork deconstructs the formative language of individual lighting fixtures designed by 16 designers, manifesting them into a single bas-relief. The functional objects, which originally illuminated spaces and emitted light, have been stripped of their innate utility, reassembled while retaining only their forms and structures."

$ko_02 = "&lt;TokTok Shadow&gt;의 핵심 정체성인 SLS 나일론 3D 프린팅 기법을 이어받아 개별 오브제의 디테일한 조형을 구현했습니다. 이와 동시에 대형 스케일이 요구하는 거대한 매스(Mass)를 확보하고자 가공된 폼(Foam) 소재를 베이스로 결합하였습니다. 이러한 고정밀 3D 프린트 파트와 거대 매스 구조의 융합을 통해, 부조 특유의 묵직한 부피감과 섬세한 질감을 표현했습니다."
$en_02 = "Inheriting the SLS nylon 3D printing technique—the core identity of &lt;TokTok Shadow&gt;—we realized the detailed forms of individual objects. Simultaneously, to secure the massive three-dimensional volume required by the large scale, machined foam material was integrated as a base. Through this structural fusion of high-precision 3D printed parts and the substantial mass, we expressed the heavy sense of volume and delicate textures characteristic of bas-relief."

$ko_03 = "프로덕션 로그에 글은, 조형물 조립, CNC 가공, 도색, 배선 작업 및 최종 인스톨레이션 구축까지 주요 제작 공정과정을 모니터링 체계로 재구성하여 물리적 질량으로 치환되는 과정을 타임랩스로 보여주고 있다. &lt;TOKTOK SHADOW : BAS-RELIEF&gt;는 GIAF 2024(경남아트페어)에서 첫 선을 보였다."
$en_03 = "The production log reorganizes the main manufacturing processes—from sculpture assembly, CNC machining, painting, wiring, to the final installation—into a monitoring system, showcasing the timelapse of its translation into physical mass. &lt;TOKTOK SHADOW : BAS-RELIEF&gt; debuted at GIAF 2024 (Gyeongnam Art Fair)."

function Replace-Section {
    param($sectionName, $koText, $enText, $html)
    
    $patternKo = '(?s)(<span[^>]*data-original="' + $sectionName + '"[^>]*>.*?</span>\s*<div[^>]*>\s*<div[^>]*>\s*<!-- Mobile Language Switcher -->.*?</div>\s*<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)'
    $html = [regex]::Replace($html, $patternKo, "`$1`n      $koText`n      `$3")
    
    $patternEn = '(?s)(<span[^>]*data-original="' + $sectionName + '"[^>]*>.*?</span>\s*<div[^>]*>\s*<div[^>]*>\s*<!-- Mobile Language Switcher -->.*?</div>\s*<p class="[^"]*mobile-ko-text[^"]*">.*?</p>\s*<p class="[^"]*mobile-en-text[^"]*">)(.*?)(</p>)'
    $html = [regex]::Replace($html, $patternEn, "`$1`n      $enText`n      `$3")
    
    return $html
}

$content = Replace-Section -sectionName "OVERVIEW / 01" -koText $ko_01 -enText $en_01 -html $content
$content = Replace-Section -sectionName "MATERIALITY / 02" -koText $ko_02 -enText $en_02 -html $content
$content = Replace-Section -sectionName "PRODUCTION LOG / 03" -koText $ko_03 -enText $en_03 -html $content

# Write back with UTF8 to preserve characters!
Set-Content $path $content -Encoding UTF8
Write-Host "Fixed encoding and layout!"
