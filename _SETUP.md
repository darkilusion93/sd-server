# Sem Destino RP — Base Limpa (`D:\GTA V ESX`)

Reconstrução segura e organizada do servidor. Backup intocável: `D:\GTA V Quim`.
Roadmap completo no vault: `Dark/tasks/SemDestino-Roadmap.md`.

---

## Estado: FASE 0 (preparação) — em curso

Feito:
- [x] Esqueleto de pastas `[01-libs] … [20-standalone]` criado.
- [x] `.gitignore` (runtime, segredos, streams, node_modules).
- [x] `server_secrets.cfg` (git-ignored, valores atuais) + `.cfg.example` (template versionado).
- [x] `server.cfg` limpo: `exec server_secrets.cfg`, **crash fix** (`add_ace resource.cframework command.quit allow`), sem ensures fantasma, sem `[TEST]`, admins limpos. Ensures comentados — cada fase descomenta a sua categoria.
- [x] Lib de validação `[01-libs]/cf_safe` (`:Amount/:Int/:Count/:Slug/:OnlinePlayer`) — base anti-dupe.

Falta na Fase 0:
- [ ] **Rotar credenciais** (abaixo) — ação manual do João nas consolas.
- [ ] Confirmar gestão de streams (host + rsync) — só liga na Fase 5.

---

## ⚠️ Credenciais a ROTAR (estão comprometidas — texto plano no servidor antigo)

| Credencial | Onde rotar | Depois |
|---|---|---|
| **MySQL** (host `185.200.246.14`) | painel do host de hosting → mudar password da DB `s1_semdestino` | atualizar `mysql_connection_string` em `server_secrets.cfg` |
| **sv_licenseKey** | keymaster.fivem.net → revogar + gerar nova | atualizar `sv_licenseKey` |
| **Steam Web API key** | steamcommunity.com/dev/apikey → revogar + nova | atualizar `steam_webApiKey` |
| **Discord bot token #1** | Discord Dev Portal → Bot → Reset Token | atualizar `discord_bot_token` |
| **Discord bot token #2** | (o ofuscado em `permissions/server.lua`) Reset Token | meter em convar `discord_bot_token_perms` |
| **ip-api Pro key** | members.ip-api.com | atualizar `ipapi_key` |
| **~25-50 webhooks Discord** | apagar todos os webhooks nos canais e recriar | migrar para convars `webhook_*` (Fase 2/3) |

> Enquanto não rodas, os valores antigos em `server_secrets.cfg` mantêm o servidor funcional localmente. Mas **não ir a produção** sem rotar.

---

## Próximas fases (resumo)

1. **Fase 1** — migrar `[01-libs]`+`[02-core]` (cframework/cadmin/cbans), corrigir society/runcode/carcontrol, descomentar ensures de libs+core.
2. **Fase 2** — economia (okok*), aplicar `cf_safe` em todos os handlers.
3. **Fase 3** — jobs (mdt auth, garbagejob, esx_jobs, mafiajob…).
4. **Fase 4** — atividades + standalone + ui/comms.
5. **Fase 5** — streams (28 GB) via rsync.
6. **Fase 6** — `server.cfg` final + `permissions.cfg`.
7. **Fase 7** — git + GitHub privado + Actions + deploy txAdmin.
8. **Fase 8** — boot limpo + re-teste de exploits + smoke test.

Detalhe e tabela de migração recurso-a-recurso: `Dark/tasks/SemDestino-Roadmap.md`.
