$content = Get-Content 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html' -Raw -Encoding UTF8

$brokenBlock = @"
        <!-- Text Block -->
        <div class="flex flex-col gap-6 md:gap-10 mt-16 w-full md:max-w-[50%] text-left items-start">
            <!-- Mobile Language Switcher -->
            <div class="flex md:hidden items-center gap-3 font-label-mono text-[9px] tracking-widest text-outline">
                <button class="lang-btn active text-primary border border-white/20 px-2 py-0.5" onclick="toggleLanguage(this, 'ko')">KR</button>
                <div class="w-[1px] h-3 bg-white/10"></div>
                <button class="lang-btn text-outline" onclick="toggleLanguage(this, 'en')">EN</button>
        <!-- Section Label -->
        <div class="flex justify-between items-center mb-[50px]" style="margin-bottom: 50px;">
"@

$fixedBlock = @"
        <!-- Text Block -->
        <div class="flex flex-col gap-6 md:gap-10 mt-16 w-full md:max-w-[50%] text-left items-start">
            <!-- Mobile Language Switcher -->
            <div class="flex md:hidden items-center gap-3 font-label-mono text-[9px] tracking-widest text-outline">
                <button class="lang-btn active text-primary border border-white/20 px-2 py-0.5" onclick="toggleLanguage(this, 'ko')">KR</button>
                <div class="w-[1px] h-3 bg-white/10"></div>
                <button class="lang-btn text-outline" onclick="toggleLanguage(this, 'en')">EN</button>
            </div>
            <p class="font-body-base text-[16px] md:text-[18px] text-on-surface leading-[2.2] font-light text-left scramble-text mobile-ko-text">
             &lt;TokTok Shadow&gt;의 정체성인 SLS 나일론 3D 프린팅 기법을 이어받아 개별 오브제의 디테일한 조형을 구현했습니다. 이와 동시에 대형 스케일이 가진 거대한 매스(Mass)를 입체적으로 확보하고자 가공 폼(Foam) 소재를 베이스로 결합하였으며, 이러한 고정밀 3D 프린팅 파트와 대형 매스의 구조적 융합을 통해, 부조 특유의 묵직한 덩어리감과 섬세한 질감을 표현했습니다.
            </p>
            <p class="font-body-base text-[15px] md:text-[17px] text-on-surface-variant leading-[2.2] font-light tracking-wide text-left opacity-40 scramble-text mobile-en-text hidden-lang">
            Inheriting the SLS nylon 3D printing technique—the core identity of &lt;TokTok Shadow&gt;—we realized the detailed forms of individual objects. Simultaneously, to secure the massive three-dimensional volume required by the large scale, machined foam material was integrated as a base. Through this structural fusion of high-precision 3D printed parts and the substantial mass, we expressed the heavy sense of volume and delicate textures characteristic of bas-relief.
            </p>
        </div>
    </div>
</section>

<!-- Digital Gallery / Grid (PRODUCTION LOG / 03) -->
<section class="py-32 px-6 md:px-margin relative bg-black">
    <div class="flex flex-col">
        <!-- Section Label -->
        <div class="flex justify-between items-center mb-[50px]" style="margin-bottom: 50px;">
"@

if ($content.Contains($brokenBlock)) {
    $content = $content.Replace($brokenBlock, $fixedBlock)
    [System.IO.File]::WriteAllText('C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html', $content, [System.Text.Encoding]::UTF8)
    Write-Host "Successfully fixed the broken structure!"
} else {
    Write-Host "Could not find the broken block in index.html"
}
