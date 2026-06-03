# bottega-labs.github.io

GitHub Pages site for Bottega Labs mobile apps.
Deployed at: `https://bottega-labs.github.io`

## Structure

Each app lives in its own subdirectory:

```
bottega-labs.github.io/
├── <app-slug>/
│   ├── index.html     # Landing page + App Store link + support contact
│   ├── privacy.html   # Privacy policy (bilingual: Korean + English)
│   └── icon.png       # App icon (120×120, rounded corners)
├── app-ads.txt        # Google AdMob authorization
└── index.html         # Root — intentionally returns 403
```

## Apps

| Slug | Name | App Store ID | Status |
|------|------|-------------|--------|
| `card-memorizer` | Card Memorizer | id6504581198 | Live |
| `my-tally` | My Tally | — | In review |
| `tia` | TIA (Today I Ate) | — | In review |

## URLs

```
Landing page:    https://bottega-labs.github.io/<app-slug>/
Privacy policy:  https://bottega-labs.github.io/<app-slug>/privacy.html
```

Register these in App Store Connect under:
- Marketing URL → landing page
- Support URL → landing page (same)
- Privacy Policy URL → privacy.html

## Common Values

| Key | Value |
|-----|-------|
| Support email | `auspicioussource@gmail.com` |
| AdMob Publisher ID | `pub-8272610349750366` |
| AdMob app-ads.txt line | `google.com, pub-8272610349750366, DIRECT, f08c47fec0942fa0` |

## Adding a New App

1. Create directory: `<app-slug>/`
2. Copy `icon.png` (120×120 px, square — rounded corners applied via CSS)
3. Create `index.html` from the template below
4. Create `privacy.html` from the template below
5. Update the Apps table above
6. Commit and push — GitHub Pages deploys automatically

## HTML Conventions

- No external CSS frameworks — inline `<style>` only
- Apple system font stack: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, ...`
- Accent color: `#7C3AED` (violet)
- Background: `#f5f5f7`, cards: `#ffffff`
- Max content width: `600px` (landing), `800px` (privacy)
- Mobile-first; one breakpoint at `600px`

### index.html template

```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><APP_NAME> - 공식 홈페이지 및 고객지원</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            margin: 0; padding: 0;
            background-color: #f5f5f7; color: #1d1d1f;
            display: flex; flex-direction: column; min-height: 100vh; align-items: center;
        }
        .container { width: 100%; max-width: 600px; background: white; min-height: 100vh; box-shadow: 0 0 20px rgba(0,0,0,0.05); display: flex; flex-direction: column; }
        .hero { padding: 60px 20px 40px; text-align: center; background: linear-gradient(180deg, #ffffff 0%, #f9f9fa 100%); }
        .app-icon-img { width: 120px; height: 120px; border-radius: 28px; margin-bottom: 24px; box-shadow: 0 10px 20px rgba(124,58,237,0.2); }
        h1 { margin: 0; font-size: 28px; font-weight: 700; }
        .subtitle { margin-top: 10px; font-size: 17px; color: #86868b; line-height: 1.4; }
        .store-buttons { display: flex; flex-direction: column; gap: 12px; padding: 20px 40px; margin-top: 10px; }
        .btn-store { display: flex; align-items: center; justify-content: center; height: 50px; border-radius: 12px; text-decoration: none; font-weight: 600; font-size: 16px; transition: transform 0.1s; }
        .btn-store:active { transform: scale(0.98); }
        .ios { background-color: #000; color: white; }
        .section { padding: 30px 20px; border-top: 1px solid #eee; }
        .section-title { font-size: 19px; font-weight: 600; margin-bottom: 15px; }
        .contact-box { background-color: #f5f5f7; padding: 20px; border-radius: 12px; text-align: center; }
        .contact-text { font-size: 15px; color: #555; margin-bottom: 15px; }
        .btn-contact { display: inline-block; padding: 10px 20px; background: white; border: 1px solid #ddd; border-radius: 20px; color: #7C3AED; text-decoration: none; font-size: 14px; font-weight: 500; }
        footer { margin-top: auto; padding: 30px 20px; text-align: center; font-size: 13px; color: #999; background-color: #fafafa; border-top: 1px solid #eee; }
        footer a { color: #666; text-decoration: none; margin: 0 8px; }
        footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero">
            <img src="icon.png" alt="<APP_NAME>" width="120" height="120" class="app-icon-img">
            <h1><APP_NAME></h1>
            <p class="subtitle"><APP_SUBTITLE></p>
        </div>
        <div class="store-buttons">
            <a href="https://apps.apple.com/app/<APP_STORE_ID>" class="btn-store ios" target="_blank">
                Download on the App Store
            </a>
        </div>
        <div class="section">
            <div class="section-title">고객 지원 (Support)</div>
            <div class="contact-box">
                <p class="contact-text">
                    앱 사용 중 문제가 발생했거나 제안하고 싶은 기능이 있으신가요?<br>
                    아래 버튼을 눌러 이메일을 보내주세요.
                </p>
                <a href="mailto:auspicioussource@gmail.com" class="btn-contact">
                    개발자에게 문의하기 (Contact Us)
                </a>
            </div>
        </div>
        <footer>
            <a href="privacy.html"><strong>개인정보처리방침 (Privacy Policy)</strong></a>
            <br><br>
            &copy; 2026 <APP_NAME> Developer. All rights reserved.
        </footer>
    </div>
</body>
</html>
```

### privacy.html structure

Bilingual document (Korean first, then English, separated by `<hr class="divider">`).

Required sections (both languages):
1. 수집하는 개인정보 항목 및 방법 / Information Collection
2. 개인정보의 수집 및 이용 목적 / Purpose of Collection and Use
3. 개인정보의 제3자 제공 / Third-Party Disclosure — always include AdMob
4. 사용자 권리 / User Rights — ATT opt-out instructions (iOS Settings path)
5. 아동의 개인정보 보호 / Children's Privacy — under 14 (KR) / under 13 (EN)
6. 문의처 / Contact Us — `auspicioussource@gmail.com`

Privacy policy effective date format: `YYYY년 MM월 DD일` (KR) / `Month DD, YYYY` (EN)

## Deployment

Push to `main` → GitHub Pages auto-deploys within ~1 minute.
No build step. Pure static HTML.

Branch: `main`
GitHub Pages source: root of `main` branch (configured in repo settings)

## Git Conventions

- Commit per app change: `feat(card-memorizer): update privacy policy effective date`
- Types: `feat`, `fix`, `chore`
- Never push directly to `main` for multi-file changes — use a branch + PR
