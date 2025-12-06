import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/health_record.dart';

class HealthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<HealthRecord> _records = [];
  List<HealthRecord> _filteredRecords = [];
  Map<String, int> _todaySummary = {'steps': 0, 'calories': 0, 'water': 0};
  bool _isLoading = false;
  String _searchQuery = '';

  List<HealthRecord> get records =>
      _filteredRecords.isEmpty && _searchQuery.isEmpty
      ? _records
      : _filteredRecords;

  Map<String, int> get todaySummary => _todaySummary;
  bool get isLoading => _isLoading;

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await _dbHelper.getAllRecords();
      _filteredRecords = [];
      _searchQuery = '';
      await loadTodaySummary();
    } catch (e) {
      debugPrint('Error loading records: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTodaySummary() async {
    try {
      _todaySummary = await _dbHelper.getTodaySummary();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading today\'s summary: $e');
    }
  }

  Future<bool> addRecord(HealthRecord record) async {
    try {
      final id = await _dbHelper.insertRecord(record);
      if (id > 0) {
        await loadRecords();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error adding record: $e');
      return false;
    }
  }

  Future<bool> updateRecord(HealthRecord record) async {
    try {
      final result = await _dbHelper.updateRecord(record);
      if (result > 0) {
        await loadRecords();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating record: $e');
      return false;
    }
  }

  Future<bool> deleteRecord(int id) async {
    try {
      final result = await _dbHelper.deleteRecord(id);
      if (result > 0) {
        await loadRecords();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting record: $e');
      return false;
    }
  }

  void searchByDate(String date) {
    _searchQuery = date;
    if (date.isEmpty) {
      _filteredRecords = [];
    } else {
      _filteredRecords = _records.where((record) {
        return record.date.contains(date);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> filterByDateRange(DateTime startDate, DateTime endDate) async {
    _isLoading = true;
    notifyListeners();

    try {
      final start = startDate.toIso8601String().split('T')[0];
      final end = endDate.toIso8601String().split('T')[0];
      _filteredRecords = await _dbHelper.getRecordsByDateRange(start, end);
      _searchQuery = 'Range';
    } catch (e) {
      debugPrint('Error filtering by date range: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredRecords = [];
    notifyListeners();
  }

  Map<String, int> getWeeklySummary() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    int totalSteps = 0;
    int totalCalories = 0;
    int totalWater = 0;

    for (var record in _records) {
      final recordDate = DateTime.parse(record.date);
      if (recordDate.isAfter(weekAgo) &&
          recordDate.isBefore(now.add(const Duration(days: 1)))) {
        totalSteps += record.steps;
        totalCalories += record.calories;
        totalWater += record.water;
      }
    }

    return {
      'steps': totalSteps,
      'calories': totalCalories,
      'water': totalWater,
    };
  }

  Map<String, double> getAverageDaily() {
    if (_records.isEmpty) {
      return {'steps': 0.0, 'calories': 0.0, 'water': 0.0};
    }

    int totalSteps = 0;
    int totalCalories = 0;
    int totalWater = 0;

    for (var record in _records) {
      totalSteps += record.steps;
      totalCalories += record.calories;
      totalWater += record.water;
    }

    final count = _records.length;
    return {
      'steps': totalSteps / count,
      'calories': totalCalories / count,
      'water': totalWater / count,
    };
  }
}
