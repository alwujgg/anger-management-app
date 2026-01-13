import 'package:flutter/material.dart';
import 'breathing_guide_screen.dart';

/// 干预工具页面
class InterventionScreen extends StatelessWidget {
  const InterventionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('缓解工具'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '选择一种方式来缓解愤怒情绪',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          
          // 呼吸引导卡片
          _InterventionCard(
            title: '呼吸练习',
            description: '通过呼吸调节来平复情绪',
            icon: Icons.air,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BreathingGuideScreen(),
                ),
              );
            },
          ),
          
          // 冥想练习（待开发）
          _InterventionCard(
            title: '正念冥想',
            description: '通过冥想放松身心（即将推出）',
            icon: Icons.spa,
            color: Colors.green,
            enabled: false,
            onTap: () {},
          ),
          
          // 小游戏（待开发）
          _InterventionCard(
            title: '放松游戏',
            description: '通过简单游戏转移注意力（即将推出）',
            icon: Icons.sports_esports,
            color: Colors.orange,
            enabled: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

/// 干预工具卡片
class _InterventionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;
  
  const _InterventionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.enabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: enabled ? color.withOpacity(0.2) : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: enabled ? color : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: enabled ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: enabled ? Colors.grey : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
