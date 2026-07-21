"""
github_core/main.py — Omnichannel AI Content Repurposer (FREE CORE TIER)
=========================================================================
Takes a YouTube URL, extracts the transcript, calls Gemini Flash,
and returns a compelling 5-post Twitter/X thread.

📦 WANT THE FULL SYSTEM?
  → 4 content formats (SEO article, newsletter, short-form scripts + this thread)
  → Brand voice configuration
  → Batch processing for multiple videos
  → WordPress & Ghost auto-publishing
  Grab the Pro & Advanced tiers: https://gumroad.com/l/omnichannel-repurposer

Usage:
  pip install youtube-transcript-api google-genai python-dotenv
  python main.py --url "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"
  python main.py --url "https://youtu.be/VIDEO_ID" --demo
"""

import argparse
import os
import re
import sys
import io
import time
from typing import Optional

# Fix Windows console encoding (PowerShell defaults to cp1252)
if sys.stdout.encoding and sys.stdout.encoding.lower() != 'utf-8':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
if sys.stderr.encoding and sys.stderr.encoding.lower() != 'utf-8':
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')


# ─── Dependency Check ─────────────────────────────────────────────────────────

def _check_deps():
    missing = []
    for mod, pkg in [
        ("youtube_transcript_api", "youtube-transcript-api"),
        ("google.genai", "google-genai"),
        ("dotenv", "python-dotenv"),
    ]:
        try:
            __import__(mod)
        except ImportError:
            missing.append(pkg)
    if missing:
        print(f"\n[ERROR] Missing packages: {', '.join(missing)}")
        print(f"  Run: pip install {' '.join(missing)}\n")
        sys.exit(1)


_check_deps()

from youtube_transcript_api import (
    YouTubeTranscriptApi,
    NoTranscriptFound,
    TranscriptsDisabled,
    CouldNotRetrieveTranscript,
)
from google import genai
from google.genai import types

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass


# ─── YouTube Transcript ───────────────────────────────────────────────────────

def extract_video_id(url: str) -> Optional[str]:
    """Extract the 11-character video ID from any YouTube URL."""
    match = re.search(r"(?:v=|youtu\.be/|embed/|shorts/)([a-zA-Z0-9_-]{11})", url)
    return match.group(1) if match else None


def get_transcript(url: str) -> dict:
    """Fetch and clean the YouTube transcript using v1.x API."""
    video_id = extract_video_id(url)
    if not video_id:
        if re.match(r"^[a-zA-Z0-9_-]{11}$", url):
            video_id = url
        else:
            return {"text": "", "video_id": None, "error": f"Invalid YouTube URL: {url}"}

    try:
        api = YouTubeTranscriptApi()

        # Try preferred languages first, then any available
        try:
            fetched = api.fetch(video_id, languages=["en", "en-US", "en-GB"])
        except (NoTranscriptFound, CouldNotRetrieveTranscript):
            # Try listing all and picking first available
            try:
                transcript_list = api.list(video_id)
                available = list(transcript_list)
                if available:
                    fetched = available[0].fetch()
                else:
                    return {"text": "", "video_id": video_id, "error": "No transcripts available."}
            except Exception as list_err:
                return {"text": "", "video_id": video_id, "error": str(list_err)}

        # Extract text — v1.x returns FetchedTranscriptSnippet objects
        texts = []
        for seg in fetched:
            if hasattr(seg, "text"):
                texts.append(seg.text)
            elif isinstance(seg, dict):
                texts.append(seg.get("text", ""))

        raw = " ".join(texts)
        clean = re.sub(r"\[.*?\]", "", raw)
        clean = re.sub(r"\s+", " ", clean).strip()

        return {"text": clean, "video_id": video_id, "error": None}

    except TranscriptsDisabled:
        return {"text": "", "video_id": video_id, "error": "Transcripts disabled for this video."}
    except Exception as e:
        return {"text": "", "video_id": video_id, "error": str(e)}


# ─── Gemini Thread Generation ─────────────────────────────────────────────────

THREAD_PROMPT = """You are a viral Twitter/X thread writer who creates threads that stop the scroll.

Transform this YouTube video transcript into a 5-tweet thread that earns massive engagement.

RULES:
- Tweet 1: Irresistible hook — bold claim, curiosity gap, or contrarian take
- Tweets 2-4: One powerful insight each — specific, actionable, memorable
- Tweet 5: CTA — "Follow for more" + one-line summary of the thread's value
- Each tweet: UNDER 280 characters
- Number each: "1/ " through "5/ "
- NO hashtag spam
- Write like a human, not a robot

TRANSCRIPT:
{transcript}
"""


def generate_thread(transcript: str, api_key: str) -> str:
    """Call Gemini Flash and return the Twitter thread with fallback models."""
    client = genai.Client(api_key=api_key)
    prompt = THREAD_PROMPT.format(transcript=transcript[:4000])

    fallback_models = ["gemini-2.5-flash", "gemini-2.0-flash", "gemini-1.5-flash", "gemini-1.5-pro"]
    last_error = None

    for model_id in fallback_models:
        for attempt in range(1, 3):
            try:
                response = client.models.generate_content(
                    model=model_id,
                    contents=prompt,
                    config=types.GenerateContentConfig(
                        temperature=0.75,
                        max_output_tokens=1500,
                    ),
                )
                return response.text
            except Exception as e:
                last_error = e
                err_str = str(e).lower()
                print(f"  [WARNING] Gemini API ({model_id}) attempt {attempt}/2 failed: {e}")
                
                # If the error is about model deprecation/not found, break immediately to try the next model
                if "not found" in err_str or "deprecated" in err_str or "invalid model" in err_str or "404" in err_str:
                    break
                
                if attempt < 2:
                    time.sleep(2 ** attempt)

    raise RuntimeError(f"Gemini API failed on all fallback models. Last error: {last_error}")


# ─── Demo Thread (No API Key Required) ───────────────────────────────────────

DEMO_THREAD = """1/ Most creators are stuck working 60-hour weeks for mediocre results.

The top 1% have a system that produces 10x the output in half the time.

Here's what they know (and most people ignore): 🧵

2/ The core insight that changes everything:

You don't need MORE content.
You need to MULTIPLY the content you already create.

One YouTube video → 10 pieces of platform-native content.

3/ The 3-step system:

Step 1: Record ONE anchor video per week
Step 2: Run the transcript through an AI repurposer
Step 3: Publish natively on every platform

Same effort. 10x the reach. No extra hours.

4/ What one video actually generates:

→ 1,200-word SEO article (ranks on Google)
→ This Twitter thread (thousands of impressions)
→ Email newsletter (50%+ open rate)
→ 3 short-form scripts (Reels/TikTok/Shorts)

All from 1 hour of original work.

5/ Consistency compounds.

Daily publishing for 90 days beats one viral attempt.
The algorithm rewards creators who show up.
Your audience rewards creators who deliver value.

Follow for weekly creator growth systems.

---
[DEMO MODE — Add GEMINI_API_KEY to .env for live generation]
Want all 4 content formats? → https://gumroad.com/l/omnichannel-repurposer
"""


# ─── CLI ──────────────────────────────────────────────────────────────────────

def parse_args():
    parser = argparse.ArgumentParser(
        description="FREE Core Tier -- YouTube URL -> Twitter/X Thread (Powered by Gemini Flash)",
    )
    parser.add_argument("--url", required=False, default=None,
                        help="YouTube video URL (omit to enter interactively)")
    parser.add_argument("--demo", action="store_true",
                        help="Show demo output (no API key needed)")
    return parser.parse_args()


def main():
    args = parse_args()

    print("\n+======================================================+")
    print("|  OMNICHANNEL REPURPOSER -- FREE CORE TIER           |")
    print("|  YouTube URL -> Twitter/X Thread via Gemini Flash   |")
    print("+======================================================+")
    print()

    # ── Demo mode ─────────────────────────────────────────────────
    if args.demo:
        print("  [DEMO MODE] Showing sample output.\n")
        print("-" * 55)
        print(DEMO_THREAD)
        print("-" * 55)
        print()
        print("  Want the FULL system? (4 content formats)")
        print("  https://gumroad.com/l/omnichannel-repurposer")
        print()
        sys.exit(0)

    # ── Interactive mode: no --url provided ───────────────────────
    interactive = args.url is None
    if interactive:
        print("  Welcome! Convert any YouTube video into a Twitter/X thread.")
        print("  Powered by Google Gemini Flash AI.")
        print()
        while True:
            try:
                url = input("  Paste YouTube URL here: ").strip()
            except (EOFError, KeyboardInterrupt):
                print("\n  Cancelled.")
                sys.exit(0)
            if not url:
                print("  [!] URL cannot be empty. Please try again.")
                continue
            if "youtube.com" in url or "youtu.be" in url:
                break
            if re.match(r'^[a-zA-Z0-9_-]{11}$', url):
                url = f"https://www.youtube.com/watch?v={url}"
                break
            print("  [!] That doesn't look like a YouTube URL. Try again.")
        print()
    else:
        url = args.url

    # ── Check API key ──────────────────────────────────────────────
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        print("  [WARNING] GEMINI_API_KEY not set. Showing demo output instead.")
        print("  Add your key to a .env file: GEMINI_API_KEY=your_key_here")
        print("  Get a free key at: https://aistudio.google.com\n")
        print("-" * 55)
        print(DEMO_THREAD)
        print("-" * 55)
        if interactive:
            print()
            input("  Press ENTER to close...")
        sys.exit(0)

    print(f"  URL: {url}")
    print()

    # Step 1: Transcript
    print("  -> Fetching transcript...")
    result = get_transcript(url)

    if result["error"]:
        print(f"  [WARNING] {result['error']}")
        print("  -> Using demo content for illustration.")
        transcript_text = None
    else:
        transcript_text = result["text"]
        word_count = len(transcript_text.split())
        print(f"  OK Transcript: {word_count} words (video: {result['video_id']})")

    # Step 2: Generate thread
    print("  -> Generating Twitter thread with Gemini Flash...")
    try:
        if transcript_text:
            thread = generate_thread(transcript_text, api_key)
        else:
            thread = DEMO_THREAD
        print("  OK Thread generated!\n")
    except Exception as e:
        print(f"  [ERROR] {e}\n  -> Showing demo thread instead.\n")
        thread = DEMO_THREAD

    # Step 3: Display
    print("=" * 55)
    print("  YOUR TWITTER/X THREAD")
    print("=" * 55)
    print(thread)
    print("=" * 55)
    print()
    print("  Love this tool? Want 4x the output?")
    print("  Pro Tier ($29): SEO article + thread + newsletter + Reels scripts")
    print("  Advanced Tier ($49): Pro + batch processing + auto-publish")
    print("  Get it at: https://gumroad.com/l/omnichannel-repurposer")
    print()

    if interactive:
        input("  Press ENTER to close...")

    sys.exit(0)


if __name__ == "__main__":
    main()
