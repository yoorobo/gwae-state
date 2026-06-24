# STATE - GWAE
updated: 2026-06-24 KST (WO-73 미커밋 핫픽스 git 정리 완료)

## repo_state
- branch: main / origin/main (WO-73 핫픽스 커밋 `5940503` pushed 2026-06-24)
- working tree: 앱 파일 3개(index.html, analytics.js, main.js)와 root result.md의 WO-73 dirty diff는 커밋 완료. local mirror/클로콘/result_v4 계열 untracked는 범위 밖으로 유지.
- GitHub: yoorobo/gwae (SSH, private) / 미러: yoorobo/gwae-state (public)
- 실사용 작괘 코어: src/divination/hexagramEngine.js + src/data/hexagrams.js + src/data/trigrams.js (AP-2 diff=0 확인)

## runtime_state
- **큐브 앱 = 라이브**: https://gwae-cube.netlify.app
  - 2026-06-09 WO-69(v4): GA4 측정 인프라 + 중앙 sanitizer + 동의배너 + 카메라 온보딩 구현(commit 4cfd84e, Deploy ID 6a27952e1c02541e668c544c).
  - 2026-06-09 GA4 측정ID 교체: 랜딩용 G-8PPM41DCRS -> 큐브앱 전용 G-YVVF39PZ2E(commit 41ed3f2, Deploy ID 6a279d965e33c7381fe4448d). 현재 코드도 analytics.js/index.html에서 G-YVVF39PZ2E 확인.
  - 2026-06-09 WO-71: 대화팩 신청완료 후 닫기 버튼 문구 분기(commit 56e9c52, Unique deploy 6a27ad1a13a59e3aa39a4d1e).
  - 2026-06-10 WO-73 결과: 게스트 작괘 기본화 + 인앱 브라우저 Google OAuth 차단 안내 + 결과 후 로그인 CTA + authState/personalizationMode 측정 파라미터. result.md상 Deploy ID 6a284af632cbdd9d71ff81f3 / Production URL 확인. 2026-06-24에 동일 diff를 `5940503 fix(WO-73): guest cast + in-app OAuth guard (deploy 6a284af)`로 커밋/push 완료. 재배포 없음.
  - 기존 기능: 작괘(MediaPipe 손동작) -> 64괘 도출 -> 해석 -> 공유 -> 히스토리/피드백. 64괘 커버리지와 fallback 체계는 6/7 상태 유지.
- Firebase: Auth(Google OAuth, 승인도메인 gwae-cube.netlify.app 등록), Firestore users/{uid} + feedback 경로. 인앱 브라우저 OAuth 403 이슈는 WO-73에서 게스트 통과/외부 브라우저 안내로 우회했다고 result에 기록됨.
- 측정: GA4 G-YVVF39PZ2E. 표준 이벤트 12개는 WO-69 result 기준 구현. auth_blocked_inapp/external_browser_cta_click 및 cube_cast_start/complete의 authState/personalizationMode 추가는 `5940503`에 반영됨.
- 광고/캠페인: `gwae_v0_cast_01` 6/9~6/11 집행 여부와 성과 숫자는 로컬 git/result에서 직접 확인되지 않음. 확인 필요(외부 Meta/GA4 콘솔 영역).
- 랜딩(별개): S1 fascinating-choux(라이브), B superb-kitsune(보존), resplendent-cannoli(정체불명 드롭) — 6/7 STATE 이후 변동 근거 미확인.

## release_gate (SR-V0) — 통과 후 진행
- SR-V0 통과 사실은 6/7 기준 유지.
- 6/9 이후 추가 완료: WO-69 측정 인프라, GA4 ID hotfix, WO-71 대화팩 닫기 문구, WO-73 인앱 OAuth/게스트 작괘 핫픽스(result 기반).
- 안전장치: AP-2 diff=0, AP-1 LLM 0 확인. sanitizer allowlist는 question/currentQuestion, uid, email, mbti 원문, freeText 등 비허용 필드를 GA4 전송에서 차단하는 구조.

## blockers
- AWS 키 CSV 보안처리 (정학 직접, 미해결 여부 확인 필요)
- Meta 광고관리자/GA4 콘솔 실제 성과 숫자 확인 필요(도우 로컬 접근 불가)
- WO-73 앱 수정분은 `5940503`으로 commit/push 완료. Deploy ID 6a284af632cbdd9d71ff81f3와 git 기준 연결 완료.

## next_actions
1. GA4 콘솔(G-YVVF39PZ2E): Key Event 등록 확인/실행(cube_cast_complete, share_complete).
2. GA4 콘솔: 커스텀 측정기준 등록 확인/실행(appVersion, castId, readingMode, fallbackReason, temperamentGroup, interpretationVersion, utm_content, authState, personalizationMode).
3. Meta/GA4 외부 콘솔에서 `gwae_v0_cast_01` 집행 여부·기간·성과 숫자 확인. 로컬 근거 없으므로 확인 필요.
4. WO-73 핫픽스 working tree 변경분 commit/push 완료: `5940503`가 Deploy ID 6a284af632cbdd9d71ff81f3 결과와 일치. 재배포 없음.
5. WO-70 Pixel은 result_v4/v4_hotfix에서 후속으로 남아 있음. Pixel ID 확보 후 동의·sanitizer 재사용해 추가 여부 결정.
6. 효사384 단일원전 확보 트랙 — 동효 정밀해석 근거 (수요순 고도화).

## parked
- 결제(SR-2): 측정 후. 크레딧 모델 -> PG -> 서버검증 -> Bedrock게이트(AP-1)
- 대화팩 실기능: 페이크도어 데이터 확인 뒤 (V0.1 공감보드 -> V1 질문카드 -> V2 대화방)
- 공개 게시판(allowPublicShare 필드만 예약), 고유URL·동적OG
- 작괘 편향(C)·작괘 시간/엔트로피: 폰 손동작 데이터 측정 후
- 은유추정 19건 톤: 출시 후 피드백 루프로
- 12천지비 "손실" review_needed: 정학 판단 대기
- earth/mixed 4그룹, 80:20 hook비율, 이미지 공유카드
