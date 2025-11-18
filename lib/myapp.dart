import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/localization.dart';
import 'test_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMap = ref.watch(localizationMapProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: asyncMap.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, st) => Scaffold(body: Center(child: Text('Error: $err'))),
        data: (_) => const TestScreen(), // khi load xong thì vào màn hình chính
      ),
    );
  }
}
