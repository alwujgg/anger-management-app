import 'package:hive/hive.dart';

part 'anger_record.g.dart';

/// 愤怒记录数据模型
@HiveType(typeId: 0)
class AngerRecord extends HiveObject {
  /// 唯一标识符
  @HiveField(0)
  late String id;
  
  /// 记录时间
  @HiveField(1)
  late DateTime timestamp;
  
  /// 愤怒强度评分 (1-10)
  @HiveField(2)
  late int intensityScore;
  
  /// 触发原因
  @HiveField(3)
  String? trigger;
  
  /// 标签列表
  @HiveField(4)
  List<String>? tags;
  
  /// 备注
  @HiveField(5)
  String? notes;
  
  AngerRecord({
    required this.id,
    required this.timestamp,
    required this.intensityScore,
    this.trigger,
    this.tags,
    this.notes,
  });
  
  /// 转换为JSON
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
  
  /// 从JSON创建
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
