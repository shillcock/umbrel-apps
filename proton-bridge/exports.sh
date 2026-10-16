# Proton Mail Bridge exports for tailnet clients (JD, etc.)
# IMAP/SMTP are published on the Pro's Tailscale IP only — not on app_proxy,
# not on the LAN, not on the internet.

export APP_PROTON_BRIDGE_HOST="100.103.38.124"
# Host ports on the Tailscale interface -> container 143/25 -> Bridge 1143/1025
export APP_PROTON_BRIDGE_IMAP_PORT="1143"
export APP_PROTON_BRIDGE_SMTP_PORT="1025"
# ttyd operator console (behind Umbrel app_proxy auth)
export APP_PROTON_BRIDGE_UI_PORT="7681"
