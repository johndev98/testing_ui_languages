import 'package:flutter/cupertino.dart';
import 'package:flutter_ruler_slider/flutter_ruler_slider.dart';
import 'package:ui_calo_app/ui/sumary_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();

  String? gender;
  // Khai báo biến
  double? weight; // dùng double vì có thể có .5
  int? height; // dùng int vì bước là 1
  double? targetWeight;
  int? birthYear;
  String? goal;
  String? diet;
  bool isKg = true; // mặc định kg
  bool isCm = true; // mặc định cm
  double? speed; // kg/week
  void nextPage() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Onboarding")),
      child: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildGenderPage(),
          _buildWeightPage(),
          _buildHeightPage(),
          _buildBirthYearPage(),
          _buildGoalPage(),
          _buildSpeedPage(),
          _buildDietPage(),
        ],
      ),
    );
  }

  Widget _buildGenderPage() {
    return Column(
      children: [
        // phần trên chiếm hết không gian còn lại
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: BorderRadius.circular(20),
                  color: gender == "male"
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text(
                    "Nam",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () {
                    setState(() => gender = "male");
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  borderRadius: BorderRadius.circular(20),
                  color: gender == "female"
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text(
                    "Nữ",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 22,
                    ),
                  ),
                  onPressed: () {
                    setState(() => gender = "female");
                  },
                ),
              ),
            ],
          ),
        ),

        // nút Tiếp tục cố định dưới cùng, cách bottom 20
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: 250,
            child: CupertinoButton(
              borderRadius: BorderRadius.circular(20),
              color: gender != null
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.inactiveGray,
              onPressed: gender != null ? nextPage : null,
              child: const Text(
                "Tiếp tục",
                style: TextStyle(color: CupertinoColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightPage() {
    // đặt giá trị mặc định nếu chưa có
    weight ??= 60;

    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterRulerSlider(
                minValue: 40, // 20kg * 2
                maxValue: 600, // 300kg * 2
                initialValue: ((weight ?? 60) * 2).toInt(),
                width: 300,
                interval: 20, // mỗi vạch lớn = 10kg (10*2)
                smallerInterval: 1, // mỗi vạch nhỏ = 0.5kg
                snapping: true,
                showLabels: false,
                showSubLabels: false,
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
                  setState(() => weight = val / 2.0); // chia lại cho 2 để ra kg
                },
              ),
              const SizedBox(height: 10),
              Text(
                "${weight?.toStringAsFixed(1) ?? '--'} kg",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: CupertinoColors.white),
                ),
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              CupertinoButton(
                color: weight != null
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                onPressed: weight != null ? nextPage : null,
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

  Widget _buildHeightPage() {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RotatedBox(
                quarterTurns: -1, // xoay 90° sang dọc
                child: FlutterRulerSlider(
                  minValue: 100,
                  maxValue: 220,
                  initialValue: height ?? 170,
                  width: 300,
                  interval: 10, // vạch lớn mỗi 10cm
                  smallerInterval: 1, // bước nhỏ 1cm
                  snapping: true,
                  showLabels: false,
                  showSubLabels: false,
                  labelSpacing: 6,
                  labelRotation: 0,
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
                  onValueChanged: (val) {
                    setState(() => height = val.toInt());
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${height ?? '--'} cm",
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: CupertinoColors.white),
                ),
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              CupertinoButton(
                color: weight != null
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                onPressed: height != null ? nextPage : null,
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

  Widget _buildBirthYearPage() {
    final int currentYear = DateTime.now().year;
    final int minYear = currentYear - 100;
    final int maxYear = currentYear - 5;

    // đảm bảo birthYear luôn có giá trị mặc định 2000
    birthYear ??= 2000;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text("Chọn năm sinh"),
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 50,
                    scrollController: FixedExtentScrollController(
                      initialItem: birthYear! - minYear,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        birthYear = minYear + index;
                      });
                    },
                    children: List.generate(
                      maxYear - minYear + 1,
                      (i) => Text("${minYear + i}"),
                    ),
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
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(color: CupertinoColors.white),
                  ),
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                CupertinoButton(
                  color: CupertinoColors.activeBlue,
                  onPressed: nextPage,
                  child: const Text(
                    "Tiếp tục",
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

  Widget _buildGoalPage() {
    // Đảm bảo weight có giá trị
    final double currentWeight = weight ?? 60;

    // 1. Logic khởi tạo targetWeight (như đã sửa ở câu trước)
    if (targetWeight == null || goal == null) {
      targetWeight = currentWeight;
      goal = "maintain";
    } else if (goal == "maintain" && targetWeight != currentWeight) {
      targetWeight = currentWeight;
    }

    // 2. Logic Min/Max hợp lý theo % cơ thể
    // Min: Cho phép giảm tối đa về 50% trọng lượng, nhưng không thấp hơn 35kg
    double calculatedMin = (currentWeight * 0.5).clamp(35.0, currentWeight);
    // Max: Cho phép tăng tối đa lên 150% trọng lượng, nhưng không quá 250kg
    double calculatedMax = (currentWeight * 1.5).clamp(currentWeight, 250.0);

    // Mở rộng ruler thêm 1 chút (-5/+5) để user không bị cảm giác kịch kim
    int rulerMin = ((calculatedMin - 5).clamp(30.0, 300.0) * 2).toInt();
    int rulerMax = ((calculatedMax + 5).clamp(30.0, 300.0) * 2).toInt();

    // 3. Tính chênh lệch để hiển thị text
    double diff = (targetWeight! - currentWeight).abs();

    String topTitle() {
      if (targetWeight == currentWeight) {
        return "Bạn sẽ giữ cân";
      } else if (targetWeight! < currentWeight) {
        return "Bạn sẽ giảm cân: ${diff.toStringAsFixed(1)} kg";
      } else {
        return "Bạn sẽ tăng cân: ${diff.toStringAsFixed(1)} kg";
      }
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
                initialValue: ((targetWeight ?? currentWeight) * 2).toInt(),
                width: 300,
                interval:
                    10, // Sửa interval thành 10 để đỡ rối mắt nếu dải rộng
                smallerInterval: 1,
                snapping: true,
                showLabels: false,
                showSubLabels: false,
                tickSpacing:
                    15, // Có thể cần điều chỉnh spacing nếu dải quá dài
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
                  setState(() {
                    // Clamp lại giá trị lần nữa để đảm bảo an toàn
                    double newTarget = val / 2.0;

                    // Logic xác định goal
                    if (newTarget == currentWeight) {
                      goal = "maintain";
                    } else if (newTarget < currentWeight) {
                      goal = "lose";
                    } else {
                      goal = "gain";
                    }
                    targetWeight = newTarget;
                  });
                },
              ),

              const SizedBox(height: 20),
              Text(
                "${targetWeight!.toStringAsFixed(1)} kg",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // ... (Phần nút bấm giữ nguyên)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoButton(
                color: CupertinoColors.systemGrey,
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: CupertinoColors.white),
                ),
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              CupertinoButton(
                color: goal != null
                    ? CupertinoColors.activeBlue
                    : CupertinoColors.inactiveGray,
                onPressed: goal != null
                    ? () {
                        if (goal == "maintain") {
                          if (_controller.hasClients) _controller.jumpToPage(6);
                        } else {
                          nextPage();
                        }
                      }
                    : null,
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

  Widget _buildSpeedPage() {
    speed ??= 0.5; // mặc định giữa khoảng an toàn

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
                "${speed!.toStringAsFixed(2)} kg/tuần",
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
                  divisions: 3, // 0.25, 0.5, 0.75, 1.0
                  value: speed!,
                  onChanged: (value) {
                    setState(() => speed = value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text("0.25", style: TextStyle(fontSize: 16)),
                  Text("0.5", style: TextStyle(fontSize: 16)),
                  Text("0.75", style: TextStyle(fontSize: 16)),
                  Text("1.0", style: TextStyle(fontSize: 16)),
                ],
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
                child: const Text(
                  "Quay lại",
                  style: TextStyle(color: CupertinoColors.white),
                ),
                onPressed: () {
                  _controller.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              CupertinoButton(
                color: CupertinoColors.activeBlue,
                onPressed: nextPage,
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

  Widget _buildDietPage() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                CupertinoButton(
                  color: diet == "eat_clean"
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text("Eat Clean"),
                  onPressed: () {
                    setState(() => diet = "eat_clean");
                  },
                ),
                CupertinoButton(
                  color: diet == "keto"
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text("Keto"),
                  onPressed: () {
                    setState(() => diet = "keto");
                  },
                ),
                CupertinoButton(
                  color: diet == "low_carb"
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  child: const Text("Low Carb"),
                  onPressed: () {
                    setState(() => diet = "low_carb");
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: .spaceAround,
              children: [
                CupertinoButton(
                  color: CupertinoColors.systemGrey,
                  onPressed: _previousPage,
                  child: const Text(
                    "Quay lại",
                    style: TextStyle(color: CupertinoColors.white),
                  ), // gọi hàm mới
                ),
                CupertinoButton(
                  color: diet != null
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.inactiveGray,
                  onPressed: diet != null ? _finishOnboarding : null,
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

  void _finishOnboarding() {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => SummaryScreen(
          gender: gender!,
          weight: weight!,
          height: height!,
          birthYear: birthYear!,
          goal: goal!,
          targetWeight: targetWeight!,
          diet: diet!,
          speed: speed ?? 0.0,
        ),
      ),
    );
  }

  void _previousPage() {
    final int currentIndex = _controller.page?.round() ?? 0;

    // Nếu đang ở Diet page và goal == maintain, quay lại Goal page thay vì Speed page
    if (currentIndex == 6 && goal == "maintain") {
      _controller.jumpToPage(4); // nhảy thẳng về Goal page (index 4)
    } else {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
