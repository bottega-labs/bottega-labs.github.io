# bottega-labs.github.io

GitHub Pages site for Bottega Labs mobile apps. Jekyll-based.
Deployed at: `https://bottega-labs.github.io`

## Architecture

```
bottega-labs.github.io/
├── _config.yml              # site config, supported langs list
├── _data/
│   ├── apps.yml             # app metadata: name, accent, store IDs, features
│   └── i18n/
│       ├── ko.yml           # Korean UI strings
│       └── en.yml           # English UI strings (add ja.yml etc. for new langs)
├── _layouts/
│   ├── default.html         # HTML shell
│   ├── app.html             # marketing/landing page (data-driven from apps.yml)
│   └── privacy.html         # privacy policy shell (content from page file)
├── _includes/
│   ├── head.html            # <head> tags + SEO
│   └── lang-switcher.html   # language toggle buttons (generated from site.langs)
├── assets/
│   ├── css/main.css         # all styles, CSS custom properties for theming
│   ├── js/lang.js           # language switching (localStorage + browser lang)
│   └── images/
│       └── <app-id>/icon.png
├── <app-slug>/
│   ├── index.html           # frontmatter only: layout, app_id, title, description
│   └── privacy.html         # layout: privacy + bilingual content using data-lang attrs
├── index.html               # org root — lists all apps from apps.yml
└── app-ads.txt              # AdMob: one file at root, covers ALL apps on this domain
```

## Apps

| Slug | Name | App Store ID | Accent | Status |
|------|------|-------------|--------|--------|
| `card-memorizer` | Card Memorizer | `6504581198` | `#7C3AED` | Live |
| `my-tally` | My Tally | — | `#0A84FF` | In review |
| `tia` | TIA (Today I Ate) | — | `#FF6B6B` | In review |

## URLs (register in App Store Connect)

```
Marketing URL:      https://bottega-labs.github.io/<app-slug>/
Support URL:        https://bottega-labs.github.io/<app-slug>/
Privacy Policy URL: https://bottega-labs.github.io/<app-slug>/privacy.html
```

## Common Values

| Key | Value |
|-----|-------|
| Support / privacy email | `auspicioussource@gmail.com` |
| AdMob Publisher ID | `pub-8272610349750366` |
| AdMob app-ads.txt line | `google.com, pub-8272610349750366, DIRECT, f08c47fec0942fa0` |

## Adding a New App

1. **Add entry to `_data/apps.yml`** — id, name, tagline (ko/en), accent, accent_rgb, status, app_store_id, features
2. **Add icon** → `assets/images/<app-id>/icon.png` (square, 120×120+)
3. **Create `<app-slug>/index.html`** — frontmatter only:
   ```yaml
   ---
   layout: app
   app_id: <app-id>
   title: "<App Name> - 공식 홈페이지 및 고객지원"
   description: "<ko tagline>. <en tagline>."
   ---
   ```
4. **Create `<app-slug>/privacy.html`** — layout + bilingual content:
   ```yaml
   ---
   layout: privacy
   app_id: <app-id>
   title: "개인정보처리방침 - <App Name>"
   ---
   ```
   Body: `<div data-lang="ko">...</div>` then `<hr class="privacy-divider">` then `<div data-lang="en">...</div>`
5. **Update Apps table** in this file
6. Push → deploys in ~1 min

## Adding a New Language

1. Add entry to `langs` in `_config.yml`: `{ code: ja, label: 日本語 }`
2. Create `_data/i18n/ja.yml` with all keys from `ko.yml`
3. Add `tagline.ja`, `features.*.title.ja`, `features.*.desc.ja` in `_data/apps.yml`
4. Add `<span data-lang="ja">...</span>` to layouts where other langs appear
5. Add `data-lang="ja"` block in each `privacy.html`

## Privacy Policy Sections

**AdMob apps** (card-memorizer, my-tally): 6 sections
1. 수집하는 개인정보 항목 및 방법 / Information Collection
2. 수집 및 이용 목적 / Purpose — AdMob, Firebase Analytics if used
3. 제3자 제공 / Third-Party Disclosure — always list AdMob; Firebase if used
4. 사용자 권리 / User Rights — ATT opt-out path for iOS and Android
5. 아동의 개인정보 보호 / Children's Privacy — under 14 (KR) / under 13 (EN)
6. 문의처 / Contact Us

**Account-based apps** (tia): 10 sections — see `tia/privacy.html` as reference.
Includes: data retention, user rights (access/delete/withdraw), device permissions, data security, policy change notice.

Date format: `YYYY년 MM월 DD일` (KR) / `Month DD, YYYY` (EN)

## i18n System

- JS (`assets/js/lang.js`) reads `localStorage` → falls back to browser language → defaults to `ko`
- On load: shows only `[data-lang="<active>"]` elements, hides others
- `setLang(code)` is global — called by lang-switcher buttons
- Adding a language requires no JS changes — just update data files and layouts

## CSS Theming

Each app sets `--accent` and `--accent-rgb` via inline style in the layout.
Use `var(--accent)` in CSS for accent color, `rgba(var(--accent-rgb), 0.2)` for shadows.

## Deployment

Push to `main` → GitHub Pages builds with Jekyll automatically.
No custom plugins — only `jekyll-seo-tag` and `jekyll-sitemap` (both GitHub Pages safe).

Local dev: `bundle exec jekyll serve`

## Git Conventions

- Commit per app/section change: `feat(tia): add privacy policy`, `fix(card-memorizer): update effective date`
- Types: `feat`, `fix`, `chore`
- Screenshot images: `assets/images/<app-id>/screenshot-<n>.png` (when ready)
