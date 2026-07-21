import 'package:diff_match_patch/diff_match_patch.dart';

enum DiffSegmentType { equal, insert, delete }

class DiffSegment {
  final DiffSegmentType type;
  final String text;

  const DiffSegment({required this.type, required this.text});
}

class DiffService {
  List<DiffSegment> compare(String original, String optimized) {
    final dmp = DiffMatchPatch();
    final diffs = dmp.diff(original, optimized);
    dmp.diffCleanupSemantic(diffs);

    return diffs.map((diff) {
      final type = switch (diff.operation) {
        DIFF_INSERT => DiffSegmentType.insert,
        DIFF_DELETE => DiffSegmentType.delete,
        DIFF_EQUAL => DiffSegmentType.equal,
        _ => DiffSegmentType.equal,
      };
      return DiffSegment(type: type, text: diff.text);
    }).where((segment) => segment.text.isNotEmpty).toList();
  }
}
