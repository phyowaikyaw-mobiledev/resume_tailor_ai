class ResumeSection {
  final String title;
  final String content;

  const ResumeSection({required this.title, required this.content});
}

class ResumeFormatter {
  static const _headers = [
    'CONTACT',
    'SUMMARY',
    'PROFESSIONAL SUMMARY',
    'OBJECTIVE',
    'EXPERIENCE',
    'WORK EXPERIENCE',
    'EMPLOYMENT',
    'SKILLS',
    'TECHNICAL SKILLS',
    'EDUCATION',
    'CERTIFICATIONS',
    'PROJECTS',
    'AWARDS',
  ];

  static List<ResumeSection> parseSections(String text) {
    final lines = text.split('\n');
    final sections = <ResumeSection>[];
    String? currentTitle;
    final buffer = <String>[];

    void flush() {
      if (currentTitle != null || buffer.isNotEmpty) {
        sections.add(
          ResumeSection(
            title: currentTitle ?? 'RESUME',
            content: buffer.join('\n').trim(),
          ),
        );
      }
      buffer.clear();
    }

    for (final line in lines) {
      final trimmed = line.trim();
      final upper = trimmed.replaceAll(':', '').toUpperCase();

      if (_headers.contains(upper) && trimmed.length < 40) {
        flush();
        currentTitle = upper;
        continue;
      }

      buffer.add(line);
    }

    flush();

    if (sections.length == 1 && sections.first.title == 'RESUME') {
      return sections;
    }

    return sections.where((s) => s.content.isNotEmpty).toList();
  }
}
