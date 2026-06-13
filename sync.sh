#!/bin/bash
set -e

cp ~/CASHMONTH/bets/gwae/STATE.md ./STATE.md
cp ~/CASHMONTH/bets/gwae/HANDOFF.md ./HANDOFF.md
mkdir -p ./_operations
cp -a ~/CASHMONTH/bets/gwae/_operations/. ./_operations/

if ! bash ~/CASHMONTH/_state-mirror/secret-guard.sh ./STATE.md; then
  echo "[sync] secret guard blocked push"; exit 1
fi
if ! bash ~/CASHMONTH/_state-mirror/secret-guard.sh ./HANDOFF.md; then
  echo "[sync] secret guard blocked push"; exit 1
fi
while IFS= read -r -d '' file; do
  if ! bash ~/CASHMONTH/_state-mirror/secret-guard.sh "$file"; then
    echo "[sync] secret guard blocked push"; exit 1
  fi
done < <(find ./_operations -type f -print0)

git add STATE.md HANDOFF.md _operations/
git commit -m "mirror: sync state handoff operations $(date +%F)" || exit 0
git push
