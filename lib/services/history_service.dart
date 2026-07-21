import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/optimization_record.dart';

class HistoryService {
  static const _storageKey = 'optimization_history';
  static const _maxEntries = 20;

  Future<List<OptimizationRecord>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? [];
    return raw
        .map((entry) => OptimizationRecord.fromJson(
              jsonDecode(entry) as Map<String, dynamic>,
            ))
        .toList();
  }

  Future<void> save({
    required String jobDescription,
    required String original,
    required String optimized,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];

    final snippet = jobDescription.trim().length > 80
        ? '${jobDescription.trim().substring(0, 80)}...'
        : jobDescription.trim();

    final record = OptimizationRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      jobSnippet: snippet.isEmpty ? 'Untitled job' : snippet,
      jobDescription: jobDescription.trim(),
      original: original.trim(),
      optimized: optimized.trim(),
    );

    existing.insert(0, jsonEncode(record.toJson()));

    if (existing.length > _maxEntries) {
      existing.removeRange(_maxEntries, existing.length);
    }

    await prefs.setStringList(_storageKey, existing);
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_storageKey) ?? [];
    final updated = existing.where((entry) {
      final record = OptimizationRecord.fromJson(
        jsonDecode(entry) as Map<String, dynamic>,
      );
      return record.id != id;
    }).toList();
    await prefs.setStringList(_storageKey, updated);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
