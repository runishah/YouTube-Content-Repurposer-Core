@echo off
setlocal EnableDelayedExpansion
title YouTube to Twitter Thread — Free Core Tier
color 0A

echo.
echo ============================================================
echo   YOUTUBE TO TWITTER THREAD GENERATOR (FREE)
echo   Powered by Google Gemini Flash
echo ============================================================
echo.

:: ── Step 1: Locate Python ────────────────────────────────────────
set PYTHON_CMD=
for %%P in (python python3 py) do (
    if not defined PYTHON_CMD (
        where %%P >nul 2>&1
        if !errorlevel! == 0 (
            set PYTHON_CMD=%%P
        )
    )
)

if not defined PYTHON_CMD (
    echo [ERROR] Python was not found on your system.
    echo.
    echo Please install Python 3.9+ from: https://www.python.org/downloads/
    echo Make sure to check "Add Python to PATH" during installation.
    echo.
    pause
    exit /b 1
)

for /f "tokens=2 delims= " %%V in ('"%PYTHON_CMD%" --version 2^>^&1') do set PY_VERSION=%%V
echo   Python found: %PYTHON_CMD% (%PY_VERSION%)

:: ── Step 2: Change to script directory ───────────────────────────
cd /d "%~dp0"

:: ── Step 3: Create virtual environment ───────────────────────────
if not exist ".venv\Scripts\python.exe" (
    echo.
    echo   [SETUP] Creating virtual environment...
    %PYTHON_CMD% -m venv .venv
    if !errorlevel! neq 0 (
        echo   [WARNING] Could not create .venv. Using system Python.
        set VENV_PYTHON=%PYTHON_CMD%
        goto :install_deps
    )
    echo   [OK] Virtual environment created.
) else (
    echo   [OK] Virtual environment ready.
)
set VENV_PYTHON=.venv\Scripts\python.exe

:install_deps
:: ── Step 4: Install requirements ─────────────────────────────────
echo.
echo   [SETUP] Installing packages...
"%VENV_PYTHON%" -m pip install youtube-transcript-api google-genai python-dotenv --quiet --upgrade
if !errorlevel! neq 0 (
    %PYTHON_CMD% -m pip install youtube-transcript-api google-genai python-dotenv --quiet
)
echo   [OK] Packages ready.

:: ── Step 5: Check for .env ───────────────────────────────────────
if not exist ".env" (
    echo.
    echo   [SETUP] Creating .env file...
    (
        echo GEMINI_API_KEY=your_gemini_api_key_here
        echo PYTHONUTF8=1
    ) > .env
    echo   [ACTION REQUIRED] Open .env and add your GEMINI_API_KEY.
    echo   Get a FREE key at: https://aistudio.google.com
    echo.
    echo   Press any key to open .env, or Ctrl+C to skip and run in demo mode.
    pause >nul
    notepad .env
    echo.
)

:: ── Step 6: Launch ───────────────────────────────────────────────
echo.
echo ============================================================
echo   Launching...
echo ============================================================
echo.

set PYTHONUTF8=1
"%VENV_PYTHON%" main.py
if !errorlevel! neq 0 (
    %PYTHON_CMD% main.py
)

echo.
echo ============================================================
echo   WANT THE FULL CONTENT SUITE?
echo   Pro Tier ($29) generates SEO article + thread +
echo   newsletter + 3 short-form scripts automatically.
echo   Get it at: https://gumroad.com/l/omnichannel-repurposer
echo ============================================================
echo.
pause
