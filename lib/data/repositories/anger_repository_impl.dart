import 'package:hive/hive.dart';
import '../models/anger_record.dart';

/// 愤怒记录仓储实现
class AngerRepositoryImpl {
  final Box<AngerRecord> _box;
  
  AngerRepositoryImpl(this._box);
  
  /// 保存记录
  Future<void> saveRecord(AngerRecord record) async {
    await _box.put(record.id, record);
  }
  
  /// 获取所有记录
  Future<List<AngerRecord>> getRecords() async {
    return _box.values.toList();
  }
  
  /// 获取指定日期范围的记录
  Future<List<AngerRecord>> getRecordsByDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    var records = _box.values.toList();
    
    if (startDate != null) {
      records = records.where((r) => r.timestamp.isAfter(startDate)).toList();
    }
    if (endDate != null) {
      records = records.where((r) => r.timestamp.isBefore(endDate)).toList();
    }
    
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }
  
  /// 删除记录
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }
  
  /// 清除所有记录
  Future<void> clearAll() async {
    await _box.clear();
  }
  
  /// 获取记录总数
  int getRecordCount() {
    return _box.length;
  }
}
