# 🎯 Omnichannel AI Content Repurposer — FREE Core Tier

> **⚡ Turn any YouTube video into a Twitter/X thread in seconds — powered by Google Gemini Flash**

---

## 🔥 WANT THE FULL CONTENT SUITE?

> **The Pro & Advanced tiers generate 4 formats from any YouTube video:**  
> ✅ 1,000+ word SEO Blog Article · ✅ Twitter/X Thread · ✅ Email Newsletter · ✅ 3 Short-Form Scripts  
> 
> **👉 [Grab Pro Tier ($29) or Advanced Tier ($49) on Gumroad](https://gumroad.com/l/omnichannel-repurposer)**  
> Batch processing · Brand voice config · WordPress/Ghost auto-publishing

---

## What This Free Version Does

Drop in a YouTube URL → get a viral 5-tweet thread, instantly.

```
python main.py --url "https://www.youtube.com/watch?v=YOUR_VIDEO_ID"
```

### Features (Free Core Tier)
- 🎬 Extracts transcripts from any YouTube video (auto-generated or manual)
- 🤖 Calls Google Gemini Flash for human-quality thread generation
- 🐦 Returns a 5-tweet thread with viral hook and CTA
- 🔁 Fallback demo mode — no API key required to test

---

## Quick Start (5 minutes)

### 1. Clone & Install

```bash
git clone https://github.com/your-handle/YouTube-Content-Repurposer-Core
cd YouTube-Content-Repurposer-Core
pip install youtube-transcript-api google-genai python-dotenv
```

### 2. Get Your Free Gemini API Key

👉 [Google AI Studio](https://aistudio.google.com) → Sign in → Get API key (it's free)

### 3. Set Up Your Key

Create a `.env` file in the project folder:
```
GEMINI_API_KEY=your_gemini_api_key_here
```

### 4. Run It

```bash
# Live mode (requires API key)
python main.py --url "https://www.youtube.com/watch?v=dQw4w9WgXcQ"

# Demo mode (no API key needed — see sample output)
python main.py --url "https://youtu.be/anything" --demo
```

---

## Example Output

```
1/ Most creators work 60-hour weeks for mediocre results.

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

...
```

---

## Requirements

| Requirement | Details |
|---|---|
| Python | 3.9 or higher |
| Gemini API Key | Free at [aistudio.google.com](https://aistudio.google.com) |
| youtube-transcript-api | Auto-installed |
| google-genai | Auto-installed |

---

## Troubleshooting

**"Transcripts disabled"** → The video owner disabled subtitles. Try a different video.

**"No transcript found"** → The video may be too new or in an unsupported language. Add `--demo` flag to see sample output.

**API key errors** → Make sure your `.env` file is in the same folder as `main.py`.

---

## 🚀 Ready for More?

This free core tier gives you **1 output format** (Twitter thread).

The full system generates **4 complete content formats** from a single YouTube video:

| Feature | Free Core | Pro ($29) | Advanced ($49) |
|---|:---:|:---:|:---:|
| Twitter Thread | ✅ | ✅ | ✅ |
| SEO Blog Article | ❌ | ✅ | ✅ |
| Email Newsletter | ❌ | ✅ | ✅ |
| Short-Form Scripts (3x) | ❌ | ✅ | ✅ |
| Brand Voice Config | ❌ | ✅ | ✅ |
| Batch URL Processing | ❌ | ❌ | ✅ |
| WordPress Auto-Publish | ❌ | ❌ | ✅ |
| Ghost Auto-Publish | ❌ | ❌ | ✅ |

---

## 🎯 Upgrade Now — Stop Leaving Content on the Table

> **The creators who win aren't the most talented.  
> They're the most consistent — and they use smarter systems.**

**👉 [Get the Pro Tier ($29) — 4 content formats from every video](https://gumroad.com/l/omnichannel-repurposer)**

**👉 [Get the Advanced Tier ($49) — Everything in Pro + batch + auto-publishing](https://gumroad.com/l/omnichannel-repurposer-advanced)**

---

## License

MIT — Free to use, modify, and distribute. Attribution appreciated.

---

*Built with ❤️ using Google Gemini Flash · [Report Issues](https://github.com/your-handle/YouTube-Content-Repurposer-Core/issues)*
