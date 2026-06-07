# STATE - GWAE
updated: 2026-06-07 KST (V0 출시 게이트 통과 — 안전필터 포함 전 차단 해소)

## repo_state
- branch: main / clean (files/ 잔재 삭제 분리커밋 완료)
- GitHub: yoorobo/gwae (SSH, private) / 미러: yoorobo/gwae-state (public)
- 실사용 작괘 코어: src/divination/hexagramEngine.js + src/data/hexagrams.js + src/data/trigrams.js (AP-2 불변)

## runtime_state
- **큐브 앱 = 라이브**: https://gwae-cube.netlify.app (Project 41721050-..., 첫 정식 배포)
  - 작괘(MediaPipe 손동작)→64괘 도출→해석→공유→히스토리→피드백 전부 폰 작동 확인
  - 64괘 커버리지 완성: 5수록괘 상세(3·9·29·31·49 × situation × temperament) + 59괘 fallback(summary+fallbackShare, fallback-v0.1)
  - 원문보기 무료 토글(괘사 한자, "괘사 기반 기본 해석" 표기), 피드백 3분할 저장, 보상(개인화해석 3회 서버측 1회), 대화팩 페이크도어 CTA, 정적 OG 카드
- Firebase: Auth(Google OAuth, 승인도메인 gwae-cube.netlify.app 등록), Firestore users/{uid} + users/{uid}/feedback/{readingId}(규칙 게시 완료)
- 측정: GA4 G-8PPM41DCRS (이벤트 연결 확인은 출시 전 남은 점검)
- 랜딩(별개): S1 fascinating-choux(라이브), B superb-kitsune(보존), resplendent-cannoli(정체불명 드롭)

## release_gate (SR-V0) — 통과
- 절대체크 11개 충족: 멈춤버그0·빈화면0·자동필터·version롤백·피드백저장·readingMode·version·64커버리지·fallbackReason·스모크·검증용제거
- 안전 하한선 통과: 도우 자동필터 전수스캔 명백위반 0건 / 은유추정 19건(review_needed, 출시 안 막음)
- 코어 AP-2 diff=0, AP-1 LLM 0 유지

## blockers
- AWS 키 CSV 보안처리 (정학 직접, 미해결)
- 출시 전 GA4 이벤트 실제 수집 확인 (피드백·대화팩·source_toggle)

## next_actions
1. GA4 이벤트 실제 수집 확인 (출시 전 마지막 기술 점검)
2. V0 출시 = 광고 링크 노출 시작 (인스타 ask.gwae · 페북 캠페인 gwae_s1_v1)
3. 측정: 작괘·공유·재방문·피드백·대화팩CTA·원문토글 데이터 수집
4. (병렬) 제나 RFR #48 발주 — 출시 후 무엇부터 고도화할지(5축)
5. (병렬) 효사384 단일원전 확보 트랙 — 동효 정밀해석 근거 (수요순 고도화)

## parked
- 결제(SR-2): 측정 후. 크레딧 모델→PG→서버검증→Bedrock게이트(AP-1)
- 대화팩 실기능: 페이크도어 데이터 쌓인 뒤 (V0.1 공감보드→V1 질문카드→V2 대화방)
- 공개 게시판(allowPublicShare 필드만 예약), 고유URL·동적OG
- 작괘 편향(C)·작괘 시간/엔트로피: 폰 손동작 데이터 측정 후
- 은유추정 19건 톤: 출시 후 피드백 루프로
- 12천지비 "손실" review_needed: 정학 판단 대기
- earth/mixed 4그룹, 80:20 hook비율, 이미지 공유카드
