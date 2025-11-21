import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class DietPage extends ConsumerWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final VoidCallback jumpToGoal; // Jump back to GoalPage for maintain flow
  const DietPage({
    required this.onFinish,
    required this.onBack,
    required this.jumpToGoal,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                CupertinoButton(
                  color: profile?.diet == 'eat_clean'
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text('Eat Clean'),
                  onPressed: () => notifier.updateDiet('eat_clean'),
                ),
                CupertinoButton(
                  color: profile?.diet == 'keto'
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text('Keto'),
                  onPressed: () => notifier.updateDiet('keto'),
                ),
                CupertinoButton(
                  color: profile?.diet == 'low_carb'
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text('Low Carb'),
                  onPressed: () => notifier.updateDiet('low_carb'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoButton(
                  color: CupertinoColors.systemGrey,
                  onPressed: () {
                    // If goal is maintain, jump back to GoalPage (skip SpeedPage)
                    if (profile?.goal == 'maintain') {
                      jumpToGoal();
                    } else {
                      onBack();
                    }
                  },
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                ),
                CupertinoButton(
                  color: profile?.diet != null
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  onPressed: profile?.diet != null ? onFinish : null,
                  child: const Text(
                    "Hoàn tất",
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
