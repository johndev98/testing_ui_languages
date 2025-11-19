import 'package:flutter/cupertino.dart';
import 'dart:math';

import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget {
  final String gender;
  final double weight; // kg
  final int height; // cm
  final int birthYear;
  final String goal; // maintain / lose / gain
  final double targetWeight;
  final String diet;
  final double speed; // kg/tuần

  const SummaryScreen({
    super.key,
    required this.gender,
    required this.weight,
    required this.height,
    required this.birthYear,
    required this.goal,
    required this.targetWeight,
    required this.diet,
    required this.speed,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  // Map lưu trữ giá trị activity factor
  // Key là nhãn hiển thị ngắn gọn, Value là hệ số
  final Map<int, double> activityValues = {
    0: 1.2, // Ít vận động
    1: 1.375, // Nhẹ
    2: 1.55, // Vừa
    3: 1.725, // Nặng
    4: 1.9, // Rất nặng
  };

  // Map mô tả chi tiết để hiển thị bên dưới
  final Map<int, String> activityDescriptions = {
    0: "Ít vận động (Làm văn phòng, ngủ, xem TV)",
    1: "Vận động nhẹ (Tập 1-3 lần/tuần)",
    2: "Vận động vừa (Tập 3-5 lần/tuần)",
    3: "Vận động nặng (Tập 6-7 lần/tuần)",
    4: "Vận động rất nặng (2 lần/ngày, lao động nặng)",
  };

  int selectedActivityIndex = 1; // Mặc định chọn mức nhẹ (index 1)

  @override
  Widget build(BuildContext context) {
    final int age = DateTime.now().year - widget.birthYear;
    // Chuyển đổi gender chuẩn hóa
    final bool isMale =
        widget.gender.toLowerCase() == "male" ||
        widget.gender.toLowerCase() == "nam";

    // 1. Tính BMR theo công thức Mifflin-St Jeor (Chuẩn hiện đại)
    double bmr;
    if (isMale) {
      bmr = (10 * widget.weight) + (6.25 * widget.height) - (5 * age) + 5;
    } else {
      bmr = (10 * widget.weight) + (6.25 * widget.height) - (5 * age) - 161;
    }

    // 2. Tính TDEE
    double activityFactor = activityValues[selectedActivityIndex]!;
    double tdee = bmr * activityFactor;

    // 3. Tính toán Calo mục tiêu & Giới hạn an toàn
    // Mức sàn an toàn: Nam 1500, Nữ 1200
    double minSafeCalories = isMale ? 1500.0 : 1200.0;

    // Lượng calo cần thâm hụt/dư ra mỗi ngày theo speed mong muốn
    // 1kg mỡ ~ 7700kcal
    double desiredDeficit = (widget.speed * 7700) / 7;

    double targetCalories;
    bool isSafetyAdjusted = false; // Cờ đánh dấu nếu phải điều chỉnh an toàn

    if (widget.goal == "lose") {
      double rawTarget = tdee - desiredDeficit;

      // LOGIC AN TOÀN: Không cho phép dưới mức sàn
      if (rawTarget < minSafeCalories) {
        targetCalories = minSafeCalories;
        isSafetyAdjusted = true;
      } else {
        targetCalories = rawTarget;
      }
    } else if (widget.goal == "gain") {
      targetCalories = tdee + desiredDeficit;
    } else {
      targetCalories = tdee; // Maintain
    }

    // 4. Tính lại tốc độ thực tế (Real Speed) dựa trên calo đã chốt
    double realSpeed = widget.speed;
    if (widget.goal == "lose") {
      double realDeficit = tdee - targetCalories;
      realSpeed = (realDeficit * 7) / 7700;
    } else if (widget.goal == "gain") {
      double realSurplus = targetCalories - tdee;
      realSpeed = (realSurplus * 7) / 7700;
    }

    // 5. Chuẩn bị dữ liệu hiển thị
    final double heightM = widget.height / 100.0;
    final double bmi = widget.weight / pow(heightM, 2);

    String bmiStatus;
    if (bmi < 18.5) {
      bmiStatus = "Thiếu cân";
    } else if (bmi < 25)
      bmiStatus = "Bình thường";
    else if (bmi < 30)
      bmiStatus = "Thừa cân";
    else
      bmiStatus = "Béo phì";

    final double diff = (widget.targetWeight - widget.weight).abs();
    String goalDisplay;
    if (widget.goal == "maintain") {
      goalDisplay = "Giữ cân";
    } else if (widget.goal == "lose") {
      goalDisplay = "Giảm ${diff.toStringAsFixed(1)} kg";
    } else {
      goalDisplay = "Tăng ${diff.toStringAsFixed(1)} kg";
    }

    String speedDisplay;
    if (widget.goal == "maintain") {
      speedDisplay = "---";
    } else {
      if (isSafetyAdjusted) {
        speedDisplay =
            "~${realSpeed.toStringAsFixed(2)} kg/tuần\n(Đã giảm tốc độ để đảm bảo sức khỏe)";
      } else {
        speedDisplay = "${widget.speed.toStringAsFixed(2)} kg/tuần";
      }
    }

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Kế hoạch của bạn"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section 1: Thông tin cơ bản
            _buildSectionHeader("Thông tin cơ thể"),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow("Giới tính", isMale ? "Nam" : "Nữ"),
                  _buildDivider(),
                  _buildRow("Tuổi", "$age"),
                  _buildDivider(),
                  _buildRow("Chiều cao", "${widget.height} cm"),
                  _buildDivider(),
                  _buildRow("Cân nặng hiện tại", "${widget.weight} kg"),
                  _buildDivider(),
                  _buildRow("BMI", "${bmi.toStringAsFixed(1)} ($bmiStatus)"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 2: Mức độ vận động (Interactive)
            _buildSectionHeader("Mức độ vận động"),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      activityDescriptions[selectedActivityIndex]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSegmentedControl<int>(
                      groupValue: selectedActivityIndex,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: const {
                        0: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Ít"),
                        ),
                        1: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Nhẹ"),
                        ),
                        2: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Vừa"),
                        ),
                        3: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Nặng"),
                        ),
                        4: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("Rất nặng"),
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          selectedActivityIndex = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section 3: Kết quả tính toán
            _buildSectionHeader("Mục tiêu & Dinh dưỡng"),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildRow("Mục tiêu", goalDisplay),
                  _buildDivider(),
                  _buildRow(
                    "Tốc độ dự kiến",
                    speedDisplay,
                    isHighlight: isSafetyAdjusted,
                  ),
                  _buildDivider(),
                  _buildRow(
                    "BMR (Trao đổi chất)",
                    "${bmr.toStringAsFixed(0)} kcal",
                  ),
                  _buildDivider(),
                  _buildRow(
                    "TDEE (Tổng tiêu thụ)",
                    "${tdee.toStringAsFixed(0)} kcal",
                  ),
                  _buildDivider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Calo nên nạp/ngày",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.activeBlue,
                        ),
                      ),
                      Text(
                        "${targetCalories.toStringAsFixed(0)} kcal",
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
                          color: CupertinoColors.systemYellow.withValues(alpha: 0.2),
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
                                "Đã điều chỉnh về mức tối thiểu an toàn (1200 kcal) để tránh suy nhược cơ thể.",
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
              child: const Text("Lưu kế hoạch"),
              onPressed: () {
                // TODO: Lưu vào SharedPreferences hoặc Database
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: const Text("Thành công"),
                    content: Text(
                      "Mục tiêu ${targetCalories.toStringAsFixed(0)} kcal đã được thiết lập!",
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
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
  }

  Widget _buildRow(String title, String value, {bool isHighlight = false}) {
    return Padding(
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
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: CupertinoColors.systemGrey5);
  }
}
