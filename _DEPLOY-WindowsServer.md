# Sem Destino RP — Deploy em Windows Server (BestVIP)

> Guia de instalação da **base limpa** (`sd-server`) numa máquina **Windows Server** para teste pela equipa BestVIP.
> Base de referência local: `D:\GTA V ESX` · Backup intocável: `D:\GTA V Quim` · Repo: `github.com/darkilusion93/sd-server`
> Roadmap completo: vault `Dark/tasks/SemDestino-Roadmap.md` · Re-teste exploits: `Dark/tasks/SemDestino-Exploit-Retest.md`

## Decisões desta instalação
- **Exposição:** IP **público** → **rotar TODAS as credenciais** antes de subir (secção 1). Não-negociável.
- **License key:** **nova e dedicada** para esta box (não reutilizar a de produção).
- **Streams (~28 GB):** **NÃO** na 1.ª instalação. Arranca-se só com código para validar boot + exploits; streams entram depois (secção 7).
- **Game build:** `3570` (forçado no `server.cfg`) → quem entrar precisa do GTA V nesse build.

---

## 0. Pré-requisitos (instalar na máquina)

| Componente | Onde / Versão | Notas |
|---|---|---|
| **Visual C++ Redist x64** | 2015–2022 (microsoft.com) | Dependência do FXServer. Sem isto nem arranca. |
| **FXServer (artifact Windows)** | `runtime.fivem.net/artifacts/fivem/build_server_windows/master/` | Apanhar um **recommended** recente (suporta gamebuild 3570). Extrair p/ `C:\FXServer\`. |
| **MariaDB** | 10.11 LTS (mariadb.org) | Mesma major do dump. Definir password root nova. |
| **Git para Windows** | git-scm.com | Para `git clone` + futuros `pull`. |
| **(opcional) HeidiSQL** | vem com MariaDB | GUI para importar o dump / inspecionar. |

> **Node.js NÃO é preciso** — os recursos de build (`[02-core]/webpack`, `/yarn`) não foram migrados e o oxmysql vem pré-compilado.

---

## 1. ⚠️ ROTAR credenciais (PRIMEIRO — box é pública)

As creds antigas estão **comprometidas** (texto plano no servidor velho). Rotar cada uma e guardar os valores novos para a secção 4.

| Credencial | Onde rotar | Vai para |
|---|---|---|
| **MySQL** | defines password nova ao criar o user dedicado (secção 3) | `mysql_connection_string` |
| **sv_licenseKey** | keymaster.fivem.net → **+ Add Server → key nova** | `sv_licenseKey` |
| **Steam Web API** | steamcommunity.com/dev/apikey → revogar + nova | `steam_webApiKey` |
| **Discord bot #1** | Discord Dev Portal → Bot → **Reset Token** | `discord_bot_token` (com prefixo `Bot `) |
| **Discord bot #2** (perms) | Dev Portal → Reset Token | `discord_bot_token_perms` (token **cru**, sem `Bot `) |
| **ip-api Pro** | members.ip-api.com | `ipapi_key` |
| **~25–50 webhooks** | apagar nos canais Discord + recriar | convars `webhook_*` (migrar quando se ligarem os logs) |

> Os IDs de guild/roles Discord **não são segredos** — já vêm preenchidos no template (secção 4).

---

## 2. Obter o código (git clone)

```powershell
cd C:\
git clone https://github.com/darkilusion93/sd-server.git server-data
```
Fica `C:\server-data\` com `resources\`, `server.cfg`, `server_secrets.cfg.example`, etc.
Mantém como checkout git → updates por `git pull` (ou txAdmin Git Deploy).

> O `server_secrets.cfg` **NÃO** vem no clone (git-ignored). Cria-se na secção 4.

---

## 3. Base de dados (MariaDB)

```powershell
# 3.1 Importar o dump (cria a DB s1_semdestino automaticamente)
& "C:\Program Files\MariaDB 10.11\bin\mysql.exe" -u root -p < "C:\caminho\para\localhost (1).sql"
```
```sql
-- 3.2 Criar utilizador DEDICADO (NUNCA usar root no servidor) com a password NOVA
CREATE USER 'semdestino'@'localhost' IDENTIFIED BY 'SUBSTITUIR_PASSWORD_NOVA';
GRANT ALL PRIVILEGES ON s1_semdestino.* TO 'semdestino'@'localhost';
FLUSH PRIVILEGES;
```
Dump validado: limpo de segredos, ~11 utilizadores de teste, `users` com `UNIQUE(identifier)` (sem dupes), 0 statements destrutivos. Charset misto mas importa em 10.11 sem problema.

---

## 4. Criar `server_secrets.cfg` (com as creds ROTADAS)

Copiar `server_secrets.NEW.cfg` (ao lado deste guia) para `C:\server-data\server_secrets.cfg` e preencher os `<...>` com os valores **novos** da secção 1.

```powershell
copy "C:\server-data\server_secrets.NEW.cfg" "C:\server-data\server_secrets.cfg"
# depois editar e preencher
```
A `mysql_connection_string` aponta à DB **local**:
```
set mysql_connection_string "server=localhost;database=s1_semdestino;userid=semdestino;password=<PASSWORD_NOVA>;charset=utf8mb4"
```

---

## 5. Firewall / Rede

| Porta | Protocolo | Para quê |
|---|---|---|
| **30120** | TCP **+** UDP | Jogo (jogadores entram) |
| **40120** | TCP | Painel txAdmin (web) |

```powershell
New-NetFirewallRule -DisplayName "FiveM 30120 TCP" -Direction Inbound -Protocol TCP -LocalPort 30120 -Action Allow
New-NetFirewallRule -DisplayName "FiveM 30120 UDP" -Direction Inbound -Protocol UDP -LocalPort 30120 -Action Allow
New-NetFirewallRule -DisplayName "txAdmin 40120 TCP" -Direction Inbound -Protocol TCP -LocalPort 40120 -Action Allow
```
Abrir as mesmas portas na firewall de rede/painel da BestVIP. Restringir a 40120 a IPs de confiança se possível (é o painel admin).

---

## 6. Arrancar (via txAdmin)

```powershell
C:\FXServer\FXServer.exe
```
1. Abre o painel: `http://<IP-DA-BOX>:40120` → cria conta admin.
2. **New Deployment → Local folder** → aponta a **Server Data Folder** a `C:\server-data`.
3. **CFG File** → `C:\server-data\server.cfg`.
4. Start. Acompanhar a consola (live console no txAdmin).
5. Dar acesso à equipa BestVIP pelo painel (txAdmin → Players/Admins).

> O `server.cfg` já tem o **crash fix** (`add_ace resource.cframework command.quit allow`) e os ensures por categoria `[01..20]`. Streams `[10..13]` ficam **comentados** (secção 7).

---

## 7. Streams (depois do boot validado)

NÃO na 1.ª instalação. Quando a base estiver a arrancar limpa e os exploits re-testados:

1. Copiar de `D:\GTA V Quim\resources\[assets-streams]` → buckets `[10..13]`, **excluindo o backdoor**:
   `[CARROS]/SuperPackOficial/data/[Hype]/BCs_HpNgt36uh/vehicle_names.lua` (RCE conhecido).
   Em Windows usar **robocopy** (NÃO o `sync-streams.sh`, que é rsync/Linux):
   ```powershell
   robocopy "D:\GTA V Quim\resources\[assets-streams]\[CARROS]" "C:\server-data\resources\[11-vehicles]" /E /XF vehicle_names.lua
   # (afinar mapeamento por bucket — ver streams-README.md)
   ```
   > `/XF vehicle_names.lua` exclui o ficheiro do backdoor (e os legítimos vizinhos chamam-se `vehicle_names.lua` também → confirmar à mão que só o de `BCs_HpNgt36uh` é o malicioso; os outros 2 do pack são bons). Mapeamento completo CARROS→`[11]`, mapas→`[10]`, roupas→`[12]`, raiz→`[13]` em `streams-README.md`.
2. **Descomentar** no `server.cfg` as 4 linhas `ensure [10-maps] … [13-peds-interiors]`.
3. Pass de scanner de malware FiveM (txAdmin/FiveGuard) nos packs + DLLs (carcontrol, fxmigrant).
4. Restart.

---

## 8. Validação (Fase 8 do roadmap)

- [ ] **8.1** Boot sem erros na consola (zero "Access denied", zero ensures falhados, zero scripts em erro).
- [ ] **8.2** Re-teste dos 22 exploits → guião `Dark/tasks/SemDestino-Exploit-Retest.md` (cada um tem de dar ❌).
- [ ] **8.3** Smoke test legítimo: banco, craft, jobs, inventário, **cphone**, armazém, motel, **np-mdt**. Confirmar que cphone/np-mdt encontram as tabelas.
- [ ] **8.4** Só então `D:\GTA V Quim` deixa de ser produção.

---

## Notas finais
- **Tabelas órfãs:** o dump tem 318 tabelas mas a base só usa `cphone` + `np-mdt`. Sistemas legados (gksphone, npwd `phone_*`, instagram/tiktok/whatsapp, 4 variantes de MDT) ficam órfãs — inofensivas, podar depois se quiserem.
- **PII:** o dump tem dados reais de 11 jogadores (steam/discord/nome/DOB). Box pública → se quiserem ficar limpos, pedir o SQL de anonimização antes de importar.
- **Branch protection do `main`** ficou por ativar (precisa GitHub Pro) — não afeta o deploy.
</content>
