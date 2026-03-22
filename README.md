\# ResumeTailor AI 🚀



An AI-powered resume optimization app built with Flutter that helps job seekers tailor their resumes for ATS (Applicant Tracking Systems) by matching keywords from job descriptions.



\---



\## 📱 Screenshots



| Home | Input | Result | Result |

|------|-------|--------|--------|

| !\[Home Screen](screenshots/home.png) | !\[Input Screen](screenshots/input.png) | !\[Input Screen](screenshots/optimize.png) | !\[Result Screen](screenshots/result.png) |



\---



\## ✨ Features



\- \*\*AI-Powered Optimization\*\* — Uses Groq AI (LLaMA 3.3 70B) to intelligently optimize your resume

\- \*\*ATS-Friendly\*\* — Matches keywords from job descriptions to increase ATS pass rate

\- \*\*Real-time Processing\*\* — Get optimized results in under 30 seconds

\- \*\*Copy to Clipboard\*\* — Instantly copy your optimized resume

\- \*\*Dark Premium UI\*\* — Clean, modern interface designed for portfolio showcase



\---



\## 🛠️ Tech Stack



\- \*\*Framework\*\* — Flutter / Dart

\- \*\*AI Model\*\* — LLaMA 3.3 70B via Groq Cloud API

\- \*\*HTTP\*\* — `http` package

\- \*\*Environment\*\* — `flutter\_dotenv`

\- \*\*PDF Export\*\* — `pdf` + `printing` packages



\---



\## 🚀 Getting Started



\### Prerequisites



\- Flutter SDK `^3.8.1`

\- Groq API Key — Get one free at \[console.groq.com](https://console.groq.com)



\### Installation



1\. \*\*Clone the repository\*\*

&#x20;  ```bash

&#x20;  git clone https://github.com/yourusername/resumetailorai.git

&#x20;  cd resumetailorai

&#x20;  ```



2\. \*\*Install dependencies\*\*

&#x20;  ```bash

&#x20;  flutter pub get

&#x20;  ```



3\. \*\*Create `.env` file\*\* in the root directory

&#x20;  ```

&#x20;  GROQ\_API\_KEY=your\_groq\_api\_key\_here

&#x20;  ```



4\. \*\*Run the app\*\*

&#x20;  ```bash

&#x20;  flutter run

&#x20;  ```



\---



\## 📁 Project Structure



```

lib/

├── main.dart

├── theme/

│   └── app\_theme.dart

├── screens/

│   ├── home\_screen.dart

│   ├── input\_screen.dart

│   └── result\_screen.dart

├── services/

│   └── groq\_service.dart

└── widgets/

&#x20;   └── glow\_text\_field.dart

```



\---



\## ⚙️ How It Works



1\. Paste your current resume text

2\. Paste the job description you're applying for

3\. Hit \*\*Optimize with AI\*\*

4\. Get an ATS-optimized resume with matched keywords in seconds



\---



\## 🔑 Environment Variables



| Variable | Description |

|----------|-------------|

| `GROQ\_API\_KEY` | Your Groq Cloud API key (free at console.groq.com) |



\---



\## 📄 License



MIT License — feel free to use this project for learning and portfolio purposes.



\---



<p align="center">Built with ❤️ using Flutter \& Groq AI</p>

