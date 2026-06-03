# HANDOFF — GWAE/CASHMONTH

> 새 세션 클로가 직전 맥락을 잡는 문서. 최신이 맨 위(역순). 최근 3세션만 유지.
> STATE.md=현재 사실(좌표), HANDOFF.md=흐름·맥락(서사). 둘은 별개.

---

## 2026-06-03 — 솔로파운더 인프라 구축 + 클로콘

### Session Topic
세션 연속성·환경 자동화 인프라를 하루에 구축. 단일 진실원부터 클로콘 앱까지.

### Key Decisions
- **단일 진실원**: GWAE 레포(~/CASHMONTH/bets/gwae, private)가 원본. 세 갈래로 흐름 —
  레오·도우=로컬 직접 / 정학=옵시디언 복사본 / 클로=public raw URL.
- **STATE/HANDOFF 분리**: STATE=현재 사실(이력0, 거울), HANDOFF=맥락(3세션 롤링). 업계 표준.
- **public 미러**: private는 클로가 못 읽으니, 비밀 없는 STATE/result/prompts만
  public 레포(gwae-state)로 미러. 클로가 raw URL로 토큰 없이 읽음.
- **자동화**: post-commit hook이 STATE/PROJECT/DECISIONS 커밋 시 vault·public 자동 미러.
- **비밀 게이트**: secret-guard.sh가 push 직전 비밀패턴 검사. STATE·result·prompts 다 통과 필수.
- **옵시디언**: 심링크가 vault 밖 가리켜 다운 → 복사본+sync-state.sh로 전환(해결).
- **STATE commit줄 제거(C안)**: git이 이미 commit 보관하니 STATE 본문엔 중복 안 둠.
- **클로콘(CLOCON)**: 프롬프트 리모컨 앱. 단일 HTML, 데이터 내장(A안, fetch 없음),
  복사 폴백(clipboard+execCommand). 우분투 독 고정 완료.
  등록 방식=prompts.json을 public 누적+클로가 HTML 재생성(나 방식). 절차는 클로 메모리 #5.

### Open Follow-ups
- [ ] raw URL을 클로 메모리에 박기 (새 세션이 STATE 자동 인지) ← 진입 프롬프트 완성용
- [ ] HANDOFF.md를 레포에 두고 public 미러 (이 파일이 그 첫 산출물)
- [ ] result.md 자동 미러 — 현재 sync-result.sh 수동. hook에 묶으면 "완료" 한 마디로 끝남
- [ ] clocon.html을 git에 커밋 (현재 untracked)
- [ ] 본업(여러 번 미뤄짐): 카드 잘림 HIGH 2개(C4 iPhone SE, C5 question-panel) 모바일 실기기 검증
      → 레딧 빌드인퍼블릭 D+2 → GA4·Formspree A/B

### Context for Next Session
오늘은 본업(GWAE 카드 잘림)이 아니라 "인프라+도구"를 종일 깔았다. 이제 새 세션은
raw URL로 STATE를 읽어 시작할 수 있고(설명 0회), WO는 클로가 파일+채팅 코드블럭으로 주면
정학이 복붙 한 번으로 도우/레오에게 전달, 결과는 result.md로 받는다. 클로콘으로 반복
프롬프트는 클릭 복사. 다음은 이 토대 위에서 진짜 본업(카드 잘림 검증)으로 돌아갈 차례.

### 핵심 raw URL (클로 읽기용)
- STATE:   https://raw.githubusercontent.com/yoorobo/gwae-state/main/STATE.md
- result:  https://raw.githubusercontent.com/yoorobo/gwae-state/main/result.md
- prompts: https://raw.githubusercontent.com/yoorobo/gwae-state/main/prompts.json
- HANDOFF: https://raw.githubusercontent.com/yoorobo/gwae-state/main/HANDOFF.md
