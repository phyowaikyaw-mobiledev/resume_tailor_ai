import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? envError;
  try {
    await dotenv.load(fileName: '.env');
    if ((dotenv.env['GROQ_API_KEY'] ?? '').isEmpty) {
      envError = 'GROQ_API_KEY is missing from your .env file.';
    }
  } catch (_) {
    envError =
        'Could not load .env file. Create one in the project root with GROQ_API_KEY=your_key';
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(ResumeTailorApp(envError: envError));
}

class ResumeTailorApp extends StatelessWidget {
  final String? envError;

  const ResumeTailorApp({super.key, this.envError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResumeTailor AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: SplashScreen(
        nextScreen: envError != null
            ? _EnvErrorScreen(message: envError!)
            : const HomeScreen(),
      ),
    );
  }
}

class _EnvErrorScreen extends StatelessWidget {
  final String message;

  const _EnvErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.settings_outlined,
                size: 48,
                color: AppColors.accent,
              ),
              const SizedBox(height: 24),
              Text(
                'Setup Required',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: const Text(
                  'GROQ_API_KEY=your_groq_api_key_here',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
