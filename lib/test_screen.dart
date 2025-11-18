import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization/localization_extension.dart';
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
          child: Text(ref.loc.translate('genders.male')),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text(ref.loc.translate('genders.female')),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {},
          child: Text(ref.loc.translate('genders.other')),
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
            child: LanguageSwitch(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ref.loc.translate('genders.language')),
            GenderButtons(),
          ],
        ),
      ),
    );
  }
}
