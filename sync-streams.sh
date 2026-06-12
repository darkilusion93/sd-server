#!/usr/bin/env bash
# sync-streams.sh — Sem Destino RP
# rsync dos streams (carros/mapas/roupas/peds) da fonte -> host, por bucket.
#
# Fluxo:
#   1) Correr clean-streams.ps1 ANTES (certifica que nao ha NOVOS blobs hex).
#   2) Correr este script em DRY-RUN (defeito) e rever o que ia mudar.
#   3) Correr com --apply para sincronizar a serio.
#
# Seguranca:
#   - O backdoor conhecido (helpCode no SuperPackOficial) e EXCLUIDO via --exclude
#     -> nunca chega ao host e a fonte/backup nao e mutada (intocavel).
#   - --delete SO nos buckets puros de stream (10/11/12). O [13-peds-interiors] e
#     MISTO (tem tambem recursos do git) -> aditivo, SEM --delete, senao apagava os peds do git.
#
# Requer rsync+ssh. No Windows: WSL (paths /mnt/d/...) ou Git Bash (paths /d/...).
set -euo pipefail

# ===================== CONFIG (editar) =====================
# Fonte dos streams (backup intocavel). WSL: /mnt/d/...  | Git Bash: /d/...
SRC="/mnt/d/GTA V Quim/resources/[assets-streams]"

HOST="185.200.246.14"
SSH_USER="root"            # <-- CONFIRMAR no painel do host (pterodactyl? user/porta diferentes)
SSH_PORT="22"             # <-- pterodactyl costuma ser 2022
DEST_RES="/home/container/resources"   # pasta resources/ no host (onde o server.cfg faz ensure)
# ==========================================================

APPLY=0
[ "${1:-}" = "--apply" ] && APPLY=1
DRY="--dry-run"
[ "$APPLY" = "1" ] && DRY=""

SSH_CMD="ssh -p ${SSH_PORT}"
EXCLUDE=( --exclude='*/BCs_HpNgt36uh/vehicle_names.lua' --exclude='*.rar' )
BASE=( -avz --human-readable $DRY -e "$SSH_CMD" "${EXCLUDE[@]}" )

if [ ! -d "$SRC" ]; then echo "ERRO: fonte nao existe: $SRC"; exit 1; fi
[ "$APPLY" = "1" ] && echo ">>> MODO REAL (--apply)" || echo ">>> DRY-RUN (sem alteracoes). Usa --apply para sincronizar."

# bucket PURO de stream -> pode usar --delete (espelha exatamente)
sync_pure() {
  local src="$1" dest="$2"
  echo "==> [PURO/--delete] $src -> ${SSH_USER}@${HOST}:${DEST_RES}/${dest}/"
  rsync "${BASE[@]}" --delete "$src/" "${SSH_USER}@${HOST}:${DEST_RES}/${dest}/"
}

# bucket MISTO (git+stream) -> aditivo, SEM --delete
sync_add() {
  local dest="$1"; shift
  echo "==> [MISTO/aditivo] $* -> ${SSH_USER}@${HOST}:${DEST_RES}/${dest}/"
  rsync "${BASE[@]}" "$@" "${SSH_USER}@${HOST}:${DEST_RES}/${dest}/"
}

# ===================== MAPEAMENTO =====================
sync_pure "$SRC/[CARROS]"  "[11-vehicles]"     # SuperPackOficial, packcarros_*, motoepri, pj-pack, carros_texturas
sync_pure "$SRC/[mapas]"   "[10-maps]"         # gabz, wxmaps, BeachClub, ILHA, mansion, pearls, bob74_ipl, map_postals, ...
sync_pure "$SRC/[roupas]"  "[12-clothing]"     # eup-roupas, eup-ui, NativeUI, Cerimonia_GNR  (.rar excluido)

# peds/interiores soltos na raiz dos streams -> bucket misto, aditivo
sync_add "[13-peds-interiors]" "$SRC/dalmata" "$SRC/generic_texture_renderer_gfx"
# =====================================================

echo
echo "Feito. ${APPLY:+(sincronizado)}"
[ "$APPLY" = "1" ] || echo "Revisto o dry-run? Corre:  ./sync-streams.sh --apply"
echo "Depois (defesa em profundidade): pass de scanner FiveM (txAdmin/FiveGuard) nos packs + DLLs (carcontrol, fxmigrant)."
