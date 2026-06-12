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

1. Correr `clean-streams.ps1` (remove o backdoor da fonte de streams).
2. rsync da fonte limpa → host, por bucket. Streams mudam raramente → sync só quando mudam.
3. Pass adicional recomendado: scanner de malware FiveM (txAdmin/FiveGuard) nos packs + nas
   DLLs (carcontrol, fxmigrant) antes de confiar — defesa em profundidade.
