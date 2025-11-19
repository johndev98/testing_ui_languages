import 'package:flutter/cupertino.dart';
import 'dart:math';

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
  // Activity factor options
  final Map<String, double> activityOptions = {
    "Ít vận động": 1.2,
    "Vận động nhẹ (1-3 lần/tuần)": 1.375,
    "Vận động vừa (3-5 lần/tuần)": 1.55,
    "Vận động nặng (6-7 lần/tuần)": 1.725,
    "Vận động rất nặng (2 lần/ngày)": 1.9,
  };

  String selectedActivity = "Vận động nhẹ (1-3 lần/tuần)";

  @override
  Widget build(BuildContext context) {
    final int age = DateTime.now().year - widget.birthYear;
    final double heightM = widget.height / 100.0;

    // BMI
    final double bmi = widget.weight / pow(heightM, 2);
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

    // BMR theo Harris-Benedict
    double bmr = (widget.gender == "male")
        ? 66 + (13.7 * widget.weight) + (5 * widget.height) - (6.76 * age)
        : 655 + (9.6 * widget.weight) + (1.8 * widget.height) - (4.7 * age);

    // Activity factor từ dropdown
    double activityFactor = activityOptions[selectedActivity]!;
    double tdee = bmr * activityFactor;

    // Giới hạn speed từ 0.25 → 1 kg/tuần
    double safeSpeed = widget.speed.clamp(0.25, 1.0);

    // Thâm hụt calo
    double dailyCalorieDeficit = 0;
    if (widget.goal == "lose") {
      dailyCalorieDeficit = safeSpeed * 7700 / 7;
    } else if (widget.goal == "gain") {
      dailyCalorieDeficit = -safeSpeed * 7700 / 7;
    }

    double targetCalories = tdee - dailyCalorieDeficit;

    // Điều chỉnh calo khuyến nghị
    double recommendedCalories;
    if (widget.goal == "lose") {
      recommendedCalories = max(tdee - 750, bmr);
    } else if (widget.goal == "gain") {
      recommendedCalories = targetCalories;
    } else {
      recommendedCalories = tdee;
    }

    final double diff = (widget.targetWeight - widget.weight).abs();
    String goalDisplay;
    if (widget.goal == "maintain") {
      goalDisplay = "Giữ cân";
    } else if (widget.goal == "lose") {
      goalDisplay = "Giảm ${diff.toStringAsFixed(1)} kg";
    } else {
      goalDisplay = "Tăng ${diff.toStringAsFixed(1)} kg";
    }

    String speedDisplay = "${safeSpeed.toStringAsFixed(2)} kg/tuần";

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Thông tin của bạn"),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRow("Giới tính", widget.gender),
              _buildRow(
                "Cân nặng hiện tại",
                "${widget.weight.toStringAsFixed(1)} kg",
              ),
              _buildRow(
                "Cân nặng mục tiêu",
                "${widget.targetWeight.toStringAsFixed(1)} kg",
              ),
              _buildRow("Mục tiêu", goalDisplay),
              if (widget.goal != "maintain")
                _buildRow("Tốc độ thay đổi cân nặng", speedDisplay),
              _buildRow("Chiều cao", "${widget.height} cm"),
              _buildRow("Năm sinh", "${widget.birthYear}"),
              _buildRow("Chế độ ăn", widget.diet),
              const SizedBox(height: 20),
              _buildRow("BMI", bmi.toStringAsFixed(1)),
              _buildRow("Tình trạng BMI", bmiStatus),
              _buildRow("BMR (cơ bản)", "${bmr.toStringAsFixed(0)} kcal"),
              _buildRow("TDEE (tiêu hao)", "${tdee.toStringAsFixed(0)} kcal"),
              _buildRow(
                "Calo khuyến nghị/ngày",
                "${recommendedCalories.toStringAsFixed(0)} kcal",
              ),
              const SizedBox(height: 20),
              const Text(
                "Chọn mức độ vận động:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              CupertinoSegmentedControl<String>(
                groupValue: selectedActivity,
                children: {
                  for (var key in activityOptions.keys)
                    key: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(key, style: const TextStyle(fontSize: 14)),
                    ),
                },
                onValueChanged: (value) {
                  setState(() {
                    selectedActivity = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
