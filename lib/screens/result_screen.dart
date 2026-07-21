import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/optimization_record.dart';
import '../services/diff_service.dart';
import '../services/pdf_export_service.dart';
import '../services/resume_formatter.dart';
import '../theme/app_theme.dart';
import '../widgets/action_chip_button.dart';
import '../widgets/app_card.dart';

class ResultScreen extends StatefulWidget {
  final String result;
  final String originalResume;
  final String jobDescription;

  const ResultScreen({
    super.key,
    required this.result,
    required this.originalResume,
    this.jobDescription = '',
  });

  factory ResultScreen.fromRecord(OptimizationRecord record) {
    return ResultScreen(
      result: record.optimized,
      originalResume: record.original,
      jobDescription: record.jobDescription,
    );
  }

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  bool _isExporting = false;
  late TabController _tabController;
  final _pdfExport = PdfExportService();
  final _diffService = DiffService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    final text = _tabController.index == 2
        ? widget.originalResume
        : widget.result;
    await Clipboard.setData(ClipboardData(text: text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _exportPdf() async {
    setState(() => _isExporting = true);
    try {
      await _pdfExport.exportResume(widget.result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: AppColors.surfaceElevated,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
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
              title: 'Optimized Resume',
              subtitle: 'Step 2 — Review & export',
              onBack: () => Navigator.pop(context),
            ),
            const Divider(height: 1, color: AppColors.surfaceBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ActionChipButton(
                    icon: _copied ? Icons.check_rounded : Icons.copy_rounded,
                    label: _copied ? 'Copied' : 'Copy',
                    highlighted: _copied,
                    onTap: _copyToClipboard,
                  ),
                  ActionChipButton(
                    icon: Icons.picture_as_pdf_outlined,
                    label: _isExporting ? 'Exporting...' : 'Export PDF',
                    onTap: _isExporting ? () {} : _exportPdf,
                  ),
                  ActionChipButton(
                    icon: Icons.refresh_rounded,
                    label: 'Start Over',
                    onTap: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.accent,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.accent,
              tabs: const [
                Tab(text: 'Optimized'),
                Tab(text: 'Compare'),
                Tab(text: 'Original'),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _OptimizedView(text: widget.result),
                    _CompareView(
                      segments: _diffService.compare(
                        widget.originalResume,
                        widget.result,
                      ),
                    ),
                    _PlainTextView(text: widget.originalResume),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptimizedView extends StatelessWidget {
  final String text;

  const _OptimizedView({required this.text});

  @override
  Widget build(BuildContext context) {
    final sections = ResumeFormatter.parseSections(text);

    if (sections.length <= 1 && sections.first.title == 'RESUME') {
      return _PlainTextView(text: text);
    }

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        itemCount: sections.length,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: AppColors.surfaceBorder),
        ),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(
                section.content,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlainTextView extends StatelessWidget {
  final String text;

  const _PlainTextView({required this.text});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: SelectableText(
          text,
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ),
    );
  }
}

class _CompareView extends StatelessWidget {
  final List<DiffSegment> segments;

  const _CompareView({required this.segments});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: SelectableText.rich(
          TextSpan(
            children: segments.map((segment) {
              return TextSpan(
                text: segment.text,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.7,
                  color: switch (segment.type) {
                    DiffSegmentType.insert => AppColors.success,
                    DiffSegmentType.delete => AppColors.textMuted,
                    DiffSegmentType.equal => AppColors.textSecondary,
                  },
                  decoration: segment.type == DiffSegmentType.delete
                      ? TextDecoration.lineThrough
                      : null,
                  fontWeight: segment.type == DiffSegmentType.insert
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
