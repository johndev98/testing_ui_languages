import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_slider/flutter_ruler_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class GoalPage extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback jumpToDiet; // jumpTo page index for maintain flow
  const GoalPage({
    required this.onNext,
    required this.onBack,
    required this.jumpToDiet,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    final double currentWeight = profile?.weight ?? 60.0;
    double targetWeight = profile?.targetWeight ?? currentWeight;
    String goal = profile?.goal ?? 'maintain';

    // compute min/max
    double calculatedMin = (currentWeight * 0.5).clamp(35.0, currentWeight);
    double calculatedMax = (currentWeight * 1.5).clamp(currentWeight, 250.0);
    int rulerMin = ((calculatedMin - 5).clamp(30.0, 300.0) * 2).toInt();
    int rulerMax = ((calculatedMax + 5).clamp(30.0, 300.0) * 2).toInt();

    double diff = (targetWeight - currentWeight).abs();

    String topTitle() {
      if (targetWeight == currentWeight) return "Bạn sẽ giữ cân";
      if (targetWeight < currentWeight) {
        return "Bạn sẽ giảm cân: ${diff.toStringAsFixed(1)} kg";
      }
      return "Bạn sẽ tăng cân: ${diff.toStringAsFixed(1)} kg";
    }

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                topTitle(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              FlutterRulerSlider(
                minValue: rulerMin,
                maxValue: rulerMax,
                initialValue: (targetWeight * 2).toInt(),
                width: 300,
                interval: 10,
                smallerInterval: 1,
                snapping: true,
                showLabels: false,
                tickSpacing: 15,
                ticksAlignment: TicksAlignment.center,
                labelAlignment: LabelAlignment.bottom,
                tickStyle: const TicksStyle(
                  majorHeight: 40,
                  minorHeight: 15,
                  majorThickness: 3,
                  minorThickness: 2,
                  majorColor: CupertinoColors.black,
                  minorColor: CupertinoColors.black,
                ),
                onValueChanged: (val) async {
                  final newTarget = val / 2.0;
                  await notifier.updateTargetWeight(newTarget);
                },
              ),
              const SizedBox(height: 20),
              Text(
                "${targetWeight.toStringAsFixed(1)} kg",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
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
                  // Ensure goal and targetWeight are saved
                  if (profile?.goal == null || profile?.targetWeight == null) {
                    await notifier.updateTargetWeight(targetWeight);
                    // updateTargetWeight also updates goal, but let's be sure about the goal logic
                    // actually updateTargetWeight logic:
                    // if t == current -> maintain
                    // if t < current -> lose
                    // if t > current -> gain
                    // So calling updateTargetWeight(targetWeight) is sufficient.
                  }

                  // if maintain, jump directly to diet page (index 6) as original logic
                  // Re-read goal from profile or use local variable (which matches logic)
                  // But since we just saved, profile.goal should be updated.
                  // However, updateTargetWeight is async.

                  // Let's use the local 'goal' variable which is derived from the same logic
                  if (goal == 'maintain') {
                    jumpToDiet();
                  } else {
                    onNext();
                  }
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
    );
  }
}
