import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_slider/flutter_ruler_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class HeightPage extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const HeightPage({required this.onNext, required this.onBack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    final height = profile?.height ?? 170;

    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: FlutterRulerSlider(
                  minValue: 100,
                  maxValue: 220,
                  initialValue: height,
                  width: 300,
                  interval: 10,
                  smallerInterval: 1,
                  snapping: true,
                  showLabels: false,
                  tickSpacing: 20,
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
                  onValueChanged: (val) => notifier.updateHeight(val.toInt()),
                ),
              ),
              const SizedBox(height: 10),
              Text("$height cm", style: const TextStyle(fontSize: 18)),
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
                  if (profile?.height == null) {
                    await notifier.updateHeight(height);
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
