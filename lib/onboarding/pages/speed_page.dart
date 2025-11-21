import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class SpeedPage extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const SpeedPage({required this.onNext, required this.onBack, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);
    final speed = profile?.speed ?? 0.5;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tốc độ thay đổi cân nặng",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Text(
                "${speed.toStringAsFixed(2)} kg/tuần",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 300,
                child: CupertinoSlider(
                  min: 0.25,
                  max: 1.0,
                  divisions: 3,
                  value: speed,
                  onChanged: (value) => notifier.updateSpeed(value),
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
                  if (profile?.speed == null) {
                    await notifier.updateSpeed(speed);
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
