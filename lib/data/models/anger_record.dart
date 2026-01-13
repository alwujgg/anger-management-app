import 'package:hive/hive.dart';

// 移除这行：part 'anger_record.g.dart';

/// 愤怒记录数据模型
class AngerRecord extends HiveObject {
  late String id;
  late DateTime timestamp;
  late int intensityScore;
  String? trigger;
  List<String>? tags;
  String? notes;
  
  AngerRecord({
    required this.id,
    required this.timestamp,
    required this.intensityScore,
    this.trigger,
    this.tags,
    this.notes,
  });
  
  // 手动实现序列化
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'intensityScore': intensityScore,
      'trigger': trigger,
      'tags': tags,
      'notes': notes,
    };
  }
  
  factory AngerRecord.fromJson(Map<String, dynamic> json) {
    return AngerRecord(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      intensityScore: json['intensityScore'] as int,
      trigger: json['trigger'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      notes: json['notes'] as String?,
    );
  }
}
