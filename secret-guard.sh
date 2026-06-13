#!/bin/bash
# 인자로 받은 파일(들)에서 비밀 패턴 검사. 발견 시 비0 종료(=push 중단).
target="$1"
[ -f "$target" ] || { echo "[guard] no file: $target"; exit 0; }

# 검사 패턴 (대소문자 무시)
patterns=(
  'api[_-]?''key'
  'secret[_-]?''key'
  'access[_-]?''token'
  'password\s*''='
  'AKIA''[0-9A-Z]{16}'      # AWS access key 형식
  'aws_''secret'
  '-----BEGIN.*PRIVATE ''KEY-----'
  '/home/'"[a-z]+/"         # 내부 절대경로 (사용자명 노출)
)
hit=0
for p in "${patterns[@]}"; do
  if grep -nEi "$p" "$target" >/dev/null 2>&1; then
    echo "[guard] BLOCKED — pattern '$p' found in $target:"
    grep -nEi "$p" "$target" | head -3
    hit=1
  fi
done
[ "$hit" -eq 0 ] && echo "[guard] clean: $target"
exit "$hit"
