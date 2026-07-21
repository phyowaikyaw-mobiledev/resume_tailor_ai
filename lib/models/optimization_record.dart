class OptimizationRecord {
  final String id;
  final DateTime createdAt;
  final String jobSnippet;
  final String jobDescription;
  final String original;
  final String optimized;

  const OptimizationRecord({
    required this.id,
    required this.createdAt,
    required this.jobSnippet,
    required this.jobDescription,
    required this.original,
    required this.optimized,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'jobSnippet': jobSnippet,
        'jobDescription': jobDescription,
        'original': original,
        'optimized': optimized,
      };

  factory OptimizationRecord.fromJson(Map<String, dynamic> json) {
    return OptimizationRecord(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      jobSnippet: json['jobSnippet'] as String,
      jobDescription: json['jobDescription'] as String? ?? '',
      original: json['original'] as String,
      optimized: json['optimized'] as String,
    );
  }
}
