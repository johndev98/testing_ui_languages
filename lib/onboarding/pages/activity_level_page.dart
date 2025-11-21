import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_profile_provider.dart';

class ActivityLevelPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const ActivityLevelPage({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  ConsumerState<ActivityLevelPage> createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends ConsumerState<ActivityLevelPage> {
  int level = 1;

  final List<String> levelTitle = [
    "Ít vận động",
    "Vận động nhẹ",
    "Vận động vừa",
    "Vận động nặng",
    "Rất nặng",
  ];

  final List<String> levelDesc = [
    "Làm việc văn phòng, đi lại ít.",
    "Tập thể dục 1-3 lần/tuần.",
    "Tập luyện đều 3-5 lần/tuần.",
    "Tập nặng 6-7 lần/tuần.",
    "Tập 2 lần/ngày hoặc lao động nặng.",
  ];

  @override
  void initState() {
    super.initState();
    // Initialize level from saved profile
    final profile = ref.read(userProfileProvider);
    level = profile?.activityLevel ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Mức độ vận động"),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            Text(
              levelTitle[level],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                levelDesc[level],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),

            const Spacer(),

            CupertinoSlider(
              value: level.toDouble(),
              min: 0,
              max: 4,
              divisions: 4,
              onChanged: (v) {
                setState(() => level = v.round());
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CupertinoButton(
                    color: CupertinoColors.systemGrey,
                    onPressed: () {
                      widget.onBack();
                    },
                    child: const Text(
                      "Quay lại",
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ),
                  CupertinoButton.filled(
                    child: const Text("Tiếp tục"),
                    onPressed: () {
                      ref
                          .read(userProfileProvider.notifier)
                          .updateActivityLevel(level);
                      if (kDebugMode) {
                        print(level);
                      }
                      widget.onNext();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
