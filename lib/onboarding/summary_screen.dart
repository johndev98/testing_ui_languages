import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/user_profile_provider.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  // Activity level is now selected in ActivityLevelPage during onboarding
  final Map<int, double> activityValues = {
    0: 1.2,
    1: 1.375,
    2: 1.55,
    3: 1.725,
    4: 1.9,
  };
  final Map<int, String> activityDescriptions = {
    0: "Ít vận động (Làm văn phòng, ngủ, xem TV)",
    1: "Vận động nhẹ (Tập 1-3 lần/tuần)",
    2: "Vận động vừa (Tập 3-5 lần/tuần)",
    3: "Vận động nặng (Tập 6-7 lần/tuần)",
    4: "Vận động rất nặng (2 lần/ngày, lao động nặng)",
  };

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    if (profile == null) {
      return const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final int age =
        DateTime.now().year - (profile.birthYear ?? (DateTime.now().year - 25));
    final bool isMale =
        (profile.gender ?? '').toLowerCase() == 'male' ||
        (profile.gender ?? '').toLowerCase() == 'nam';
    final double weight = profile.weight ?? 60.0;
    final int height = profile.height ?? 170;

    double bmr = isMale
        ? (10 * weight) + (6.25 * height) - (5 * age) + 5
        : (10 * weight) + (6.25 * height) - (5 * age) - 161;

    // Get activity level from profile (selected in ActivityLevelPage)
    int activityLevel = profile.activityLevel ?? 1;
    double activityFactor = activityValues[activityLevel]!;
    double tdee = bmr * activityFactor;

    double minSafeCalories = isMale ? 1500.0 : 1200.0;
    double desiredDeficit = ((profile.speed ?? 0.5) * 7700) / 7;

    double targetCalories;
    bool isSafetyAdjusted = false;
    if ((profile.goal ?? 'maintain') == 'lose') {
      double rawTarget = tdee - desiredDeficit;
      if (rawTarget < minSafeCalories) {
        targetCalories = minSafeCalories;
        isSafetyAdjusted = true;
      } else {
        targetCalories = rawTarget;
      }
    } else if ((profile.goal ?? '') == 'gain') {
      targetCalories = tdee + desiredDeficit;
    } else {
      targetCalories = tdee;
    }

    double realSpeed = profile.speed ?? 0.0;
    if ((profile.goal ?? '') == 'lose') {
      double realDeficit = tdee - targetCalories;
      realSpeed = (realDeficit * 7) / 7700;
    } else if ((profile.goal ?? '') == 'gain') {
      double realSurplus = targetCalories - tdee;
      realSpeed = (realSurplus * 7) / 7700;
    }

    final double heightM = height / 100.0;
    final double bmi = weight / pow(heightM, 2);

    String bmiStatus;
    if (bmi < 18.5) {
      bmiStatus = "Thiếu cân";
    } else if (bmi < 25) {
      bmiStatus = "Bình thường";
    } else if (bmi < 30) {
      bmiStatus = "Thừa cân";
    } else {
      bmiStatus = "Béo phì";
    }

    final double diff = ((profile.targetWeight ?? weight) - weight).abs();
    String goalDisplay = (profile.goal ?? 'maintain') == 'maintain'
        ? 'Giữ cân'
        : (profile.goal ?? '') == 'lose'
        ? 'Giảm ${diff.toStringAsFixed(1)} kg'
        : 'Tăng ${diff.toStringAsFixed(1)} kg';

    String speedDisplay;
    if ((profile.goal ?? '') == 'maintain') {
      speedDisplay = '---';
    } else {
      if (isSafetyAdjusted) {
        speedDisplay =
            "~${realSpeed.toStringAsFixed(2)} kg/tuần\n(Đã điều chỉnh vì an toàn)";
      } else {
        speedDisplay = "${(profile.speed ?? 0.0).toStringAsFixed(2)} kg/tuần";
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Kế hoạch của bạn'),
        automaticallyImplyLeading: false, // Hide back button
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Basic info
            _buildSectionHeader('Thông tin cơ thể'),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow('Giới tính', isMale ? 'Nam' : 'Nữ'),
                  _buildDivider(),
                  _buildRow('Tuổi', '$age'),
                  _buildDivider(),
                  _buildRow('Chiều cao', '$height cm'),
                  _buildDivider(),
                  _buildRow(
                    'Cân nặng hiện tại',
                    '${weight.toStringAsFixed(1)} kg',
                  ),
                  _buildDivider(),
                  _buildRow('BMI', '${bmi.toStringAsFixed(1)} ($bmiStatus)'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Activity (read-only, selected in onboarding)
            _buildSectionHeader('Mức độ vận động'),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: _buildRow(
                'Mức độ hoạt động',
                activityDescriptions[activityLevel]!,
              ),
            ),
            const SizedBox(height: 20),

            // Results
            _buildSectionHeader('Mục tiêu & Dinh dưỡng'),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow('Mục tiêu', goalDisplay),
                  _buildDivider(),
                  _buildRow(
                    'Tốc độ dự kiến',
                    speedDisplay,
                    isHighlight: isSafetyAdjusted,
                  ),
                  _buildDivider(),
                  _buildRow(
                    'BMR (Trao đổi chất)',
                    '${bmr.toStringAsFixed(0)} kcal',
                  ),
                  _buildDivider(),
                  _buildRow(
                    'TDEE (Tổng tiêu thụ)',
                    '${tdee.toStringAsFixed(0)} kcal',
                  ),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Calo nên nạp/ngày',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      Text(
                        '${targetCalories.toStringAsFixed(0)} kcal',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                    ],
                  ),
                  if (isSafetyAdjusted)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemYellow.withValues(
                            alpha: 0.2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              CupertinoIcons.exclamationmark_triangle,
                              color: CupertinoColors.systemOrange,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Đã điều chỉnh về mức tối thiểu an toàn để tránh suy nhược cơ thể.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CupertinoColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            CupertinoButton.filled(
              child: const Text('Cập nhật'),
              onPressed: () {
                context.go('/?edit=true');
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 8),
    child: Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        color: CupertinoColors.systemGrey,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildRow(String title, String value, {bool isHighlight = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isHighlight
                      ? CupertinoColors.systemOrange
                      : CupertinoColors.black,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDivider() =>
      const Divider(height: 1, color: CupertinoColors.systemGrey5);
}
