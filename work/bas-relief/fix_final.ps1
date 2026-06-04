$path = 'C:\Users\PC\Desktop\IMWV\WEB\TokTokShadow_Bas_Relief\index.html'
$content = Get-Content $path -Raw

# 1. Fix grid
$content = [regex]::Replace($content, '(?s)(<img alt="PRODUCTION LOG [234567]" class="w-full h-auto block" src="Bas_test_0[4-9]\.png"/>)\s*<div class="relative overflow-hidden bg-black">', "`$1`n</div>`n<div class=""relative overflow-hidden bg-black"">")
$content = [regex]::Replace($content, '(?s)(<img alt="PRODUCTION LOG 7" class="w-full h-auto block" src="Bas_test_09\.png"/>)\s*</div>', "`$1`n</div>`n</div>")

# 2. Base64 strings for Korean texts
$ko_01 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Jmx0O1Rva1RvayBTaGFkb3cmZ3Q77J2YIO2UhOyGjeyeueycvOuhnCwgMTbquoXsnbwg65SU7J6Q7J2064SI6rCAIOyEpOqzhO2VnCDqsJzrs4Qg7KGw66qF6riw6rWs7J2YIOyhsO2YlSDslrjslrTrpbwg7ZW07LK07ZWY7JesIO2VmOuCmOydmCDrtoDsobAoQmFzLXJlbGllZinvrOq1rO2YhO2VnCDsnZHtkujsnpXrsqjri6QuIOuzhOuemCDqs7XqsITsnYQg67Cd7Z6I6rOgIOu5m+ydhCDrsJzshbDtlZjrkZgg6riw64ql7KCBIOyYpOubeOsojOullOydgCDqt7gg67O47Jew7J2YIO2aqOyaqeyEs+ydhCDqsbDshLjri7ntlZwg7LGELCDsmKTsp4Eg7ZiV7YOc7JmAIOq1rOsojrrpIOGFpeydhCDrgqjqsoAg7LGEIOyerOsobOumveuQkOyXiOyKteuLiOuLpC4="))
$ko_02 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("Jmx0O1Rva1RvayBTaGFkb3cmZ3Q77J24IO2VteyLrCA7KCV7LK07ISz7J24IFNMUyDrgpjsnbzroZAgM0Qg7ZSF66aw7YyEIOq4sOuyheydhCDsnbTslrTrsJvslYAg6rCc77OEIHsmKTsm4jroIw7J2YIOuUlO2FjO2Zoe2WXCwg7KGw7ZiV7J2EIOq1rO2YhO2XiOyKteuLiOuLpC4g7J207JmAIOuPmeyLnOecgCDrjIDtmJUg7Iqk7LyA7J287J20IOyalOq1rO2VmOuKlCDqs4DrjIDtlZwg666k7IqkKE1hc3Mp66W8IO2ZleyYtO2VmOqzoOyekCDqsIDqs7XrkJwg7Y+8KEZvYW0pIOyGjOyerOullCDrsqDsnbTsiqTroawg6rKw7ZWp7ZWY7JiA7Iq164uI64ukLiDsnLTrnbztlZwg6rOg7KCV66CAIDNEIO2UhOumsO2KuCDtjIztirjsmYAg6rCA64yAIOuupOyKpCDqtaTsobDsnmAg7J217ZWp7J2EIO2Gte2VtCwg67aA7KGwIO2KueycoOydmCDrrow7KeB7ZacIOu2gO2UvOqwhOqzvCDshJzshLjtlZwg7KeI6rCQ7J2EIO2RnO2YhO2XiOyKteuLiOuLpC4="))
$ko_03 = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("7ZSF66Gc642V7IWYIOuhpOq3uOulhCwg7KGw7ZqV66y8IOyhsOumrSwgQ05DIOqwgOqztSwg64+E7IqZLCDrsLDshKAg7J2R7bqVICZhbXA7IOy1nOyXhCDsnbjsiqTtitoOugiOydtOyFmCDqtaT축uaMhOyngCDso7zsmYQg7KCc7J6RIOqzteygleqzvOygleydhCDrqqjri4jtgLDrp4Eg7LK06rOE66GcIOyemOq1rOyEs+2VmO여O6rlOumrOyBgeCA7KeI65+J7Jy866GcIOy5mO2ZmOuQmOuKlCDqs7zsoJXsnYQg7YOA7J6E656p7Iqk66GcIOuztOyXrOyjvOqzoCDsnojri6QuICZsdDtUT0tUT0sgU0hBRE9XIDogQkFTLVJFTElFRiZndDvripQgR0lBRiAyMDI0KOqyveuCqOyVhO2KuO2OmOyWtClc64yC7IScIOyytCDshKDsnYQg67O07JiA64ukLiA="))

# Replace sections
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="OVERVIEW / 01"[^>]*>.*?</span>\s*<div[^>]*>\s*<div[^>]*>\s*<!-- Mobile Language Switcher -->.*?</div>\s*<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}$ko_01`${3}")
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="MATERIALITY / 02"[^>]*>.*?</span>\s*<div[^>]*>\s*<div[^>]*>\s*<!-- Mobile Language Switcher -->.*?</div>\s*<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}$ko_02`${3}")
$content = [regex]::Replace($content, '(?s)(<span[^>]*data-original="PRODUCTION LOG / 03"[^>]*>.*?</span>\s*<div[^>]*>\s*<div[^>]*>\s*<!-- Mobile Language Switcher -->.*?</div>\s*<p class="[^"]*mobile-ko-text[^"]*">)(.*?)(</p>)', "`${1}$ko_03`${3}")

[System.IO.File]::WriteAllBytes($path, [System.Text.Encoding]::UTF8.GetBytes($content))
Write-Host "All texts and grid layout fixed!"
