import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/localization_extension.dart';
import 'show_fps.dart';
import 'show_ram.dart';
import 'widgets/language_switch.dart';

class AppBarTitle extends ConsumerWidget {
  const AppBarTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(ref.translate('genders.title', fallback: 'Chọn giới tính'));
  }
}

class GenderButtons extends ConsumerWidget {
  const GenderButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text(ref.translate('genders.male', fallback: 'Nam')),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text(ref.translate('genders.female', fallback: 'Nữ')),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text(ref.translate('genders.other', fallback: 'Khác')),
        ),
      ],
    );
  }
}

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: LanguageDropdown(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [GenderButtons(), AppUsageWidget(), FpsMonitor()],
        ),
      ),
    );
  }
}
