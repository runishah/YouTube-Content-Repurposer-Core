#!/bin/bash
# ============================================================
# YouTube to Twitter Thread Generator (FREE Core Tier)
# Linux Launcher — Run: bash run_linux.sh
# ============================================================

cd "$(dirname "$(readlink -f "$0")")"

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
        if [ "$MAJOR" -ge 3 ] && [ "$MINOR" -ge 9 ] 2>/dev/null; then
            PYTHON_CMD="$cmd"
            break
        fi
    fi
done

if [ -z "$PYTHON_CMD" ]; then
    echo "[ERROR] Python 3.9+ not found."
    echo "Install: sudo apt install python3 python3-pip python3-venv"
    read -p "Press ENTER to close..." _
    exit 1
fi
echo "  Python: $PYTHON_CMD ($PY_VERSION)"

# ── Virtual environment ───────────────────────────────────────────
VENV_PYTHON=".venv/bin/python"
if [ ! -f "$VENV_PYTHON" ]; then
    echo "  [SETUP] Creating virtual environment..."
    "$PYTHON_CMD" -m venv .venv 2>/dev/null || true
    [ -f "$VENV_PYTHON" ] && echo "  [OK] venv created." || VENV_PYTHON="$PYTHON_CMD"
else
    echo "  [OK] Virtual environment ready."
fi
[ ! -f "$VENV_PYTHON" ] && VENV_PYTHON="$PYTHON_CMD"

# ── Install packages ──────────────────────────────────────────────
echo ""
echo "  [SETUP] Installing packages..."
"$VENV_PYTHON" -m pip install youtube-transcript-api google-genai python-dotenv --quiet --upgrade 2>/dev/null
echo "  [OK] Packages ready."

# ── Set up .env ───────────────────────────────────────────────────
if [ ! -f ".env" ]; then
    printf 'GEMINI_API_KEY=your_gemini_api_key_here\nPYTHONUTF8=1\n' > .env
    echo "  [SETUP] Created .env"
    echo "  Get FREE API key at: https://aistudio.google.com"
    echo "  Opening .env for editing..."
    for editor in xdg-open gedit nano vim; do
        command -v "$editor" &>/dev/null && { "$editor" .env & break; }
    done
    sleep 2
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
echo "  WANT 4 CONTENT FORMATS? Pro Tier ($29):"
echo "  https://gumroad.com/l/omnichannel-repurposer"
echo "============================================================"
echo ""
read -p "  Press ENTER to close..." _
