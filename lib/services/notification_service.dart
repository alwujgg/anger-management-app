import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 本地通知服务
class NotificationService {
  
  /// 初始化通知服务
  static Future<void> initialize() async {
    // 暂时禁用通知功能
    print('通知服务已禁用');
  }
  
  /// 显示预警通知
  static Future<void> showWarning({
    required String title,
    required String body,
  }) async {
    // 暂时禁用通知功能
    print('预警通知: $title - $body');
  }
}
