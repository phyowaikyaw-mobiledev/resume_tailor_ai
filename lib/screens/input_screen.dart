import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../services/groq_service.dart';
import '../services/history_service.dart';
import '../services/resume_parser_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _resumeController = TextEditingController();
  final _jobController = TextEditingController();
  final _parser = ResumeParserService();
  final _historyService = HistoryService();

  bool _isOptimizing = false;
  bool _isParsing = false;
  String? _uploadedFileName;

  @override
  void dispose() {
    _resumeController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ResumeParserService.supportedExtensions,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    setState(() {
      _isParsing = true;
      _uploadedFileName = file.name;
    });

    try {
      final text = await _parser.parseFile(file);
      if (mounted) {
        _resumeController.text = text;
        setState(() => _isParsing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imported ${file.name} (${text.length} characters)'),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isParsing = false;
          _uploadedFileName = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    }
  }

  void _clearUpload() {
    setState(() {
      _uploadedFileName = null;
      _resumeController.clear();
    });
  }

  Future<void> _optimizeResume() async {
    if (_resumeController.text.trim().isEmpty ||
        _jobController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a resume and job description.'),
          backgroundColor: AppColors.surfaceElevated,
        ),
      );
      return;
    }

    setState(() => _isOptimizing = true);

    try {
      final original = _resumeController.text.trim();
      final job = _jobController.text.trim();
      final result = await GroqService().optimizeResume(original, job);
      if (!mounted) return;
      await _historyService.save(
        jobDescription: job,
        original: original,
        optimized: result,
      );
      if (!mounted) return;
      setState(() => _isOptimizing = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
            originalResume: original,
            jobDescription: job,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isOptimizing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Optimize Resume',
              subtitle: 'Step 1 — Upload & describe the role',
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1, color: AppColors.surfaceBorder),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Resume',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_uploadedFileName != null) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 18,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _uploadedFileName!,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _isParsing ? null : _clearUpload,
                                  icon: const Icon(Icons.close, size: 18),
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (_isParsing)
                            const Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Extracting text from file...'),
                              ],
                            )
                          else
                            SecondaryButton(
                              label: _uploadedFileName == null
                                  ? 'Upload PDF or DOCX'
                                  : 'Replace file',
                              icon: Icons.upload_file_outlined,
                              onPressed: _pickResume,
                            ),
                          if (_resumeController.text.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              '${_resumeController.text.length} characters extracted',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _resumeController,
                      label: 'Resume text',
                      hint:
                          'Upload a file above, or paste your resume text here...',
                      icon: Icons.description_outlined,
                      maxLines: 8,
                    ),
                    const SizedBox(height: 24),
                    AppTextField(
                      controller: _jobController,
                      label: 'Job description',
                      hint: 'Paste the full job posting for best results...',
                      icon: Icons.work_outline_rounded,
                      maxLines: 7,
                    ),
                    const SizedBox(height: 16),
                    AppCard(
                      backgroundColor: AppColors.surfaceElevated,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Include the complete job description so the AI can match relevant keywords.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: PrimaryButton(
                label: 'Optimize with AI',
                icon: Icons.auto_fix_high_outlined,
                isLoading: _isOptimizing,
                onPressed: _isOptimizing || _isParsing ? null : _optimizeResume,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
