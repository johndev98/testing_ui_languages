import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/providers/locale_provider.dart';
import 'test_screen.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(locale),
      home: const TestScreen(),
    );
  }
}
