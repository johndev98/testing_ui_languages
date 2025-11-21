import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_slider/flutter_ruler_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class WeightPage extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const WeightPage({required this.onNext, required this.onBack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    final weight = profile?.weight ?? 60.0;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterRulerSlider(
                minValue: 40,
                maxValue: 600,
                initialValue: (weight * 2).toInt(),
                width: 300,
                interval: 20,
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
                onValueChanged: (val) {
                  notifier.updateWeight(val / 2.0);
                },
              ),
              const SizedBox(height: 10),
              Text(
                "${weight.toStringAsFixed(1)} kg",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
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
                  if (profile?.weight == null) {
                    await notifier.updateWeight(weight);
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
    );
  }
}
