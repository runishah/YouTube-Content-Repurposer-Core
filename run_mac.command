#!/bin/bash
# ============================================================
# YouTube to Twitter Thread Generator (FREE Core Tier)
# macOS Double-Click Launcher
# ============================================================

cd "$(dirname "$0")"

set -e
trap 'echo ""; echo "[ERROR] See message above."; read -p "Press ENTER to close..." _' ERR

clear
echo ""
echo "============================================================"
echo "  YOUTUBE TO TWITTER THREAD GENERATOR (FREE)"
echo "  Powered by Google Gemini Flash"
echo "============================================================"
echo ""

# ── Find Python ───────────────────────────────────────────────────
PYTHON_CMD=""
for cmd in python3 python python3.12 python3.11 python3.10 python3.9; do
    if command -v "$cmd" &>/dev/null; then
        PY_VERSION=$("$cmd" --version 2>&1 | awk '{print $2}')
        MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
        MINOR=$(echo "$PY_VERSION" | cut -d. -f2)
        if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 9 ]; then
            PYTHON_CMD="$cmd"
            break
        fi
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo "[ERROR] Python 3.9+ not found."
    echo "Install from: https://www.python.org/downloads/"
    read -p "Press ENTER..." _
    exit 1
fi
echo "  Python: $PYTHON_CMD ($PY_VERSION)"

# ── Virtual environment ───────────────────────────────────────────
VENV_PYTHON=".venv/bin/python"
if [ ! -f "$VENV_PYTHON" ]; then
    echo "  [SETUP] Creating virtual environment..."
    "$PYTHON_CMD" -m venv .venv 2>/dev/null || VENV_PYTHON="$PYTHON_CMD"
    [ -f "$VENV_PYTHON" ] && echo "  [OK] venv created." || VENV_PYTHON="$PYTHON_CMD"
else
    echo "  [OK] Virtual environment ready."
fi

# ── Install packages ──────────────────────────────────────────────
echo ""
echo "  [SETUP] Installing packages..."
"$VENV_PYTHON" -m pip install youtube-transcript-api google-genai python-dotenv --quiet --upgrade 2>/dev/null
echo "  [OK] Packages ready."

# ── API Key Setup ───────────────────────────────────────────────────
GEMINI_API_KEY=""
if [ -f ".env" ]; then
    GEMINI_API_KEY=$(grep '^GEMINI_API_KEY=' .env | cut -d '=' -f2-)
fi

if [ -n "$GEMINI_API_KEY" ] && [ "$GEMINI_API_KEY" != "your_gemini_api_key_here" ]; then
    echo ""
    read -p "  [?] Found existing Gemini API key. Do you want to use the same API key of Gemini? (Y/N): " USE_EXISTING
    if [[ "$USE_EXISTING" =~ ^[Nn]$ ]]; then
        read -p "  [?] Enter new GEMINI_API_KEY: " NEW_KEY
        echo "GEMINI_API_KEY=$NEW_KEY" > .env
        echo "PYTHONUTF8=1" >> .env
    fi
else
    echo ""
    echo "  Get a FREE Gemini API key at: https://aistudio.google.com"
    read -p "  [?] Enter your GEMINI_API_KEY: " NEW_KEY
    echo "GEMINI_API_KEY=$NEW_KEY" > .env
    echo "PYTHONUTF8=1" >> .env
fi

# ── Launch ────────────────────────────────────────────────────────
echo ""
echo "============================================================"
echo "  Starting..."
echo "============================================================"
echo ""

export PYTHONUTF8=1
"$VENV_PYTHON" main.py || "$PYTHON_CMD" main.py

echo ""
echo "============================================================"
echo "  WANT 4 CONTENT FORMATS FROM EVERY VIDEO?"
echo "  Pro Tier at: https://gumroad.com/l/omnichannel-repurposer"
echo "============================================================"
echo ""
read -p "  Press ENTER to close..." _
