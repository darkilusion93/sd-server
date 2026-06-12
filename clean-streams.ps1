<#
  clean-streams.ps1 — Sem Destino RP
  Remove o backdoor conhecido dos streams e varre por novos blobs ofuscados
  (assinatura hex) ANTES de sincronizar os streams para o host.

  Uso:
    .\clean-streams.ps1 -StreamsRoot "D:\GTA V Quim\resources\[assets-streams]"
    .\clean-streams.ps1 -StreamsRoot "<pasta>" -WhatIf   (só mostra, não apaga)

  NB: o grep do bash dá falsos negativos no padrao \x — por isso a varredura é
  feita aqui em PowerShell (Select-String), que apanha o padrao corretamente.
#>
param(
  [Parameter(Mandatory=$true)] [string]$StreamsRoot,
  [switch]$WhatIf
)

if (-not (Test-Path -LiteralPath $StreamsRoot)) {
  Write-Error "StreamsRoot nao existe: $StreamsRoot"; exit 1
}

# 1) Backdoor conhecido (helpCode) — apagar
$known = Join-Path $StreamsRoot '[CARROS]\SuperPackOficial\data\[Hype]\BCs_HpNgt36uh\vehicle_names.lua'
if (Test-Path -LiteralPath $known) {
  Write-Host "[!] Backdoor conhecido encontrado: $known" -ForegroundColor Yellow
  if ($WhatIf) { Write-Host "    (WhatIf) seria apagado" }
  else { Remove-Item -LiteralPath $known -Force; Write-Host "    apagado." -ForegroundColor Green }
} else {
  Write-Host "[ok] Backdoor conhecido ja nao existe nesta fonte."
}

# 2) Varredura por NOVOS blobs ofuscados (4+ escapes \xHH seguidos)
$hexSig = '(\\x[0-9a-fA-F]{2}){4,}'
Write-Host "`n[*] A varrer .lua por blobs hex (assinatura de backdoor)..."
$hits = Get-ChildItem -LiteralPath $StreamsRoot -Recurse -Filter *.lua -ErrorAction SilentlyContinue |
        Select-String -Pattern $hexSig -List -ErrorAction SilentlyContinue

if ($hits) {
  Write-Host "[!] SUSPEITOS encontrados (verificar/remover manualmente):" -ForegroundColor Red
  $hits | ForEach-Object { Write-Host "    $($_.Path)" -ForegroundColor Red }
  Write-Host "`n    NAO sincronizar para o host enquanto estes nao forem resolvidos."
  exit 2
} else {
  Write-Host "[ok] Sem blobs hex suspeitos. Streams prontos para sync." -ForegroundColor Green
}
