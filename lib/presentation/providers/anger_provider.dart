import 'package:flutter/foundation.dart';
import '../../data/models/anger_record.dart';
import '../../data/repositories/anger_repository_impl.dart';
import '../../services/notification_service.dart';

/// 愤怒记录状态管理
class AngerProvider extends ChangeNotifier {
  final AngerRepositoryImpl _repository;
  
  List<AngerRecord> _records = [];
  bool _isLoading = false;
  String? _error;
  
  AngerProvider(this._repository);
  
  // Getters
  List<AngerRecord> get records => _records;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  /// 加载所有记录
  Future<void> loadRecords() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _records = await _repository.getRecords();
      _records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _error = '加载失败: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// 添加记录
  Future<bool> addRecord(AngerRecord record) async {
    try {
      await _repository.saveRecord(record);
      _records.insert(0, record);
      notifyListeners();
      
      // 检查是否需要预警
      _checkWarning(record.intensityScore);
      
      return true;
    } catch (e) {
      _error = '保存失败: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// 删除记录
  Future<bool> deleteRecord(String id) async {
    try {
      await _repository.deleteRecord(id);
      _records.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = '删除失败: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// 清除所有数据
  Future<bool> clearAllData() async {
    try {
      await _repository.clearAll();
      _records.clear();
      notifyListeners();
      return true;
    } catch (e) {
      _error = '清除失败: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }
  
  /// 获取最近N天的记录
  List<AngerRecord> getRecentRecords(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _records.where((r) => r.timestamp.isAfter(cutoff)).toList();
  }
  
  /// 获取今日记录
  List<AngerRecord> getTodayRecords() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _records.where((r) => 
      r.timestamp.isAfter(today) && r.timestamp.isBefore(tomorrow)
    ).toList();
  }
  
  /// 计算平均分
  double getAverageScore(List<AngerRecord> records) {
    if (records.isEmpty) return 0.0;
    final total = records.fold<int>(0, (sum, r) => sum + r.intensityScore);
    return total / records.length;
  }
  
  /// 获取最高分
  int getMaxScore(List<AngerRecord> records) {
    if (records.isEmpty) return 0;
    return records.map((r) => r.intensityScore).reduce((a, b) => a > b ? a : b);
  }
  
  /// 检查预警
  void _checkWarning(int score) {
    if (score >= 8) {
      NotificationService.showWarning(
        title: '检测到高强度愤怒',
        body: '建议尝试呼吸练习来缓解情绪',
      );
    }
  }
}
