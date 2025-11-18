import 'dart:io';
import 'package:flutter/material.dart';

class AppUsageWidget extends StatefulWidget {
  const AppUsageWidget({super.key});

  @override
  State<AppUsageWidget> createState() => _AppUsageWidgetState();
}

class _AppUsageWidgetState extends State<AppUsageWidget> {
  int ramUsage = 0;

  @override
  void initState() {
    super.initState();
    _updateUsage();
  }

  void _updateUsage() {
    setState(() {
      ramUsage = ProcessInfo.currentRss; // RAM app đang dùng (bytes)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('RAM used: ${(ramUsage / (1024*1024)).toStringAsFixed(2)} MB'),
        ElevatedButton(
          onPressed: _updateUsage,
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}