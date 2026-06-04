# RESULT - A 랜딩 S 재구성 도우 검증

Recorded: 2026-06-04 KST
Scope: A text landing only. STATE.md, B landing, and casting core not touched.

## 구현 결과

- Updated A landing source: _archive/downloads-misc/Cash_month/index.html
- Added intake storage path file: _vault/decisions/GWAE_S_manual_beta_questions_20260604.md
- B landing left untouched: _archive/downloads-misc/Cash_month/CASHMONTH_페이크도어_랜딩_GWAE연애_B_증표.html
- Casting core left untouched: bets/gwae/apps/gwae-cube-v0-leo/3DCube_YJH/src/*

## 반영 사항

- Hero: "그 사람과 계속 가도 될까?"
- CTA: "내 관계 질문 남기기"
- Tone: non-deterministic relationship reflection; no decisive "meet/break up" promise.
- Price panel: CTA click reveals "₩3,900 정식 출시 예정가" with "출시 전 검증 단계 / 첫 10명 무료 수동 베타" beside it.
- Formspree fields: email, relationship_concern, situation_type, beta_contact_consent, optional price_reaction.
- Concern storage path is included in the page and Formspree payload: _vault/decisions/GWAE_S_manual_beta_questions_20260604.md
- GA4 events implemented: landing_view, cta_click, price_view, beta_submit.
- UTM capture expanded and retained: utm_source, utm_medium, utm_campaign, utm_content, utm_term.

## 도우 검증

- Browser local verification URL: local static server with naver/cpc/gwae_s_rel_v1/copy_a/reunion UTM values.
- landing_view fired with all 5 UTM fields in dataLayer and GA collect 204 observed.
- CTA click revealed price panel and fired cta_click + price_view with UTM values.
- Test beta submission sent once to Formspree endpoint; network response was 200 with { ok: true }.
- beta_submit fired with situation_type=continue_or_break, price_reaction=acceptable, and UTM values; GA collect 204 observed.
- Formspree request body included relationship_concern, situation_type, consent, price reaction, expected price, price context, concern storage path, and UTM fields.
- Console only functional issue observed: favicon.ico 404 on local static server; landing flow unaffected.
- STATE.md status check returned clean/no output.
- Existing private repo untracked clocon.html and result.md were not touched.

## Netlify 상태

- Live URL checked: https://fascinating-choux-d37ed0.netlify.app/
- Live URL still shows old A copy and lead_submit, so redeploy is not reflected.
- Netlify CLI via npx is available, but `netlify status` returned "Not logged in" and no NETLIFY_AUTH_TOKEN / .netlify link was present.
- Existing fascinating-choux site redeploy is blocked by missing Netlify authentication/site link in this session.

## 최종 판정

- Local implementation and functional verification: PASS.
- Formspree network acceptance: PASS.
- GA4 event/network verification: PASS.
- UTM retention: PASS.
- STATE/B/casting-core boundary: PASS.
- Netlify existing URL redeploy: BLOCKED by missing auth; live URL remains old.
