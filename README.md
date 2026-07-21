# ResumeTailor AI

An AI-powered resume optimization app built with Flutter. Upload your resume and a job description to get an ATS-friendly version tailored to the role.

---

## Screenshots

| Splash | Home | Input |
|--------|------|-------|
| ![Splash](screenshots/splash.png) | ![Home](screenshots/home.png) | ![Input](screenshots/input.png) |

| Optimizing | Result | Compare |
|------------|--------|---------|
| ![Optimizing](screenshots/optimizing.png) | ![Result](screenshots/result.png) | ![Compare](screenshots/compare.png) |

---

## Features

- **AI-Powered Optimization** — Uses Groq AI (LLaMA 3.3 70B) to tailor your resume to a job description
- **PDF/DOCX Import** — Upload resumes with on-device OCR fallback for scanned PDFs
- **ATS Keyword Matching** — Aligns skills and wording with the job posting
- **Compare Diff** — Review original vs optimized changes side by side
- **History** — Save and reopen past optimizations locally
- **PDF Export** — Export the optimized resume as a multi-page PDF
- **Android + iOS** — Cross-platform with RT AI branding and splash screen

---

## Tech Stack

- **Framework** — Flutter / Dart
- **AI Model** — LLaMA 3.3 70B via Groq Cloud API
- **HTTP** — `http`
- **Environment** — `flutter_dotenv`
- **PDF Export** — `pdf` + `printing`
- **OCR** — Google ML Kit (on-device)
- **History** — `shared_preferences`

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- Groq API Key — free at [console.groq.com](https://console.groq.com)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/phyowaikyaw-mobiledev/resume_tailor_ai.git
   cd resume_tailor_ai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create `.env` file** in the project root
   ```
   GROQ_API_KEY=your_groq_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── models/
│   └── optimization_record.dart
├── screens/
│   ├── splash_screen.dart
│   ├── home_screen.dart
│   ├── input_screen.dart
│   ├── result_screen.dart
│   └── history_screen.dart
├── services/
│   ├── groq_service.dart
│   ├── resume_parser_service.dart
│   ├── pdf_ocr_service.dart
│   ├── pdf_export_service.dart
│   ├── diff_service.dart
│   ├── history_service.dart
│   └── resume_formatter.dart
└── widgets/
    ├── primary_button.dart
    ├── app_text_field.dart
    ├── app_card.dart
    └── action_chip_button.dart
```

---

## How It Works

1. Upload a PDF/DOCX resume (or paste text)
2. Paste the job description for the role you want
3. Tap **Optimize with AI**
4. Review **Optimized**, **Compare**, and **Original** tabs
5. Copy the text or export as PDF

---

## Environment Variables

| Variable | Description |
|----------|-------------|
| `GROQ_API_KEY` | Your Groq Cloud API key (free at console.groq.com) |

---

## License

MIT License — feel free to use this project for learning and portfolio purposes.

---

<p align="center">Built with Flutter & Groq AI</p>
