# WO-46 공유 동작 진단 결과

date: 2026-06-07 KST
agent: 도우
scope: 진단/보고만, 코드 수정 없음, 코어 불변, og:image·share핸들러·URL생성부 확인, 비밀값 미기재

---

## 결론

링크가 모두 초기 화면으로 가는 원인은 결과별 고유 URL 기능 미구현이다. 공유 텍스트는 본괘명과 shareHook을 담지만 URL은 고정 루트 `https://gwae-cube.netlify.app`만 포함한다. 결과 복원용 query/hash 생성부와 앱 진입 시 복원 라우팅은 없다.

곤위지 이미지는 앱 코드가 직접 첨부한 것이 아니다. `navigator.share` payload는 `{ text }`뿐이며 `files`와 `url`이 없다. 로컬/배포 HTML에도 `og:image`, `twitter:image`, `image_src`가 없다. 따라서 폰 공유시트의 노란 곤위지 카드는 native share sheet 또는 공유 대상 앱이 공유 텍스트/현재 렌더 화면을 바탕으로 만든 외부 프리뷰로 판단된다.

## 가설 판정

| 가설 | 결과 |
|---|---|
| 1. 곤위지 이미지 출처 | 앱 payload/OG 출처 아님. 이미지 파일 첨부·OG 이미지·Twitter 이미지 모두 없음. |
| 2. 링크가 전부 초기 링크인 원인 | 고유 URL 미구현. 공유 URL이 루트로 하드코딩됨. |
| 3. 미리보기 2개의 정체 | 앱이 2개 아이템을 만든 것이 아니라, 공유시트/공유 대상이 텍스트와 URL을 각각 프리뷰로 만든 것으로 추정. 둘 다 같은 루트 URL을 포함하므로 초기 화면으로 감. |

## 파일/라인 근거

- OG 메타: `index.html:4-6`에는 charset/viewport/title만 있고 `og:image`, `og:title`, `og:description`, `twitter:image` 없음.
- 배포 HTML: `https://gwae-cube.netlify.app` 확인 결과 `og:*`, `twitter:*`, `image_src` 없음.
- Netlify 설정: `.netlify/netlify.toml`에 `headers = []`, `redirects = []`; 메타/이미지 주입 설정 없음.
- 공유 상태 변수: `src/main.js:201` `_currentShareText`.
- URL 생성부: `src/main.js:1353-1357`, 특히 `src/main.js:1356`에서 `https://gwae-cube.netlify.app` 하드코딩.
- 공유 핸들러: `src/main.js:1519-1562`; `shareData = { text: shareText }`, `navigator.share(shareData)`.
- 결과별 URL/복원 로직: `URLSearchParams`는 `debug=1`과 날씨 API 요청에만 사용. `location.hash`, `history.pushState`, 결과 복원용 query/hash/shareId 없음.

## 확정 사항

- `og:image` 값: 없음.
- `navigator.share` 이미지 첨부: 없음.
- `navigator.share` URL 필드: 없음.
- 공유 텍스트 안 URL: 고정 루트.
- 결과별 고유 URL 기능: 없음/미구현.

## 레오 수정 범위

이미지 없는 공유를 유지하려면 share payload와 OG 정책을 명시적으로 정리하고, 결과 공유가 필요하면 본괘/지괘/질문/동효 또는 서버 저장 id를 담은 결과별 URL 생성·파싱·복원 흐름을 별도 구현해야 한다.

## 검증

- 상세 보고서: `~/다운로드/gwae/wo/0607_46_result_공유동작_진단_v1.md`
- 코드 수정: 없음
- 코어 diff: 0
- 비밀값 기재: 없음
- secret-guard: PASS
- push: 1차 반영 후 최종 raw 확인 섹션 갱신 예정
- raw URL 확인: 최종 커밋 후 확인 예정

---

# WO-41 이름버그 수정(B) + 검증용 해석 픽스처(A) 결과

date: 2026-06-07 KST
agent: 레오
source: WO #40 분포측정 + 차이 판정1(B→A→실측→C)
scope: interpretationLookup.js id 기준 정합, validationRecords 추가, AP-2 코어 불변, LLM 0, 비밀값 미기재

---

## B — 룩업 id 기준 정합 (이름버그 수정)

### 변경 파일

| 파일 | 변경 요약 |
|------|-----------|
| `apps/gwae-cube-v0-leo/3DCube_YJH/src/divination/interpretationLookup.js` | 룩업 키를 hexagramName→hexagramId 기준으로 변경, ENGINE_NAME_TO_ID 역매핑 추가 |

### 변경 내용

- **LOOKUP 맵 키**: `hexagramName_situationId_temperamentGroup` → `hexagramId_situationId_temperamentGroup`
- **ENGINE_NAME_TO_ID 맵 신규 추가**: 엔진 nameKo → hexagramId 역매핑. 오버라이드: `'감위수' → 29` (엔진='감위수', DB='중수감' 불일치 해소)
- **ALL_RECORDS**: 정식 records + validationRecords 통합해 룩업 대상으로

### 검증 결과

| 항목 | 결과 |
|------|------|
| 29번(감위수→중수감) HIT | true |
| 정식 5괘(31,9,29,49,3) love/woodfire HIT | 모두 true |
| 코어(hexagramEngine/hexagrams/trigrams) diff | 0 |

---

## A — 검증용 해석 픽스처 추가

### 변경 파일

| 파일 | 변경 요약 |
|------|-----------|
| `apps/gwae-cube-v0-leo/3DCube_YJH/src/data/interpretations_v1_30.json` | validationRecords 배열 추가 (6건) |
| `apps/gwae-cube-v0-leo/3DCube_YJH/src/main.js` | free_reading_view에 validation_only=true 플래그 심어둠 |

### 추가 레코드 (validationRecords)

| key | hexagramId | hexagramName | situationId | temperamentGroup | validationOnly |
|-----|-----------|--------------|-------------|------------------|----------------|
| 19_love_woodfire | 19 | 지택임 | love | woodfire | true |
| 19_love_metalwater | 19 | 지택임 | love | metalwater | true |
| 7_love_woodfire | 7 | 지수사 | love | woodfire | true |
| 7_love_metalwater | 7 | 지수사 | love | metalwater | true |
| 15_love_woodfire | 15 | 지산겸 | love | woodfire | true |
| 15_love_metalwater | 15 | 지산겸 | love | metalwater | true |

- 정식 30레코드(approved_for_dev) 변경·삭제 없음. 정식 records 배열 길이: 30 (불변)
- validationRecords 배열은 records 배열과 완전 분리. meta.validationOnly=true 및 status='validation_fixture' 표기.
- 텍스트: `[검증용] 이 해석은 분포 검증용 임시 텍스트입니다.` 명백한 placeholder.

### GA4 측정 오염 방지

- `main.js` `free_reading_view` 이벤트에 `validation_only: true` 파라미터 추가 (코드 주석: "임시 검증 괘 / 분포 검증용 / GA4 판단 제외")
- 검증 레코드 조회 시에만 파라미터 활성화 (`record.meta?.validationOnly` 조건)

---

## 통과 조건 확인

| 조건 | 결과 |
|------|------|
| B: 29번 포함 5수록괘 hexagramId 기준 HIT | ✅ 모두 true |
| A: 지택임·지수사·지산겸 woodfire/metalwater 해석 HIT | ✅ 모두 true |
| 검증용 레코드 validationOnly=true | ✅ |
| 정식 30레코드와 분리 확인 | ✅ (별도 validationRecords 배열) |
| GA4 validation_only 플래그 | ✅ |
| 코어 diff=0 (AP-2) | ✅ hexagramEngine·hexagrams·trigrams 무수정 |
| LLM 0 | ✅ |
| C(분포편향) 미수정 | ✅ 파킹 유지 |
| secret-guard | ✅ pre-commit 통과 |

---

## 커밋

```
dfa5ad3 WO-41 이름버그 수정(B) + 검증용 해석 픽스처(A) (레오)
```

push: `yoorobo/gwae` main 반영 완료
