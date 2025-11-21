import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class BirthYearPage extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const BirthYearPage({required this.onNext, required this.onBack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    final int currentYear = DateTime.now().year;
    final int minYear = currentYear - 100;
    final int maxYear = currentYear - 5;
    final birthYear = profile?.birthYear ?? 2000;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("Chọn năm sinh"),
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 50,
                    scrollController: FixedExtentScrollController(
                      initialItem: birthYear - minYear,
                    ),
                    onSelectedItemChanged: (index) {
                      notifier.updateBirthYear(minYear + index);
                    },
                    children: List.generate(
                      maxYear - minYear + 1,
                      (i) => Text("${minYear + i}"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  color: CupertinoColors.systemGrey,
                  onPressed: onBack,
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
                CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  onPressed: () async {
                    if (profile?.birthYear == null) {
                      await notifier.updateBirthYear(birthYear);
                    }
                    onNext();
                  },
                  child: const Text(
                    "Tiếp tục",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
