$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$bytes = [System.IO.File]::ReadAllBytes($path)
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Update OVERVIEW Korean text
$oldText = "&lt;TokTok Shadow&gt;의 후속작으로, 16명의 디자이너가 설계한 개별 조명기구의 조형 언어를 해체하여 하나의 부조(Bas-relief)로 구현한 작품입니다. 본래 공간을 밝히고 빛을 발산하던 기능적 오브제들은 그 본연의 효용성을 거세당한 채, 오직 형태와 구조만을 남긴 채 재조립되었습니다."
$newText = "&lt;TokTok Shadow&gt;의 후속작으로, 16명의 디자이너가 설계한 개별 조명기구의 조형 언어를 해체하여 하나의 부조(Bas-relief)로 구현한 작품입니다. 본래 공간을 밝히고 빛을 발산하던 기능적 오브제들은 본연의 효용성을 소거당한 채, 오직 형태와 구조만을 남긴 채 재조립되었습니다."

$content = $content.Replace($oldText, $newText)

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
Write-Host "OVERVIEW text updated successfully!"
