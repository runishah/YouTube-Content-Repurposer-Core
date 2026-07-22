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
    echo   [SETUP] Creating virtual environment .venv...
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

:: ── Step 5: API Key Setup ────────────────────────────────────────
set "GEMINI_API_KEY="
if exist ".env" (
    for /f "tokens=1* delims==" %%A in (.env) do (
        if "%%A"=="GEMINI_API_KEY" set "GEMINI_API_KEY=%%B"
    )
)

if not "!GEMINI_API_KEY!"=="" (
    if not "!GEMINI_API_KEY!"=="your_gemini_api_key_here" (
        echo.
        set /p USE_EXISTING="  [?] Found existing Gemini API key. Do you want to use the same API key of Gemini? (Y/N): "
        if /i "!USE_EXISTING!"=="N" (
            set /p NEW_KEY="  [?] Enter new GEMINI_API_KEY: "
            echo GEMINI_API_KEY=!NEW_KEY!> .env
            echo PYTHONUTF8=1>> .env
            set "GEMINI_API_KEY=!NEW_KEY!"
        )
    ) else (
        echo.
        echo   Get a FREE Gemini API key at: https://aistudio.google.com
        set /p NEW_KEY="  [?] Enter your GEMINI_API_KEY: "
        echo GEMINI_API_KEY=!NEW_KEY!> .env
        echo PYTHONUTF8=1>> .env
        set "GEMINI_API_KEY=!NEW_KEY!"
    )
) else (
    echo.
    echo   Get a FREE Gemini API key at: https://aistudio.google.com
    set /p NEW_KEY="  [?] Enter your GEMINI_API_KEY: "
    echo GEMINI_API_KEY=!NEW_KEY!> .env
    echo PYTHONUTF8=1>> .env
    set "GEMINI_API_KEY=!NEW_KEY!"
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
