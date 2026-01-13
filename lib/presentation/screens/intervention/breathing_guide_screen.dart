import 'dart:async';
import 'package:flutter/material.dart';

/// 呼吸引导页面
class BreathingGuideScreen extends StatefulWidget {
  const BreathingGuideScreen({super.key});

  @override
  State<BreathingGuideScreen> createState() => _BreathingGuideScreenState();
}

class _BreathingGuideScreenState extends State<BreathingGuideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Timer? _phaseTimer;
  int _currentPhaseIndex = 0;
  int _cycleCount = 0;
  bool _isRunning = false;
  int _countdown = 0;
  
  final List<_BreathPhase> _phases = [
    _BreathPhase('深吸气', 4, Colors.blue),
    _BreathPhase('屏住呼吸', 7, Colors.amber),
    _BreathPhase('缓慢呼气', 8, Colors.green),
  ];
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }
  
  @override
  void dispose() {
    _phaseTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPhase = _phases[_currentPhaseIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('呼吸练习'),
        actions: [
          if (_isRunning)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _stopExercise,
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 说明文字
            if (!_isRunning)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '4-7-8呼吸法',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            if (!_isRunning) const SizedBox(height: 16),
            
            if (!_isRunning)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '吸气4秒 → 屏息7秒 → 呼气8秒\n重复4个周期',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            
            const SizedBox(height: 60),
            
            // 动画圆圈
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                final size = 200 + (_animController.value * 100);
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRunning 
                      ? currentPhase.color.withOpacity(0.3)
                      : Colors.blue.withOpacity(0.1),
                    border: Border.all(
                      color: _isRunning ? currentPhase.color : Colors.blue,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _isRunning ? '$_countdown' : '开始',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _isRunning ? currentPhase.color : Colors.blue,
                      ),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 48),
            
            // 当前阶段
            if (_isRunning)
              Text(
                currentPhase.name,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: currentPhase.color,
                ),
              ),
            
            const SizedBox(height: 32),
            
            // 进度指示
            if (_isRunning)
              Text(
                '周期: $_cycleCount / 4',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            
            const SizedBox(height: 48),
            
            // 控制按钮
            if (!_isRunning)
              ElevatedButton(
                onPressed: _startExercise,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  '开始练习',
                  style: TextStyle(fontSize: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  void _startExercise() {
    setState(() {
      _isRunning = true;
      _currentPhaseIndex = 0;
      _cycleCount = 0;
    });
    _runPhase();
  }
  
  void _stopExercise() {
    _phaseTimer?.cancel();
    _animController.stop();
    setState(() {
      _isRunning = false;
      _countdown = 0;
    });
  }
  
  void _runPhase() {
    final phase = _phases[_currentPhaseIndex];
    _countdown = phase.duration;
    
    _animController.duration = Duration(seconds: phase.duration);
    _animController.forward(from: 0);
    
    // 倒计时
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      
      if (_countdown <= 0) {
        timer.cancel();
        _nextPhase();
      }
    });
  }
  
  void _nextPhase() {
    setState(() {
      _currentPhaseIndex++;
      
      if (_currentPhaseIndex >= _phases.length) {
        _currentPhaseIndex = 0;
        _cycleCount++;
        
        if (_cycleCount >= 4) {
          _completeExercise();
          return;
        }
      }
      
      _runPhase();
    });
  }
  
  void _completeExercise() {
    _phaseTimer?.cancel();
    setState(() {
      _isRunning = false;
      _countdown = 0;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 8),
            Text('完成！'),
          ],
        ),
        content: const Text(
          '太棒了！您已完成4个呼吸周期\n\n现在感觉如何？',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('结束'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startExercise();
            },
            child: const Text('再来一次'),
          ),
        ],
      ),
    );
  }
}

/// 呼吸阶段
class _BreathPhase {
  final String name;
  final int duration;
  final Color color;
  
  _BreathPhase(this.name, this.duration, this.color);
}
