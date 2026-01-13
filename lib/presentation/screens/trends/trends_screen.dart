import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/anger_provider.dart';

/// 趋势页面
class TrendsScreen extends StatelessWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('情绪趋势'),
      ),
      body: Consumer<AngerProvider>(
        builder: (context, provider, child) {
          if (provider.records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无数据\n开始记录后即可查看趋势',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          
          final recentRecords = provider.getRecentRecords(7);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 7天趋势图
                _TrendChart(records: recentRecords),
                
                const SizedBox(height: 24),
                
                // 统计摘要
                _StatsSummary(records: recentRecords),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 趋势图表
class _TrendChart extends StatelessWidget {
  final List records;
  
  const _TrendChart({required this.records});

  @override
  Widget build(BuildContext context) {
    final chartData = _prepareChartData();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7天愤怒值趋势',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = DateTime.now().subtract(
                            Duration(days: 6 - value.toInt()),
                          );
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '评分: ${spot.y.toStringAsFixed(1)}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        ),
      ),
    );
  }
  
  List<FlSpot> _prepareChartData() {
    final now = DateTime.now();
    final spots = <FlSpot>[];
    
    for (int i = 0; i < 7; i++) {
      final targetDate = DateTime(
        now.year,
        now.month,
        now.day - (6 - i),
      );
      
      final dayRecords = records.where((r) {
        final recordDate = DateTime(
          r.timestamp.year,
          r.timestamp.month,
          r.timestamp.day,
        );
        return recordDate.year == targetDate.year &&
               recordDate.month == targetDate.month &&
               recordDate.day == targetDate.day;
      }).toList();
      
      final avgScore = dayRecords.isEmpty
        ? 0.0
        : dayRecords.map((r) => r.intensityScore).reduce((a, b) => a + b) / dayRecords.length;
      
      spots.add(FlSpot(i.toDouble(), avgScore));
    }
    
    return spots;
  }
  
  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _LegendItem(color: AppTheme.scoreGreen, label: '平静(1-3)'),
        _LegendItem(color: AppTheme.scoreYellow, label: '不适(4-5)'),
        _LegendItem(color: AppTheme.scoreOrange, label: '愤怒(6-7)'),
        _LegendItem(color: AppTheme.scoreRed, label: '极怒(8-10)'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}

/// 统计摘要
class _StatsSummary extends StatelessWidget {
  final List records;
  
  const _StatsSummary({required this.records});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AngerProvider>();
    final avgScore = provider.getAverageScore(records);
    final maxScore = provider.getMaxScore(records);
    final recordCount = records.length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '7天统计摘要',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _SummaryItem(
              icon: Icons.edit,
              label: '记录次数',
              value: '$recordCount 次',
              color: Colors.blue,
            ),
            const Divider(height: 24),
            _SummaryItem(
              icon: Icons.analytics,
              label: '平均愤怒值',
              value: avgScore > 0 ? avgScore.toStringAsFixed(1) : '-',
              color: avgScore > 0 ? AppTheme.getScoreColor(avgScore.round()) : Colors.grey,
            ),
            const Divider(height: 24),
            _SummaryItem(
              icon: Icons.arrow_upward,
              label: '最高愤怒值',
              value: maxScore > 0 ? '$maxScore' : '-',
              color: maxScore > 0 ? AppTheme.getScoreColor(maxScore) : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
