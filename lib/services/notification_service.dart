import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 本地通知服务
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  
  /// 初始化通知服务
  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _plugin.initialize(initSettings);
  }
  
  /// 显示预警通知
  static Future<void> showWarning({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'anger_warning',
      '愤怒预警',
      channelDescription: '当检测到高强度愤怒时发送通知',
      importance: Importance.high,
      priority: Priority.high,
      ticker: '愤怒预警',
    );
    
    const details = NotificationDetails(android: androidDetails);
    
    await _plugin.show(
      0,
      title,
      body,
      details,
    );
  }
}
