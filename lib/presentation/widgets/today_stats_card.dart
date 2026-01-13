import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/anger_provider.dart';

/// 今日统计卡片
class TodayStatsCard extends StatelessWidget {
  const TodayStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AngerProvider>(
      builder: (context, provider, child) {
        final todayRecords = provider.getTodayRecords();
        final recordCount = todayRecords.length;
        final avgScore = provider.getAverageScore(todayRecords);
        final maxScore = provider.getMaxScore(todayRecords);
        
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '今日统计',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: '记录次数',
                      value: '$recordCount',
                      icon: Icons.edit,
                      color: Colors.blue,
                    ),
                    _StatItem(
                      label: '平均分',
                      value: avgScore > 0 ? avgScore.toStringAsFixed(1) : '-',
                      icon: Icons.analytics,
                      color: recordCount > 0 
                        ? AppTheme.getScoreColor(avgScore.round())
                        : Colors.grey,
                    ),
                    _StatItem(
                      label: '最高分',
                      value: maxScore > 0 ? '$maxScore' : '-',
                      icon: Icons.arrow_upward,
                      color: maxScore > 0 
                        ? AppTheme.getScoreColor(maxScore)
                        : Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
