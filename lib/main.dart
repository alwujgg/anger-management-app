import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/models/anger_record.dart';
import 'data/repositories/anger_repository_impl.dart';
import 'presentation/providers/anger_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // 设置屏幕方向为竖屏
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  // 初始化Hive数据库
  await Hive.initFlutter();
// 不再注册Adapter
// Hive.registerAdapter(AngerRecordAdapter());
//await Hive.openBox<AngerRecord>('anger_records');
  // 改用Box<dynamic>
await Hive.openBox('anger_records');
  
  // 初始化通知服务（已禁用）
  await NotificationService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AngerProvider(
            AngerRepositoryImpl(
              Hive.box<AngerRecord>('anger_records'),
            ),
          )..loadRecords(),
        ),
      ],
      child: MaterialApp(
        title: '愤怒管理',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
