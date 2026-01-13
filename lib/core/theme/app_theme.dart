import 'package:flutter/material.dart';

/// 应用主题配置
class AppTheme {
  // 主色调 - 冷静蓝
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF7ED321);
  
  // 评分颜色
  static const Color scoreGreen = Color(0xFF7ED321);    // 1-3分
  static const Color scoreYellow = Color(0xFFF5A623);   // 4-5分
  static const Color scoreOrange = Color(0xFFFF9500);   // 6-7分
  static const Color scoreRed = Color(0xFFE74C3C);      // 8-10分
  
  // 中性色
  static const Color neutralGrey = Color(0xFF9B9B9B);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF333333);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      
      // AppBar主题
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: darkGrey,
        titleTextStyle: TextStyle(
          color: darkGrey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // 卡片主题
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      
      // 文本主题
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkGrey,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkGrey,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkGrey,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: darkGrey,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: neutralGrey,
        ),
      ),
      
      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: lightGrey,
      ),
    );
  }
  
  /// 根据评分获取颜色
  static Color getScoreColor(int score) {
    if (score <= 3) return scoreGreen;
    if (score <= 5) return scoreYellow;
    if (score <= 7) return scoreOrange;
    return scoreRed;
  }
  
  /// 根据评分获取描述
  static String getScoreDescription(int score) {
    if (score <= 3) return '心情平静';
    if (score <= 5) return '略有不适';
    if (score <= 7) return '明显愤怒';
    return '极度愤怒';
  }
  
  /// 根据评分获取表情
  static String getScoreEmoji(int score) {
    const emojis = {
      1: '😊', 2: '🙂', 3: '😐', 4: '😕', 5: '😟',
      6: '😠', 7: '😡', 8: '🤬', 9: '😤', 10: '💢'
    };
    return emojis[score] ?? '😐';
  }
}
