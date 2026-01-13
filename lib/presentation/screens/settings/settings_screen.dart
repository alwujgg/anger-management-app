import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../providers/anger_provider.dart';

/// 设置页面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('数据管理'),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('导出数据'),
            subtitle: const Text('将数据导出为JSON文件'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('清除所有数据'),
            subtitle: const Text('此操作不可恢复'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _confirmClearData(context),
          ),
          
          const Divider(),
          
          _buildSectionHeader('隐私与安全'),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('隐私政策'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showPrivacyPolicy(context),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('数据安全'),
            subtitle: const Text('所有数据仅存储在本地设备'),
          ),
          
          const Divider(),
          
          _buildSectionHeader('关于'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('关于应用'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(context),
          ),
          const ListTile(
            leading: Icon(Icons.phone_android),
            title: Text('版本'),
            subtitle: Text('1.0.0 (MVP)'),
          ),
          
          const SizedBox(height: 32),
          
          // 底部版权信息
          Center(
            child: Text(
              '© 2026 愤怒管理应用\n由 苏旺(80344002) 开发',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
  
  Future<void> _exportData(BuildContext context) async {
    try {
      final provider = context.read<AngerProvider>();
      final records = provider.records;
      
      if (records.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('暂无数据可导出')),
        );
        return;
      }
      
      // 转换为JSON
      final jsonData = jsonEncode(
        records.map((r) => r.toJson()).toList(),
      );
      
      // 保存到文件
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/anger_records_export.json');
      await file.writeAsString(jsonData);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('数据已导出到：${file.path}'),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: '确定',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('导出失败：$e')),
        );
      }
    }
  }
  
  Future<void> _confirmClearData(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认清除'),
        content: const Text(
          '确定要删除所有数据吗？\n\n此操作不可恢复，请谨慎操作。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('确认清除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true && context.mounted) {
      final provider = context.read<AngerProvider>();
      final success = await provider.clearAllData();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? '所有数据已清除' : '清除失败'),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
  
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '我们重视您的隐私',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('✅ 所有数据默认存储在您的设备本地'),
              SizedBox(height: 8),
              Text('✅ 不收集任何身份信息'),
              SizedBox(height: 8),
              Text('✅ 不进行数据上传（除非您主动选择云同步）'),
              SizedBox(height: 8),
              Text('✅ 您可随时删除所有数据'),
              SizedBox(height: 8),
              Text('✅ 不包含任何第三方广告跟踪'),
              SizedBox(height: 12),
              Text(
                '数据安全',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text('• 本地数据存储采用加密技术'),
              SizedBox(height: 8),
              Text('• 应用不会请求不必要的系统权限'),
              SizedBox(height: 8),
              Text('• 数据导出功能完全由用户控制'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
  
  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: '愤怒管理',
      applicationVersion: '1.0.0 (MVP)',
      applicationIcon: const Icon(Icons.mood, size: 48, color: Colors.blue),
      children: [
        const SizedBox(height: 16),
        const Text(
          '这是一款基于心理学原理的情绪管理应用，帮助您：',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('• 科学地记录和评估愤怒情绪'),
        const Text('• 通过数据可视化了解情绪模式'),
        const Text('• 使用呼吸练习等工具缓解情绪'),
        const Text('• 保护您的隐私和数据安全'),
        const SizedBox(height: 16),
        const Text(
          '开发者：苏旺(80344002)',
          style: TextStyle(color: Colors.grey),
        ),
        const Text(
          '创建时间：2026年1月',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
