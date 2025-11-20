import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_calo_app/test_screen.dart';
import 'localization/providers/locale_provider.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(locale),
      home: const TestScreen(),
    );
  }
}
