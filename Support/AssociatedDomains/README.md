# Associated Domains (Universal Links)

Reference copy of the `apple-app-site-association` (AASA) file that must be hosted for
Universal Links to open `macmagazine.com.br` post URLs in the app instead of Safari.

## Hosting requirements

Serve the `apple-app-site-association` file (this exact content, **no `.json` extension**) at:

```
https://macmagazine.com.br/.well-known/apple-app-site-association
https://www.macmagazine.com.br/.well-known/apple-app-site-association
```

- HTTPS only, valid certificate.
- `Content-Type: application/json`.
- **No redirects** — must return `200` directly.
- Both apex and `www` must serve it (the app declares `applinks:` for both).

## Scope

`components` allows only `/post/*`, so only article URLs open the app; every other path
(homepage, categories, `/wp-admin`, etc.) stays in the browser.

## App side (already in the repo)

- `com.apple.developer.associated-domains` in `MacMagazine/Resources/MacMagazine.entitlements`
  and `MacMagazineRelease.entitlements`.
- `SceneDelegate` handles the browsing-web `NSUserActivity` (cold + warm launch).

Enable the **Associated Domains** capability on the `com.brit.macmagazine` App ID in the
Developer portal and regenerate provisioning profiles before device/TestFlight builds.

## Verify after hosting

```bash
curl -sI https://macmagazine.com.br/.well-known/apple-app-site-association
xcrun simctl openurl booted https://macmagazine.com.br/post/2025/12/03/<slug>/
```
