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
