const fs = require('fs');

const path = 'C:\\Users\\PC\\Desktop\\IMWV\\WEB\\TokTokShadow_Bas_Relief\\index.html';
let html = fs.readFileSync(path, 'utf8');

const ko1 = `
    &lt;TokTok Shadow&gt;의 후속작으로, 16명의 디자이너가 설계한 개별 조명의 조형 언어를 해체하여 하나의 부조(Bas-relief)로 구현한 작품입니다. 본래 공간을 밝히고 빛을 발산하던 기능적 오브제들은 본연의 효용성을 소거당한 채, 오직 형태와 구조만을 남기며 재조립되었습니다.
    `;
const ko2 = `
    &lt;TokTok Shadow&gt;의 정체성인 SLS 나일론 3D 프린팅 기법을 이어받아 개별 오브제의 디테일한 조형을 구현했습니다. 이와 동시에 대형 스케일이 가진 거대한 매스(Mass)를 입체적으로 확보하고자 가공 폼(Foam) 소재를 베이스로 결합하였으며, 이러한 고정밀 3D 프린팅 파트와 대형 매스의 구조적 융합을 통해, 부조 특유의 묵직한 덩어리감과 섬세한 질감을 표현했습니다.
    `;
const ko3 = `
    조형의 해체, CNC 가공, 도색, 배선 작업 등 최종 인스톨레이션을 구축하기까지의 주요 제작 공정입니다. 설계 데이터가 물리적 질량으로 치환되는 전 과정의 타임라인을 담고 있으며,〈TOKTOK SHADOW : BAS-RELIEF〉는 GIAF 2024(경남국제아트페어)에서 전시되었습니다.
    `;

const en1 = `
    As a sequel to &lt;TokTok Shadow&gt;, this artwork deconstructs the formative language of individual lighting fixtures designed by 16 designers, manifesting them into a single bas-relief. The functional objects, which originally illuminated spaces and emitted light, have been stripped of their innate utility, reassembled while retaining only their forms and structures.
    `;
const en2 = `
    Inheriting the SLS nylon 3D printing technique—the core identity of &lt;TokTok Shadow&gt;—we realized the detailed forms of individual objects. Simultaneously, to secure the massive three-dimensional volume required by the large scale, machined foam material was integrated as a base. Through this structural fusion of high-precision 3D printed parts and the substantial mass, we expressed the heavy sense of volume and delicate textures characteristic of bas-relief.
    `;
const en3 = `
    This log documents the primary fabrication processes leading up to the final installation, including the deconstruction of forms, CNC machining, painting, and wiring. It captures the entire timeline as design data is transformed into physical mass. 〈TOKTOK SHADOW : BAS-RELIEF〉 was exhibited at GIAF 2024 (Gyeongnam International Art Fair).
    `;

const koTexts = [ko1, ko2, ko3];
const enTexts = [en1, en2, en3];

const koRegex = /(<p class="font-body-base text-\[16px\] md:text-\[18px\] text-on-surface leading-\[2\.2\] font-light text-left scramble-text mobile-ko-text">)([\s\S]*?)(<\/p>)/g;
const enRegex = /(<p (?:id="english-text-trigger" )?class="font-body-base text-\[15px\] md:text-\[17px\] text-on-surface-variant leading-\[2\.2\] font-light tracking-wide text-left opacity-40 scramble-text mobile-en-text hidden-lang">)([\s\S]*?)(<\/p>)/g;

let koIndex = 0;
html = html.replace(koRegex, (match, p1, p2, p3) => {
    const replacement = koTexts[koIndex] !== undefined ? koTexts[koIndex] : p2;
    koIndex++;
    return p1 + replacement + p3;
});

let enIndex = 0;
html = html.replace(enRegex, (match, p1, p2, p3) => {
    const replacement = enTexts[enIndex] !== undefined ? enTexts[enIndex] : p2;
    enIndex++;
    return p1 + replacement + p3;
});

fs.writeFileSync(path, html, 'utf8');
console.log('Fixed texts successfully!');
