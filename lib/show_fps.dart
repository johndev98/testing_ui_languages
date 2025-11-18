import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

class FpsMonitor extends StatefulWidget {
  const FpsMonitor({super.key});

  @override
  State<FpsMonitor> createState() => _FpsMonitorState();
}

class _FpsMonitorState extends State<FpsMonitor>
    with SingleTickerProviderStateMixin {
  int _frames = 0;
  double _fps = 0;
  late Ticker _ticker;
  late DateTime _lastTime;

  @override
  void initState() {
    super.initState();
    _lastTime = DateTime.now();
    _ticker = createTicker((_) {
      _frames++;
      final now = DateTime.now();
      final diff = now.difference(_lastTime).inMilliseconds;
      if (diff >= 1000) {
        setState(() {
          _fps = _frames * 1000 / diff;
          _frames = 0;
          _lastTime = now;
        });
      }
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'FPS: ${_fps.toStringAsFixed(1)}',
      style: const TextStyle(color: Colors.red, fontSize: 16),
    );
  }
}
