#!/bin/bash
set -euo pipefail

TMP_DIR="$(mktemp -d)"
cd "$TMP_DIR"

echo "[*] Downloading pystrap..."
curl -sSL https://raw.githubusercontent.com/tjt263/pystrap/main/pystrap.sh -o pystrap
chmod +x pystrap

echo "[*] Installing to /usr/local/bin/pystrap..."
sudo mv pystrap /usr/local/bin/pystrap

echo "[+] Done. You can now run: pystrap"
rm -rf "$TMP_DIR"
