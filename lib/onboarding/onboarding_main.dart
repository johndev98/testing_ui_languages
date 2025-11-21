import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/activity_level_page.dart';
import 'pages/birthyear_page.dart';
import 'pages/diet_page.dart';
import 'pages/gender_page.dart';
import 'pages/goal_page.dart';
import 'pages/height_page.dart';
import 'pages/speed_page.dart';
import 'pages/weight_page.dart';

class OnboardingMain extends ConsumerStatefulWidget {
  const OnboardingMain({super.key});

  @override
  ConsumerState<OnboardingMain> createState() => _OnboardingMainState();
}

class _OnboardingMainState extends ConsumerState<OnboardingMain> {
  final PageController _controller = PageController();

  void nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void jumpTo(int page) {
    if (_controller.hasClients) _controller.jumpToPage(page);
  }

  void finishAndOpenSummary() {
    // Navigate to summary screen using go_router
    context.go('/summary');
  }

  void resetToFirstPage() {
    if (_controller.hasClients) {
      _controller.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Onboarding')),
      child: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          GenderPage(onNext: nextPage),
          WeightPage(onNext: nextPage, onBack: previousPage),
          HeightPage(onNext: nextPage, onBack: previousPage),
          BirthYearPage(onNext: nextPage, onBack: previousPage),
          ActivityLevelPage(onNext: nextPage, onBack: previousPage),
          GoalPage(
            onNext: nextPage,
            onBack: previousPage,
            jumpToDiet: () => jumpTo(7),
          ),
          SpeedPage(onNext: nextPage, onBack: previousPage),
          DietPage(
            onFinish: finishAndOpenSummary,
            onBack: previousPage,
            jumpToGoal: () => jumpTo(5),
          ),
        ],
      ),
    );
  }
}
