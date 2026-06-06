# HANDOFF — GWAE/CASHMONTH

> 새 세션 클로가 직전 맥락을 잡는 문서. 최신이 맨 위(역순). 최근 3세션만 유지.
> STATE.md=현재 사실(좌표), HANDOFF.md=흐름·맥락(서사). 둘은 별개.

---

## 2026-06-06 — SR-1 구현 직전: 수익화 모델·해석DB·검증기준 확정

### Session Topic
0606 저녁 세션에서 GWAE를 결제 가능한 실제 수익화 제품으로 밀고 가기로 정리했다.
최종 모델은 **측정형 프리미엄**: 무료 구간은 바이럴·가입·히스토리·사전생성 해석으로 측정하고,
Bedrock 심층 해석은 결제 게이트 뒤 SR-2로 미룬다. 오늘의 도달점은 **레오 SR-1 구현 WO 작성 직전**이다.

### Key Decisions
- **수익화 모델 확정**: 비가입 무료=큐브 환경 괘+정적 해석+공유 카드, 가입 무료=사주/MBTI→4기질그룹→사전생성 캐시 룩업+히스토리, 유료=질문 맞춤 심층 해석+톤(Bedrock, 결제 후).
- **무료 Bedrock 금지**: SR-1 무료 구간은 Bedrock/LLM 0회. 모든 무료 해석은 사전생성 DB에서 룩업한다.
- **조합 상한 고정**: 무료 해석은 64괘 × 3상황 × 4기질그룹 = 768 상한. 30레코드는 개발 승인 샘플이며 전체 확장은 측정 후.
- **손절선 고정**: 14일 컷(순유입300·공유율8%·가입전환10%·재방문5%·CTA2%) 통과 전 SR-2 유료 Bedrock 착수 금지.
- **fallback 원칙**: 5괘 외 59괘는 괘명+괘사+공유카드만 제공. 몰래 기질대체 금지(측정오염 방지).

### 완료된 산출물
- #14 해석팩 DB 검증의견서: 차이검증 완료
- #15 수익화 범위 검증의견서: 완료
- #16 수익화 모델 재정의: 완료
- #17 수익화 확정안(측정형 프리미엄): 차이정렬 완료
- #18 SR-1 무료코어 명세: 차이검증·수정 완료(v2)
- #19 Gate1 본문 샘플 10개: 통과(기질차이 검증 OK)
- #20~21 공유 찌르는 한 줄: 차이검증 통과(평균 4.9)
- #22 도우 검증기준 WO: 완료(검증기준 26개, commit 0c71ce2)
- #23 레오 하네스 점검 WO: 완료(codex 수동·secret-guard 미연결 발견)
- #24 secret-guard 연결 WO: 완료(pre-push 연결, commit 534ee76)
- #25 해석DB 스키마: 확정(768 확장전제, status active/draft, fallback)
- interpretations_v1_30.json: 확정(30레코드, approved_for_dev, 차이검수)

### Current Assets
- SR-1 명세: ~/다운로드/0606_18_SR1_free_core.md
- SR-1 검증기준: ~/다운로드/gwae/wo/0606_23_WO_SR1검증기준.md
- HANDOFF 원본: ~/다운로드/0606_26_HANDOFF.md
- 승인 해석DB 대표본: ~/다운로드/interpretations_v1_30 (1).json
- public mirror 보안: gwae-state pre-push secret-guard 연결됨

### Open Follow-ups
- [ ] **레오 SR-1 구현 WO 작성** ← 진짜 다음 작업. 해석DB 30레코드 approved_for_dev, fallback 포함.
- [ ] 구현 분할: OAuth+사주/MBTI 입력 GUI → 4기질 매핑+해석 룩업+fallback → 공유카드+찌르는 한 줄+히스토리 → GA4 이벤트+1일1회.
- [ ] 각 구현 후 도우 검증(#22 기준) → 정학 확인 → 다음.
- [ ] 릴스 소재 제작/Meta 광고는 parked. 카드 해외 원화결제 차단 해제 후 재개.
- [ ] 하네스 보강 나머지(verify-task 린트/테스트 추가, codex 자동검증 hook)는 SR-1 첫 구현 시 또는 병목 시.

### Context for Next Session
새 세션에서 "GWAE 이어가기"를 하면 릴스 제작으로 돌아가면 안 된다. 현재 좌표는 마케팅 실험 전 단계가 아니라
**SR-1 무료 코어 구현 직전**이다. 레오는 acceptEdits 모드이고, 구현 전제는 이미 갖춰졌다:
SR-1 명세(#18), 검증기준(#22), 해석DB 30 approved_for_dev, fallback 원칙, secret-guard pre-push.
다음은 레오에게 줄 SR-1 구현 WO를 작성하는 것이다.

---

## 2026-06-05 — 마케팅 채널 전환: 네이버 검색광고 → 인스타 릴스

### Session Topic
S1/S2 랜딩 배포·준비 완료. 네이버 검색광고 키워드를 실데이터로 검증한 결과 "예상 클릭 0"
발견 → 차이 재검증으로 채널을 인스타그램 릴스(Meta 광고)로 전환 결정.

### Key Decisions
- **채널 전환 확정**: 네이버 검색광고=주력 ❌ → 보조(CPC 구조 조사용)만. 첫 유효 트래픽=인스타 릴스.
  - 근거: 재회·연애사주 롱테일은 검색량 작고 경쟁 높아, 차이 추천 입찰가(500~700)로도
    네이버 월간 예상 클릭이 0~3회/월. 48시간은커녕 한 달도 표본 안 모임.
  - 깨진 가정: "고의도 롱테일은 CPC 낮게 잡으면 작게 검증 가능" → 실제 "노출 조금, 클릭 0".
- **인스타 릴스인 이유**: GWAE는 텍스트보다 "큐브가 움직이는 장면"이 강함. 6~10초 영상이 검색광고
  텍스트보다 훨씬 잘 전달. (차이 논리, 클로·정학 동의)
- **S1/S2 랜딩 분리**(전날 차이 결정 유지): S1=현재관계("그 사람과 계속 가도 될까"),
  S2=재회("다시 이어질 가능성을 묻고 싶다면"). 섞으면 데이터 오염.
- **증표/카드는 보조 가설**: Hero 전면 금지. 가격패널 아래 보조블록 + 선호문항으로 분리측정.
  위젯은 카드 수요 확인 후 별도. GPU원가는 검증 후 단가설계로 미룸. "부적" 톤 금지.

### 현재 자산 상태 (좌표)
- **S1 랜딩 = 라이브**: https://fascinating-choux-d37ed0.netlify.app
  (Hero "그 사람과 계속 가도 될까?", 가격 ₩3,900 예정가, 디지털 괘 카드 보조블록,
   Formspree 선호문항 해석만/카드/위젯/모름, GA4 6이벤트, UTM 5종)
- **S2 재회 랜딩 = 준비완료·배포대기**: ~/다운로드/index_s2_reunion.html
  (sha256 1a4491...abd8f1, GA4 experiment=GWAE-S2-reunion, Formspree landing=S2_reunion)
  → 채널 전환으로 S2 배포는 당분간 보류(재회 키워드 안 쓰므로). 파일은 안전 보관.
- **B 랜딩**(3D 증표, superb-kitsune-0ff759) = C용 보존, 미변경
- 측정: GA4 G-8PPM41DCRS + Formspree mojbzpqz
- **큐브 영상 자산**: satlas 답글용 GIF 있음(cube_gwae.gif, 8~28초 화면녹화, 600px).
  → 릴스용으로 재편집 필요(6~10초, 세로 9:16, 첫1초 후킹, 카피자막).

### 차이 인스타 릴스 파일럿 계획 (다음 실행)
- 채널: Instagram Reels + Stories
- 목표: Traffic / 성과목표 Landing Page Views
- 예산: ₩10,000 × 3일 = ₩30,000 / 랜딩: S1 1개 / 소재: 큐브 영상 1개
- UTM: utm_source=instagram, utm_medium=paid_social, utm_campaign=gwae_s1_ongoing_v1, utm_content=reel_a
- 영상 카피: "그 사람과 계속 가도 될까? / 정답 대신, 지금 관계를 다른 각도에서 보는 한 번의 주역 해석." CTA "내 관계 질문 남기기"
- 3일 판정: 세션<30 채널재검토 / 세션30+ CTA0 메시지약함 / CTA있고 신청0 가격·가치약함 / 신청1+ 수동해석 시작 / 신청3+ 추가집행

### 네이버 잔여 처리 (돈 안 씀)
- 광고 ON 금지. 입찰가 사다리(₩800/1000/1200/1500/1800)로 재회3개(재회사주/상담/타로) 예상실적만 기록.
- 보류 규칙: 최저 유효 CPC > ₩1,000 또는 7일 예상클릭 < 30 → 네이버 S2 보류.
- 첫 테스트는 일치검색만(확장검색은 의도 섞임).

### Open Follow-ups
- [ ] **릴스 소재 제작** ← 진짜 다음 작업. 큐브 GIF → 6~10초 세로 릴스 + 카피 자막
- [ ] Meta 광고 관리자: 인스타 계정 연결 → Traffic/LPV 캠페인 → ₩10,000×3일
- [ ] (선택) 네이버 입찰가 사다리 조사
- [ ] 수동 해석 운영 준비: 정적 괘 카드 1장 디자인(저장하고싶을 품질, 차이 강조)
      판정게이트: 카드선택 4/10+ / 카드있으면 결제고려 3/10+ / 실제결제 2건+ → M-B 착수
- [ ] STATE.md 갱신(현재 미러는 6/3자, 6/4~6/5 마케팅 흐름 미반영)
- [ ] CLOCON "GWAE 이어가기" 진입프롬프트 수정(HANDOFF URL+캐시버스터+두파일 다 읽기) — 미실행

### Context for Next Session
어제(6/4)~오늘(6/5): satlas 레딧 답글(빌드인퍼블릭 첫발) → 마케팅 문서 vault 적재 →
차이 검증 여러 바퀴(타겟 S/C분리, 증표 보조강등, 키워드 재선정) → S1 배포 → S2 준비 →
네이버 키워드 실데이터 "예상 클릭 0" 발견 → 차이 재검증 → 채널을 인스타 릴스로 전환 결정.
핵심 학습: 네이버 충전 전 "월간 예상 실적"부터 확인해 ₩30,000 헛지출을 막음(검증 우선 원칙의 실효).
제나·차이 추정이 실데이터와 어긋남을 두 번 확인(키워드 검색량, 예상 클릭) → 실데이터 확인 필수.
다음은 큐브 영상을 릴스로 만들어 인스타 광고로 첫 유효 트래픽을 확보하는 단계.



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
