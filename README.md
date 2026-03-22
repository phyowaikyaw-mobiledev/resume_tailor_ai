# ResumeTailor AI 🚀

An AI-powered resume optimization app built with Flutter that helps job seekers tailor their resumes for ATS (Applicant Tracking Systems) by matching keywords from job descriptions.

---

## 📱 Screenshots

| Home | Input | Result | Result |
|------|-------|--------|--------|
| ![Home Screen](screenshots/home.png) | ![Input Screen](screenshots/input.png) | ![Input Screen](screenshots/optimize.png) | ![Result Screen](screenshots/result.png) |

---

## ✨ Features

- **AI-Powered Optimization** — Uses Groq AI (LLaMA 3.3 70B) to intelligently optimize your resume
- **ATS-Friendly** — Matches keywords from job descriptions to increase ATS pass rate
- **Real-time Processing** — Get optimized results in under 30 seconds
- **Copy to Clipboard** — Instantly copy your optimized resume
- **Dark Premium UI** — Clean, modern interface designed for portfolio showcase

---

## 🛠️ Tech Stack

- **Framework** — Flutter / Dart
- **AI Model** — LLaMA 3.3 70B via Groq Cloud API
- **HTTP** — `http` package
- **Environment** — `flutter_dotenv`
- **PDF Export** — `pdf` + `printing` packages

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.8.1`
- Groq API Key — Get one free at [console.groq.com](https://console.groq.com)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/resumetailorai.git
   cd resumetailorai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Create `.env` file** in the root directory
   ```
   GROQ_API_KEY=your_groq_api_key_here
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📁 Project Structure

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart
├── screens/
│   ├── home_screen.dart
│   ├── input_screen.dart
│   └── result_screen.dart
├── services/
│   └── groq_service.dart
└── widgets/
    └── glow_text_field.dart
```

---

## ⚙️ How It Works

1. Paste your current resume text
2. Paste the job description you're applying for
3. Hit **Optimize with AI**
4. Get an ATS-optimized resume with matched keywords in seconds

---

## 🔑 Environment Variables

| Variable | Description |
|----------|-------------|
| `GROQ_API_KEY` | Your Groq Cloud API key (free at console.groq.com) |

---

## 📄 License

MIT License — feel free to use this project for learning and portfolio purposes.

---

<p align="center">Built with ❤️ using Flutter & Groq AI</p>
