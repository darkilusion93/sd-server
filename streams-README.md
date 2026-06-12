# Streams (`[10-maps]` `[11-vehicles]` `[12-clothing]` `[13-peds-interiors]`)

> Os streams (~28 GB: carros, mapas, roupas, peds/interiores) **NÃO entram no git de código**
> (`.gitignore` exclui `[10..13]`). São geridos por **rsync direto ao host** quando estáveis.
> Fonte atual: `D:\GTA V Quim\resources\[assets-streams]`.

## Certificação de segurança (2026-06-12)

Varridos os **123 ficheiros `.lua`** de todos os streams (ripgrep — o `grep` do bash dá
falsos negativos no padrão hex `\x`, NÃO usar):

- **Blob hex (4+ `\x`)** → **1 ficheiro**: o backdoor abaixo. Resto: nada.
- **`assert(load` / `loadstring` / `os.execute` / `io.popen` / `cfx-x` / `stage.php`** → nada (só
  `cfx-gabz-mapdata/version_check.lua` faz um version-check ao GitHub do gabz — benigno).
- **`load(` / `_G[`** → nada (matches eram `RegisterNetEvent` legítimo em CayoImprovements e eup-ui).

➡️ **Streams limpos exceto 1 backdoor conhecido** (em quarentena, abaixo).

## 🔴 QUARENTENA — backdoor `helpCode` no SuperPackOficial

- **Ficheiro:** `[CARROS]/SuperPackOficial/data/[Hype]/BCs_HpNgt36uh/vehicle_names.lua`
- **O que é:** o atacante substituiu um ficheiro legítimo de nomes de carros (devia ser
  `AddTextEntry("BCs_HpNgt36uh", "<nome do carro>")`, como os vizinhos `BCs_HpFmrt24` e
  `BCs_PsTg8t6`) por `RegisterNetEvent("helpCode") + assert(load(payload))()` ofuscado em hex
  → **RCE não autenticado** (qualquer cliente corre Lua no servidor).
- **Ação obrigatória ANTES de sincronizar o SuperPackOficial para o host:** apagar esse ficheiro.
  Correr `clean-streams.ps1` (ao lado deste README) que o remove da pasta de streams indicada.
- Os outros 2 `vehicle_names.lua` do pack são legítimos — o pack em si pode ser reutilizado
  depois de limpo. Idealmente obter o SuperPackOficial de fonte limpa.

## Mapeamento (categoria de origem → bucket)

| Origem (`[assets-streams]/`) | Bucket |
|---|---|
| `[CARROS]/*` (SuperPackOficial, packcarros_*, motoepri, pj-pack, carros_texturas) | `[11-vehicles]` |
| `[mapas]/*` (gabz, wxmaps, BeachClub, ILHA, mansion, pearls, 25paletosheriff, TaxiOffice, lscourt, playboyv2, …) | `[10-maps]` |
| `[roupas]/*` (eup-roupas, eup-ui, NativeUI, Cerimonia_GNR) | `[12-clothing]` |
| peds/interiores soltos (bob74_ipl, map_postals, dalmata, generic_texture_renderer) + (peds, NPCS, mythic_interiors do código) | `[13-peds-interiors]` |
| `[TEST]/[akira]/*` (ttmodz) | `[11-vehicles]` ou descartar |

## Sync ao host (rsync)

Host: `185.200.246.14` · destino: `<resources>/[10..13]` (a mesma pasta `resources/` onde o
`server.cfg` faz `ensure`; o `.gitignore` exclui `[10..13]` → streams e código coexistem sem se
pisarem). Ferramentas: `clean-streams.ps1` (certificador, PowerShell) + `sync-streams.sh` (rsync, WSL/Git Bash).

**Fluxo:**

1. **Certificar** a fonte (read-only — NÃO mexe no backup intocável):
   ```powershell
   .\clean-streams.ps1 -StreamsRoot "D:\GTA V Quim\resources\[assets-streams]"
   ```
   exit 0 = limpo (só o backdoor conhecido) · exit 2 = NOVOS blobs hex → parar e investigar.

2. **Dry-run** do rsync (editar `SSH_USER`/`SSH_PORT`/`DEST_RES` no topo do script primeiro):
   ```bash
   ./sync-streams.sh            # dry-run, mostra o que ia mudar
   ./sync-streams.sh --apply    # sincroniza a sério
   ```

3. Pass adicional recomendado: scanner de malware FiveM (txAdmin/FiveGuard) nos packs + nas
   DLLs (carcontrol, fxmigrant) antes de confiar — defesa em profundidade.

**Segurança embutida no sync:**
- `--exclude='*/BCs_HpNgt36uh/vehicle_names.lua'` → o backdoor **nunca chega ao host** e o
  **backup não é mutado** (não dependemos de o apagar da fonte). `*.rar` também excluído.
- `--delete` **só** nos buckets puros de stream (`[10-maps]`, `[11-vehicles]`, `[12-clothing]`).
  O `[13-peds-interiors]` é **misto** (tem também `peds`/`NPCS`/`mythic_interiors` vindos do
  git) → sync **aditivo, sem `--delete`**, senão apagaria os recursos do git-deploy.
- Streams mudam raramente → sincronizar só quando mudam.

> ⚠️ Confirmar `SSH_USER`/porta no painel do host (se for pterodactyl, costuma ser user
> `username.serverid` e porta `2022`) e o caminho real da pasta `resources/` no host.
