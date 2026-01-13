import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/anger_provider.dart';
import '../../widgets/today_stats_card.dart';
import '../../widgets/recent_records_list.dart';
import '../record/quick_record_screen.dart';
import '../trends/trends_screen.dart';
import '../intervention/intervention_screen.dart';
import '../settings/settings_screen.dart';

/// 主页
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const _HomePage(),
    const TrendsScreen(),
    const InterventionScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: '趋势',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: '工具',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }
}

/// 首页内容
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('愤怒管理'),
      ),
      body: Column(
        children: [
          // 今日统计卡片
          const TodayStatsCard(),
          
          const SizedBox(height: 16),
          
          // 快速记录按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () => _navigateToQuickRecord(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, size: 28),
                  SizedBox(width: 12),
                  Text(
                    '快速记录情绪',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 最近记录列表
          Expanded(
            child: Consumer<AngerProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mood,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '还没有记录\n点击上方按钮开始记录吧',
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
                
                return const RecentRecordsList();
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _navigateToQuickRecord(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuickRecordScreen(),
      ),
    );
    
    if (result == true) {
      // 记录成功，刷新列表
      if (context.mounted) {
        context.read<AngerProvider>().loadRecords();
      }
    }
  }
}
