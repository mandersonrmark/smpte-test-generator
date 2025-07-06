# 🎞️ SMPTE Countdown Generator

A macOS-based tool for generating high-quality SMPTE color bar countdown videos in multiple resolutions and codecs using FFmpeg — wrapped in a simple, native `.app` GUI via Platypus.

---

## ✅ Features

- Generate SMPTE color bars with animated pan and countdown timer
- Export formats:
  - H.264 (`.mp4`)
  - H.265 / HEVC (`.mp4` with `hvc1` tag for Apple compatibility)
  - Apple ProRes (`.mov`)
  - MPEG-TS (`.ts`)
- Built-in 1kHz tone (optional)
- Native macOS input dialogs using `osascript`
- Self-contained `.app` (no terminal needed)

---

## 📦 Installation

> 🔽 **Prebuilt App:**  
> Download the latest `.zip` from the [Releases page](https://github.com/mandersonrmark/smpte-test-generator/releases) and double-click to install.

> 💻 **From source:**  
> Clone and build with Platypus:
>
> ```bash
> git clone https://github.com/mandersonrmark/smpte-test-generator.git
> cd smpte-test-generator
> open generate_smpte.sh with Platypus
> ```

---

## 🛠 Requirements

- macOS 12 or later
- [FFmpeg](https://evermeet.cx/ffmpeg/) (bundled or install via Homebrew: `brew install ffmpeg`)
- Platypus (for building the .app yourself)

---

## 📂 Project Structure

smpte-test-generator/
├── generate_smpte.sh # Main script
├── Resources/
│ └── ffmpeg # FFmpeg binary (ignored by Git, add manually)
├── MANDER-Transcoder.app # Optional: prebuilt Platypus bundle
├── README.md
├── .gitignore

yaml
Copy
Edit

