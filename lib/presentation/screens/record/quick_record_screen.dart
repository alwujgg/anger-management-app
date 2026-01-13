import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/anger_record.dart';
import '../../providers/anger_provider.dart';

/// 快速评分页面
class QuickRecordScreen extends StatefulWidget {
  const QuickRecordScreen({super.key});

  @override
  State<QuickRecordScreen> createState() => _QuickRecordScreenState();
}

class _QuickRecordScreenState extends State<QuickRecordScreen> {
  int _currentScore = 5;
  final TextEditingController _triggerController = TextEditingController();
  bool _isSaving = false;
  
  @override
  void dispose() {
    _triggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('快速记录'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            
            // 情绪表情
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  AppTheme.getScoreEmoji(_currentScore),
                  key: ValueKey(_currentScore),
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 评分数字
            Center(
              child: Text(
                '$_currentScore',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getScoreColor(_currentScore),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 评分描述
            Center(
              child: Text(
                AppTheme.getScoreDescription(_currentScore),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 评分滑块
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppTheme.getScoreColor(_currentScore),
                thumbColor: AppTheme.getScoreColor(_currentScore),
                overlayColor: AppTheme.getScoreColor(_currentScore).withOpacity(0.3),
                trackHeight: 8,
              ),
              child: Slider(
                value: _currentScore.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _currentScore.toString(),
                onChanged: (value) {
                  setState(() {
                    _currentScore = value.toInt();
                  });
                  HapticFeedback.selectionClick();
                },
              ),
            ),
            
            // 刻度标签
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(10, (index) {
                  final score = index + 1;
                  return Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentScore == score 
                        ? AppTheme.getScoreColor(score)
                        : Colors.grey,
                      fontWeight: _currentScore == score 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                    ),
                  );
                }),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 触发原因输入
            TextField(
              controller: _triggerController,
              decoration: const InputDecoration(
                labelText: '是什么让你生气？（可选）',
                hintText: '例如：交通堵塞、工作压力...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
              maxLines: 3,
              maxLength: 200,
            ),
            
            const SizedBox(height: 32),
            
            // 保存按钮
            ElevatedButton(
              onPressed: _isSaving ? null : _saveRecord,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: AppTheme.getScoreColor(_currentScore),
                foregroundColor: Colors.white,
              ),
              child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    '保存',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _saveRecord() async {
    setState(() => _isSaving = true);
    
    try {
      final record = AngerRecord(
        id: const Uuid().v4(),
        timestamp: DateTime.now(),
        intensityScore: _currentScore,
        trigger: _triggerController.text.isEmpty 
          ? null 
          : _triggerController.text,
      );
      
      final provider = context.read<AngerProvider>();
      final success = await provider.addRecord(record);
      
      if (success) {
        if (mounted) {
          // 显示成功提示
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('记录成功！'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // 延迟返回，让用户看到成功提示
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('保存失败，请重试'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
