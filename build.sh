#!/usr/bin/env bash
# 소스 HTML의 %%NAME%% 자리표시자를 .env(또는 환경변수) 값으로 치환해 dist/index.html 생성
set -euo pipefail
cd "$(dirname "$0")"

SRC="랜딩페이지_류무현.html"
OUT="dist/index.html"
# 브라우저에 공개돼도 되는 값만 주입 (비밀 키는 주입 금지)
KEYS=(AMPLITUDE_PROJECT_ID AMPLITUDE_API_KEY)

if [ -f .env ]; then
  while IFS='=' read -r k v; do
    [[ -z "$k" || "$k" == \#* ]] && continue
    [ -z "${!k:-}" ] && export "$k=${v%$'\r'}"
  done < .env
fi

mkdir -p dist
cp "$SRC" "$OUT"
for k in "${KEYS[@]}"; do
  v="${!k:-}"
  [ -z "$v" ] && { echo "누락된 값: $k (.env 또는 환경변수에 설정)" >&2; exit 1; }
  sed -i "s|%%$k%%|$v|g" "$OUT"
done
echo "빌드 완료: $OUT"
