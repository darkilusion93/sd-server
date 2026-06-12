# Sem Destino RP — Servidor FiveM (base limpa)

Servidor de roleplay PT (semi-whitelist via Discord) sobre **cframework** (fork ESX, inventário
embutido) + **oxmysql** + **ox_lib**. Reconstrução segura e organizada do servidor antigo
(`D:\GTA V Quim`), feita recurso a recurso com correção dos exploits à entrada.

## Estrutura (`resources/`)

Ordem de load por prefixo numérico:

| Bucket | Conteúdo |
|---|---|
| `[01-libs]` | oxmysql · ox_lib · ft_libs · meta_libs · PolyZone · **cf_safe** (helpers anti-dupe) |
| `[02-core]` | cframework · cbans · cadmin · fxmigrant |
| `[03-ui]` | huds · deadscreen · okokNotify/TextUI/Chat · chat-theme · nh-context |
| `[04-comms]` | cphone · mumble-voip · ls-radio |
| `[05-economy]` | okokBanking · okokContract · okokCrafting · esx_moneywash |
| `[06-jobs]` | `[whitelist]` (mdt, evidence, dna, hospital, …) · `[nowhitelist]` · `[orgs]` |
| `[07-activities]` | motels · tuning · prospecting · posters · armazém · rpscripts · … |
| `[20-standalone]` | record_medical · AutoContra |
| `[10..13]` | **streams** (carros/mapas/roupas/peds) — fora do git, rsync ao host |

## Segredos

Nunca no git. Ficam em `server_secrets.cfg` (git-ignored), carregado por `exec server_secrets.cfg`.
Copiar de `server_secrets.cfg.example` e preencher. **Rotar todas as chaves** (as antigas vazaram).

## Streams

28 GB fora do repo de código. Antes de sincronizar para o host, correr
`clean-streams.ps1` (remove o backdoor conhecido + varre por novos). Ver `streams-README.md`.

## Dev

- Lint: `luacheck resources/` (config em `.luacheckrc`).
- CI: `.github/workflows/ci.yml` — luacheck + gitleaks + sanity de fxmanifest/backdoors.
- Branches: `main` (produção, PR obrigatório, sem force-push) · `dev` (integração).

## Segurança

Auditoria + remediação completa no vault (`Dark/bugs/SemDestino-Security-Audit.md`,
`Dark/tasks/SemDestino-Roadmap.md`). 2 backdoors RCE removidos, 22 críticos corrigidos.
