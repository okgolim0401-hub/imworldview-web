$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$html = Get-Content $path -Raw -Encoding UTF8

# Regex to match the Korean paragraph
$koPattern = '(?s)(<p class="font-body-base text-\[16px\] md:text-\[18px\] text-on-surface leading-\[2\.2\] font-light text-left scramble-text mobile-ko-text">)(.*?)(</p>)'
$koReplacement = '$1
            조형의 해체, CNC 가공, 도색, 배선 작업 등 최종 인스톨레이션을 구축하기까지의 주요 제작 공정입니다. 설계 데이터가 물리적 질량으로 치환되는 전 과정의 타임라인을 담고 있으며,〈TOKTOK SHADOW : BAS-RELIEF〉는 GIAF 2024(경남국제아트페어)에서 전시되었습니다.
            $3'
$html = $html -replace $koPattern, $koReplacement

# Regex to match the English paragraph
$enPattern = '(?s)(<p class="font-body-base text-\[15px\] md:text-\[17px\] text-on-surface-variant leading-\[2\.2\] font-light tracking-wide text-left opacity-40 scramble-text mobile-en-text hidden-lang">)(.*?)(</p>)'
$enReplacement = '$1
            This log documents the primary fabrication processes leading up to the final installation, including the deconstruction of forms, CNC machining, painting, and wiring. It captures the entire timeline as design data is transformed into physical mass. 〈TOKTOK SHADOW : BAS-RELIEF〉 was exhibited at GIAF 2024 (Gyeongnam International Art Fair).
            $3'
$html = $html -replace $enPattern, $enReplacement

[System.IO.File]::WriteAllText($path, $html, [System.Text.Encoding]::UTF8)
Write-Host "Updated production log text!"
