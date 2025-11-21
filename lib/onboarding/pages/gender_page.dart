import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class GenderPage extends ConsumerWidget {
  final VoidCallback onNext;
  const GenderPage({required this.onNext, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 250,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 10),
                borderRadius: BorderRadius.circular(20),
                color: profile?.gender == 'male' ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                child: const Text('Nam', style: TextStyle(color: CupertinoColors.white, fontSize: 22)),
                onPressed: () => notifier.updateGender('male'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 250,
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 10),
                borderRadius: BorderRadius.circular(20),
                color: profile?.gender == 'female' ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
                child: const Text('Nữ', style: TextStyle(color: CupertinoColors.white, fontSize: 22)),
                onPressed: () => notifier.updateGender('female'),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: 250,
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(20),
              color: profile?.gender != null ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray,
              onPressed: profile?.gender != null ? onNext : null,
              child: const Text('Tiếp tục', style: TextStyle(color: CupertinoColors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
