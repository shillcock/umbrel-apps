# Proton Bridge for Umbrel (Tailscale edition)

Unofficial Umbrel app that runs [Proton Mail Bridge](https://proton.me/mail/bridge)
in Docker on your Umbrel Pro, with IMAP/SMTP published **only on the Pro's
Tailscale IP** so tailnet clients (JD, your laptop, your phone) can use it.
Nothing is exposed to the LAN or the internet.

- **App ID**: `proton-bridge`
- **UI host port**: 7685 (Umbrel app_proxy → ttyd operator console)
- **IMAP**: `100.103.38.124:1143` (STARTTLS, Tailscale only)
- **SMTP**: `100.103.38.124:1025` (STARTTLS, Tailscale only)
- **Upstream**: `shenxn/protonmail-bridge:build` (sha256-pinned) wrapping
  Proton Bridge (GPL-3.0)

## Install

1. On the Umbrel: **App Store → ⋯ → Community App Stores → Add**, enter:
   ```
   https://github.com/shillcock/umbrel-apps
   ```
2. Install **Proton Bridge**.
3. No terminal needed — everything else happens in the browser.

## First login (browser console)

1. Open the app tile. The browser asks for HTTP basic auth:
   username `bridge`, password = the one shown on the app's tile.
2. Type `login-cli`.
3. In the Bridge CLI: `login` — Proton email, password, 2FA.
4. Type `info`. Copy the **mailbox password** into 1Password.
   (Username is your full Proton address; the mailbox password is what mail
   clients use — never your Proton login password.)
5. Type `exit`. The daemon restarts; close the tab. Mail keeps flowing.

Paid Proton plan required — free accounts can't use Bridge.

## How it's wired

```
browser (Umbrel login → HTTP basic auth)
      |
      v
app_proxy :7685 ──► ttyd :7681 operator console
                        login-cli / status / info-hint
                        credential: bridge / APP_PASSWORD (tile)

tailnet ──► 100.103.38.124:1143 ──► container :143 ──► socat ──► Bridge 127.0.0.1:1143 (IMAP)
tailnet ──► 100.103.38.124:1025 ──► container :25  ──► socat ──► Bridge 127.0.0.1:1025 (SMTP)
```

Bridge only accepts connections from 127.0.0.1, so `runtime.sh` runs socat
forwarders inside the container (143→1143, 25→1025). The compose file
publishes those on the Tailscale IP only.

## Notes

- If the Pro's Tailscale IP ever changes, update the two `ports:` lines in
  `docker-compose.yml` and restart the app.
- Bridge does a full mailbox sync on first login — give it time.
- A JMAP front-end (jmap-proxy sidecar) is a possible future addition; the
  app is structured so it drops in without disturbing Bridge.
