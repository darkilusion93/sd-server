<#
  clean-streams.ps1 — Sem Destino RP
  CERTIFICADOR (read-only por defeito) dos streams antes do rsync ao host.

  O que faz:
    1. Confirma se o backdoor conhecido (`helpCode` no SuperPackOficial) ainda existe na fonte.
    2. Varre TODOS os .lua por NOVOS blobs ofuscados (assinatura hex 4+ \xHH) que não sejam
       o backdoor já conhecido.
    3. Imprime o --exclude exato a usar no rsync.

  Por defeito NÃO apaga nada — a fonte normal é o backup intocável `D:\GTA V Quim`.
  O backdoor é mantido FORA do host pelo --exclude do rsync (ver sync-streams.sh), não por
  deleção da fonte. Só apaga com -Apply E numa pasta que NÃO seja o backup (staging copy).

  Uso:
    # certificar o backup antes de sincronizar (read-only, recomendado):
    .\clean-streams.ps1 -StreamsRoot "D:\GTA V Quim\resources\[assets-streams]"

    # apagar o backdoor numa CÓPIA de staging (nunca no backup):
    .\clean-streams.ps1 -StreamsRoot "D:\staging\[assets-streams]" -Apply

  Saída: exit 0 = limpo (só o backdoor conhecido) · exit 2 = NOVOS blobs suspeitos (não sincronizar).

  NB: o grep do bash dá falsos negativos no padrão \x — a varredura é feita aqui em PowerShell.
#>
param(
  [Parameter(Mandatory=$true)] [string]$StreamsRoot,
  [switch]$Apply,                 # apagar o backdoor conhecido (só fora do backup)
  [switch]$AllowBackupWrite       # override explícito para apagar dentro de D:\GTA V Quim
)

if (-not (Test-Path -LiteralPath $StreamsRoot)) {
  Write-Error "StreamsRoot nao existe: $StreamsRoot"; exit 1
}

$resolved = (Resolve-Path -LiteralPath $StreamsRoot).Path
$isBackup = $resolved -like '*GTA V Quim*'

# Caminho relativo do backdoor conhecido dentro dos streams
$knownRel = '[CARROS]\SuperPackOficial\data\[Hype]\BCs_HpNgt36uh\vehicle_names.lua'
$known = Join-Path $StreamsRoot $knownRel

# ---- 1) Backdoor conhecido ----
if (Test-Path -LiteralPath $known) {
  Write-Host "[!] Backdoor conhecido (helpCode/RCE) presente:" -ForegroundColor Yellow
  Write-Host "    $known"
  if ($Apply) {
    if ($isBackup -and -not $AllowBackupWrite) {
      Write-Host "    RECUSADO: $StreamsRoot e o BACKUP intocavel. Nao apago aqui." -ForegroundColor Red
      Write-Host "    -> o rsync exclui-o na mesma (--exclude). Para apagar mesmo, usa uma copia de staging."
    } else {
      Remove-Item -LiteralPath $known -Force
      Write-Host "    apagado." -ForegroundColor Green
    }
  } else {
    Write-Host "    (modo certificacao: NAO apagado; o rsync exclui-o via --exclude)." -ForegroundColor DarkGray
  }
} else {
  Write-Host "[ok] Backdoor conhecido nao existe nesta fonte." -ForegroundColor Green
}

# ---- 2) Varredura por NOVOS blobs hex (que nao sejam o backdoor conhecido) ----
$hexSig = '(\\x[0-9a-fA-F]{2}){4,}'
Write-Host "`n[*] A varrer .lua por blobs hex (assinatura de backdoor)..."
$hits = Get-ChildItem -LiteralPath $StreamsRoot -Recurse -Filter *.lua -ErrorAction SilentlyContinue |
        Select-String -Pattern $hexSig -List -ErrorAction SilentlyContinue |
        Where-Object { $_.Path -notlike "*BCs_HpNgt36uh\vehicle_names.lua" }

if ($hits) {
  Write-Host "[!] NOVOS blobs suspeitos (verificar/remover manualmente):" -ForegroundColor Red
  $hits | ForEach-Object { Write-Host "    $($_.Path)" -ForegroundColor Red }
  Write-Host "`n    NAO sincronizar para o host enquanto estes nao forem resolvidos."
  exit 2
} else {
  Write-Host "[ok] Sem NOVOS blobs hex. Streams certificados." -ForegroundColor Green
}

# ---- 3) --exclude para o rsync ----
Write-Host "`n[->] No rsync ao host, excluir sempre o backdoor conhecido:" -ForegroundColor Cyan
Write-Host "     --exclude='*/BCs_HpNgt36uh/vehicle_names.lua'"
Write-Host "     (ja embutido em sync-streams.sh)"
exit 0
