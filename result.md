# WO-37 로그아웃 후 이전 결과 화면 잔류 진단 결과

date: 2026-06-07 KST
agent: 도우
scope: 진단/보고만, 코드 수정 없음, 코어 불변, 콘솔 에러 원문 수집, 비밀값 미기재

---

## 결론

최유력 원인은 로그아웃 경로가 인증 UI만 갱신하고 결과 화면 상태를 초기화하지 않는 것이다.

`AuthManager.signOut()`은 Firebase signOut만 수행하고, 인증 상태 변경 후 `updateAuthUI(null)`은 로그인 버튼/아바타/`sajuProfile`/사주 수정 버튼만 정리한다. 그러나 `appState`, `divResult`, `currentQuestion`, `cardStep`, `resultCards.visible`, `streamingPanel.visible`, `result-detail-open`, `authGate.visible`, `sajuOverlay`, `_pendingReadingCallback`은 로그아웃 경로에서 정리되지 않는다.

따라서 버튼 라벨은 "로그인"으로 바뀌지만 이전 결과 카드/해석 패널/질문 텍스트가 남을 수 있다. 관측된 "freeze"는 JS 런타임 정지보다 로그아웃 후 세션성 UI 상태 잔류에 가깝다.

## 코드 근거

| 항목 | 확인 내용 | 위치 |
|---|---|---|
| 로그아웃 실행 | 로그인 상태에서 인증 버튼 클릭 시 `await AuthManager.signOut()`만 호출한다. 화면 초기화 호출은 없다. | `src/main.js:236-239` |
| signOut 본체 | `AuthManager.signOut()`은 Firebase `signOut(auth)`만 await한다. | `src/auth/AuthManager.js:31-33` |
| auth 상태 콜백 | `onAuthStateChanged`는 `_currentUser` 갱신 후 listener만 호출한다. | `src/auth/AuthManager.js:13-16` |
| 비로그인 UI 갱신 | `updateAuthUI(null)`은 인증 버튼/아바타/label/`sajuProfile`/사주 수정 버튼만 정리한다. | `src/main.js:205-219` |
| 결과 화면 진입 | 작괘 완료 시 `appState = STATE.RESULT`, 이후 결과 카드와 intro가 표시된다. | `src/main.js:1102-1104`, `src/main.js:1171-1175`, `src/main.js:1269-1301` |
| 정상 초기화 루틴 | `resetAll()`은 결과/스트림/상세 class/text/환경 게이트 등을 닫지만 로그아웃 경로에서 호출되지 않는다. | `src/main.js:1465-1500` |
| pending callback | `_pendingReadingCallback`은 로그인/사주/MBTI 게이트에서 설정되지만 로그아웃에서 null 처리되지 않는다. | `src/main.js:83-93`, `src/main.js:274-301`, `src/main.js:1315-1319` |

## 가설 판정

| 가설 | 판정 |
|---|---|
| 로그아웃 핸들러의 UI reset 누락 | 확인됨 |
| `sajuProfile` 또는 `_pendingReadingCallback` 잔류 | `sajuProfile`은 null 처리됨, `_pendingReadingCallback`은 로그아웃에서 미정리 |
| WO-35 callback/render loop 충돌 | 가능성 있음. 콜백 생명주기에 로그아웃 정리가 포함되지 않음 |
| logout 클릭 후 콘솔 에러 | 로그인 세션 부재로 실제 logout 클릭 재현 제한. 수집 가능한 red error는 favicon 404뿐 |

## 콘솔 에러 원문

Playwright 접속 대상: `http://localhost:5173`

Playwright 스냅샷에서 인증 버튼은 "로그인" 상태였고, 세션에 로그인 사용자가 없어 "로그아웃" 클릭 경로는 직접 재현하지 못했다.

```text
[ERROR] Failed to load resource: the server responded with a status of 404 (Not Found) @ http://localhost:5173/favicon.ico:0
```

수집 범위에서 auth/logout/undefined/Cannot read 계열 빨간 에러는 관측하지 못했다.

## 수정 방향 제안

- 로그아웃 완료 또는 `updateAuthUI(null)` 경로에서 `authGate`, `sajuOverlay`, `_pendingReadingCallback`, `streamingPanel`, `resultCards`, `result-detail-open`, `streamText`, `streamPhase`를 정리한다.
- `resetAll()`을 재사용할지, 로그아웃 전용 `resetSessionUiAfterLogout()`을 둘지는 새 질문 흐름 복귀 UX까지 고려해 결정한다.
- 로그아웃 이후에는 이전 `divResult` 기반 결과 상세 진입이 불가능하도록 card state와 pending callback을 함께 끊는다.

## 검증

- 상세 보고서: `~/다운로드/gwae/wo/0607_37_result_logout_freeze_진단_v1.md`
- 코드 수정: 없음
- 코어 diff: 없음
- secret-guard: PASS
- push: 1차 반영 후 최종 raw 확인 섹션 갱신 예정
- raw URL 확인: 최종 커밋 후 확인 예정

---

# WO-36 태그표준 버전 접미사 규칙 반영 결과

date: 2026-06-07 KST
agent: 도우
scope: 태그표준 문서 수정만, 기존 내용 보존·추가, 앱·코어 무관, 비밀값 미기재

---

## 수행 내용

- 대상: `_operations/0606_01_운영_태그표준.md`
- NAMECARD `date`: `0606` -> `0607`
- 문서 제목: `NAMECARD v2` -> `NAMECARD v3`
- 추가 위치: `## 1. 파일명 규칙` 끝, `## 2. 헤더 규칙` 시작 전
- 추가 소절: `## 1-1. 버전 접미사 규칙 (_vN) — 신규`
- 로컬 동기본도 동일 반영했고, 미러 문서와 byte-for-byte 일치 확인

## 검증

- 기존 §1~§5 내용 보존: PASS (지시된 date/title 갱신과 §1-1 추가만 반영)
- secret-guard: PASS (`_operations/0606_01_운영_태그표준.md`, `result.md`)
- push: PASS (`main` 반영)
- raw URL 확인: PASS
  - `_operations/0606_01_운영_태그표준.md`: HTTP 200, `NAMECARD v3`, `버전 접미사 규칙 (_vN)`, `0607_18_기획_SR1무료코어_v2.md` 확인
  - `result.md`: HTTP 200, `WO-36 태그표준 버전 접미사 규칙 반영 결과` 확인

## 판정

미러 push 및 raw URL 반영 확인 PASS.

---

# WO-34 SR-1 구현2 해석 표시 멈춤 버그 진단 결과

date: 2026-06-07 KST
agent: 도우
scope: 진단·보고만, 코드 수정 없음, AP-2 코어 불변, 비밀값 미기재

---

## 콘솔 에러 원문

Playwright로 `http://localhost:5173` 접속 후 fallback 모드, 위치 권한 부여, 작괘, 결과 카드 클릭까지 진행했다. Playwright 컨텍스트에는 Google 로그인 세션이 없어 로그인 이후 사주 저장 버튼까지는 재현하지 못했다.

```text
[ERROR] Failed to load resource: the server responded with a status of 404 (Not Found) @ http://localhost:5173/favicon.ico:0
```

수집 범위에서 `temperamentMapper`, `interpretationLookup`, `undefined`, `Cannot read` 관련 빨간 에러는 없었다.

## 가설 4개 결과

| 가설 | 결과 | 파일:라인 | 기여도 |
|---|---|---|---|
| MBTI 매핑 입력 부재 | 확인됨. 해석 표시 전 `sajuProfile?.mbti`가 없으면 사주 패널을 다시 연다. 하지만 시(hour)가 있으면 저장 시 MBTI를 `null`로 만든다. | `src/main.js:1314-1320`, `src/auth/SajuInputPanel.js:147`, `src/divination/temperamentMapper.js:11-16` | 높음 |
| 저장 핸들러 중복/재진입 | 확인됨. `onSaved()`가 pending 콜백을 실행한 뒤 무조건 null로 지운다. 콜백 내부가 MBTI 없음으로 자신을 다시 등록해도 직후 삭제될 수 있다. | `src/main.js:83-89`, `src/main.js:1315-1319`, `src/auth/SajuInputPanel.js:155-159` | 높음 |
| fallback 표시 오류 | 낮음. 미수록괘는 `{ hit:false }` 후 괘명/괘사/summary를 표시하는 분기가 있고 throw 지점이 없다. | `src/divination/interpretationLookup.js:20-22`, `src/main.js:1322-1338` | 낮음 |
| 콘솔 에러 | 구현2 관련 빨간 에러는 수집되지 않음. 유일한 빨간 에러는 favicon 404로 본 버그와 무관. | `src/auth/SajuInputPanel.js:160-162` | 낮음 |

## 최유력 원인

MBTI 필수 게이트와 사주 저장 UI/콜백 흐름의 불일치.

구현2는 해석 표시 전에 MBTI를 필수로 요구하지만(`src/main.js:1315`), 사주 입력 UI는 시(hour)가 있으면 MBTI를 저장하지 않는다(`src/auth/SajuInputPanel.js:147`). 그래서 시=22 저장 상태에서는 해석 진입 시 계속 사주 패널로 되돌아간다. 또한 `onSaved()`가 콜백 실행 후 `_pendingReadingCallback`을 무조건 null로 지워, 콜백 내부가 다시 등록한 해석 재개 콜백까지 삭제할 수 있다(`src/main.js:88-89`).

## 레오 수정 범위 제안

MBTI 요구 정책과 사주 입력 UX를 일치시키고, `onSaved()`에서 콜백 실행 중 재등록된 `_pendingReadingCallback`을 덮어 지우지 않도록 해석 재개 콜백 생명주기를 정리할 것.

---

# 검증 결과 피드 — 운영체계 업로드

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_03_WO_운영체계_업로드.md
대상: gwae-state/_operations/

## 생성된 폴더·파일 목록
- _operations/
- _operations/0606_01_운영_태그표준.md
- _operations/0606_02_운영_결정종결원칙.md
- _operations/_INDEX.md

## 내용 보존 검증
- 0606_01_운영_태그표준.md: 원본과 복사본 cmp PASS
- 0606_02_운영_결정종결원칙.md: 원본과 복사본 cmp PASS
- 파일명·NAMECARD 보존: PASS

## secret-guard 결과
- _operations/0606_01_운영_태그표준.md: clean
- _operations/0606_02_운영_결정종결원칙.md: clean
- _operations/_INDEX.md: clean

## commit / push
- commit: 6f80825 docs: add operations playbook 0606
- push: main a65abdb..6f80825 완료

## raw URL 접근 확인
- 200 / 2925 bytes / https://raw.githubusercontent.com/yoorobo/gwae-state/main/_operations/0606_01_운영_태그표준.md
- 200 / 2000 bytes / https://raw.githubusercontent.com/yoorobo/gwae-state/main/_operations/0606_02_운영_결정종결원칙.md
- 200 / 128 bytes / https://raw.githubusercontent.com/yoorobo/gwae-state/main/_operations/_INDEX.md

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_07_WO_집1폴더뼈대.md
대상: ~/다운로드/gwae/workflow_book/

## 생성/확인된 폴더 목록
- 00_INDEX
- 0A_운영자산
- 01_raw
- 02_기획
- 03_ADR
- 04_작괘
- 05_마케팅
- 06_랜딩
- 07_광고
- 08_WO
- 09_보고서

## 이동 목록
- GWAE_클로채팅_합본_0606.md -> 01_raw/
- _archive_원본채팅/ -> 01_raw/
- GWAE_파이프라인_PM보고서.md -> 00_INDEX/
- GWAE_검색인덱스_마인드맵가이드.md -> 00_INDEX/

## 01_raw 검증
- 01_raw/GWAE_클로채팅_합본_0606.md: 2175551 bytes
- 01_raw/_archive_원본채팅/: Gwae_01_클로.odt ~ Gwae_08_클로.odt 존재
- 01_raw 정책: 이동만 수행, 수정·삭제 없음

## 특이사항
- 지시서 제목/목표에는 "폴더 10개"라고 되어 있으나, mkdir 명령에는 11개 폴더가 포함되어 있어 명령 기준 11개를 생성/확인함.
- 합본 중 GWAE_클로채팅_합본_0606.md가 존재하여 중단 조건에는 걸리지 않음.
- gwae-state/_operations/ 및 ~/CASHMONTH/bets/gwae/ 미수정.

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_08_WO_filescan.md
대상: ~/CASHMONTH/bets/gwae/, ~/다운로드/gwae/, ~/다운로드/, ~/CASHMONTH/_archive/

## 스캔 결과 파일
- ~/다운로드/gwae/workflow_book/00_INDEX/0606_파일스캔결과.md

## 발견 총 개수
- 162개

## 경로별 개수
- ~/CASHMONTH/bets/gwae: 54개
- ~/다운로드/gwae: 49개
- ~/다운로드: 1개
- ~/CASHMONTH/_archive: 58개

## 검증
- 스캔 결과 파일: 197 lines
- 수행 범위: 읽기·목록화 및 지정 결과 파일/로컬 result.md 기록만 수행
- mv/rm/대상 파일 편집: 수행하지 않음
- 코드베이스(~/CASHMONTH/bets/gwae/) 내용 변경: 수행하지 않음
- 참고: git status 상 기존 변경/미추적 항목(STATE.md, .netlify/, clocon.html, result.md)이 관측됐으나 이번 WO에서 편집하지 않음

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_09_WO_classify.md
대상: ~/다운로드/gwae/workflow_book/

## 수행 요약
- 지정 매핑에 따라 문서 분류 이동 수행
- 구버전 보관 폴더 생성/확인: ~/다운로드/gwae/workflow_book/01_raw/_archive_구버전
- rm 수행 없음
- 목적지 동일 파일명 충돌: 없음
- 편집: 로컬 result.md 미러 기록 외 대상 파일 내용 편집 없음

## 폴더별 파일 수
- 02_기획: 12개
- 03_ADR: 2개
- 04_작괘: 8개
- 05_마케팅: 4개
- 06_랜딩: 4개
- 07_광고: 6개
- 08_WO: 15개
- 0A_운영자산: 1개
- 01_raw/_archive_구버전: 7개

## 코드베이스 진실원 잔존 확인
- STATE.md: PASS
- HANDOFF.md: PASS
- DECISIONS.md: PASS
- PROJECT.md: PASS
- result.md: PASS
- AGENTS.md: PASS
- CLAUDE.md: PASS
- clocon.html: PASS
- .mcp.json: PASS
- .claude/: PASS
- handoff/: PASS
- 3DCube /: PASS
- apps/gwae-cube-v0-leo/: PASS

## 누락/건너뜀
- ~/CASHMONTH/_archive/downloads-misc/GWAE_차이_온보딩브리프_v3.docx: 지시 경로에 없어 건너뜀

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_10_WO_pipeline_upload.md
대상: gwae-state/_operations/0606_03_운영_표준파이프라인.md

## 업로드 결과
- 입력 파일: ~/다운로드/0606_03_pipeline.md
- 업로드 파일: _operations/0606_03_운영_표준파이프라인.md
- _INDEX.md 변경: 기존 #01·#02 유지, #03 항목 1줄 추가
- secret-guard: clean

## 커밋 / push
- operations commit: 2a66527 docs: add operations pipeline 0606
- push: main 88f82a3..2a66527 완료

## raw URL 접근 확인
- 200 / https://raw.githubusercontent.com/yoorobo/gwae-state/main/_operations/0606_03_운영_표준파이프라인.md
- _INDEX 항목 수: 3

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/0606_23_WO_leo_harness_check.md
대상: 레오(Claude Code) 환경 — 교차검증 하네스 작동 점검

## 점검 결과

| 점검 항목 | 상태 | 근거 | 비고 |
|---|---|---|---|
| Claude Code hooks 등록 여부 | 미작동 | ~/.claude/settings.json 및 프로젝트 settings.json 전부 hooks 섹션 없음 | PostToolUse/PreToolUse 미등록 |
| codex 플러그인 활성 | 작동(부분) | enabledPlugins에 codex@openai-codex: true | 플러그인 연결만, 자동 트리거 없음 |
| codex CLI 설치 | 작동 | codex-cli 0.129.0 (@nvm) | approval_policy=never, sandbox=workspace-write |
| 교차검증 하네스 정의 위치 | 작동 | _constitution/CLAUDE.md (4단계 검증), AGENTS.md (핸드오프), SESSION_BOOTSTRAP.md | 규칙 명시 완비 |
| pre-commit hook 설치 | 작동 | .git/hooks/pre-commit → _constitution/scripts/verify-task.sh 실행 | 커밋 시 자동 발동 |
| verify-task.sh 검증 범위 | 부분 | 앱 디렉토리 존재 + package.json 파싱만 수행 | ESLint/Vitest 미실행, 앱 없으면 skip |
| secret-guard.sh | 부분 | 스크립트 존재(_state-mirror/secret-guard.sh), 작동 정상 | pre-push git hook 미연결 (sample만 존재) |
| codex 자동 트리거 | 미작동 | Claude Code hooks 없으므로 코드 편집 시 codex 미호출 | 수동 Skill(codex:*) 호출만 가능 |

## 실작동 테스트 결과

더미 파일 1줄 커밋 시도:
```
🔒 pre-commit hook: 검증 시작...
🔍 GWAE verify-task 시작...
✅ GWAE verify 완료
```
- pre-commit hook 정상 발동 확인
- 더미 파일: _dummy_test_leo.md (커밋 후 즉시 git revert로 원복 완료)

## 결론

**교차검증은 수동.** Claude Code(레오) 레벨에서 hooks가 없어 codex 기반 자동 검증은 발동하지 않는다.
codex는 플러그인으로 설치돼 있으나, Skill(codex:*)로 수동 호출해야 작동한다.

pre-commit hook(→ verify-task.sh)은 자동 작동하나 검증 범위가 최소(앱 디렉토리 유무)에 그친다.
secret-guard.sh는 push 전 수동 실행 필요 — pre-push hook 미연결.

## 미작동 항목 원인 추정

- **Claude Code hooks 없음**: settings.json에 hooks 섹션 자체 미작성. codex 자동 교차검증을 원한다면 PostToolUse hook에 codex 호출 등록 필요.
- **secret-guard.sh pre-push 미연결**: .git/hooks/pre-push 파일 없음. 수동 실행은 가능하나 push 차단 안 됨.
- **verify-task.sh 범위 축소**: 앱 디렉토리 없으면 exit 0 (건너뜀). 현 앱 경로(apps/gwae-cube-v0-leo/3DCube_YJH) 기준 하드코딩.

판정: PASS (점검 완료)

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/gwae/wo/0606_22_WO_도우_SR1검증기준작성.md
실제 입력 파일: ~/다운로드/0606_22_WO_dow_verification.md
대상 산출물: ~/다운로드/gwae/wo/0606_23_WO_SR1검증기준.md

## 수행 요약
- SR-1 무료 코어 구현 전 검증기준 문서 작성 완료
- 형식: SR 항목 | 검증 방법 | 통과 조건 | 자동/수동 표
- 코드 변경 없음
- 작괘 코어 변경 없음

## 검증기준 항목 수
- 총 26개
- AP-1~AP-4: 4개
- SR-1.1~SR-6.3: 22개

## AP-1~4 검증 명령 포함 여부
- AP-1 무료 Bedrock 0회: 포함
- AP-2 작괘 코어 불변 및 기존 9개 단위테스트 유지: 포함
- AP-3 조합 상한 64×3×4=768 및 개별 사주 해석 생성 부재: 포함
- AP-4 무료 질문 1일 1회 및 daily_limit_block 이벤트: 포함

## 미해결/모호 항목
- 원문 SR-1 #18에는 SR-4.4/4.5가 없고, WO-22에만 "찌르는한줄 포함", "80:20 노출비율"이 있어 WO-추가 검증항목으로 문서화함
- AP-2의 9개 단위테스트 기준 파일은 현재 ~/다운로드/gwae/workflow_book/04_작괘/cast.test.ts이며, 구현 레포 이식 시 동일 테스트명 또는 매핑표 필요
- AP-3의 정확히 768 판정은 풀셋 사전생성 DB 배포 기준이며, 샘플 DB 단계에서는 768 이하와 누락 목록을 별도 판정해야 함

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: ~/다운로드/gwae/wo/0606_24_WO_도우_secretguard연결.md
실제 입력 파일: ~/다운로드/0606_24_WO_dow_secretguard.md
대상: gwae-state/result.md, gwae-state local pre-push hook

## 수행 요약
- secret-guard.sh를 local `.git/hooks/pre-push`에 연결
- verify-task.sh 수정 없음
- codex hook 추가/수정 없음
- sync-result.sh, sync.sh 미수정
- 앱 코드 및 작괘 코어 미수정

## 검증
- pre-push hook 실행권한: PASS
- 더미 발동 테스트: `git push --dry-run origin main`에서 secret-guard 실행 확인
- result.md 절대경로 정리 건수: 3건
- result.md 절대경로 잔존: 0건
- secret-guard result.md 검사: PASS

## push
- 이번 push는 pre-push secret-guard 통과 후 진행
- 작업 커밋 해시: 763c623edba817d4ddbedc6812fc1ae04b692327

판정: PASS

---

날짜: 2026-06-06 KST
작업지시: WO — STATE/HANDOFF 갱신 (도우)
입력 파일: ~/다운로드/0606_26_HANDOFF.md
대상: gwae-state/STATE.md, gwae-state/HANDOFF.md

## 수행 요약
- HANDOFF.md 최신 섹션 추가: 0606 저녁 세션 도달점(SR-1 구현 직전) 반영
- STATE.md 현재위치 갱신: SR-1 구현 직전 (수익화 모델 확정, 해석DB 30 확정)
- STATE.md next_actions 1번 교체: 레오 SR-1 구현 WO 작성
- 기존 릴스/Meta 실행은 parked로 보존
- 작괘 코어·앱 코드 미수정

## 산출물 동기화
- ~/다운로드/0606_26_HANDOFF.md -> workflow_book/0A_운영자산/
- 0606 #14, #16~#20, #22~#24 문서 -> NAMECARD dest 기준 보관
- interpretations_v1_30 approved_for_dev 대표본 -> workflow_book/04_작괘/interpretations_v1_30.json
- #15, #21, #25 파일은 현재 다운로드에서 미발견

## 검증
- HANDOFF.md raw URL 반영: PASS (https://raw.githubusercontent.com/yoorobo/gwae-state/main/HANDOFF.md)
- STATE.md raw URL 반영: PASS (https://raw.githubusercontent.com/yoorobo/gwae-state/main/STATE.md)
- STATE next_actions 맨 위: "레오 SR-1 구현 WO 작성 (해석DB 30레코드 approved_for_dev, fallback 포함)" 확인
- 확인용 판정: 새 세션에서 "GWAE 이어가기" 시 다음 행동은 레오 SR-1 구현 WO 작성으로 읽힘
- secret-guard: STATE.md/HANDOFF.md/result.md clean
- 절대경로 잔존: 없음

## commit / push
- 작업 커밋: c92d67eb202a1a4c7b81a3411e7904ec8ac367c4
- 이번 result.md 기록은 secret-guard pre-push 통과 후 push 진행

판정: PASS
