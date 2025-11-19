import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ui_calo_app/test_screen.dart';

import 'onboarding_flow.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Hàm giả lập xử lý đăng nhập
  void _handleGoogleSignIn(BuildContext context) {
    // TO DO: Tích hợp logic đăng nhập Google Firebase/Google Sign-In tại đây.
    // Sau khi đăng nhập thành công, bạn có thể điều hướng đến màn hình chính.
    // Ví dụ:
    // Navigator.of(context).pushReplacement(
    //   CupertinoPageRoute(builder: (_) => const HomeScreen()),
    // );

    // Hiển thị dialog tạm thời để mô phỏng
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Thông báo"),
        content: const Text("Chức năng đăng nhập Google đang được phát triển."),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              // Phần trên để hiển thị logo và tiêu đề
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // Biểu tượng ứng dụng
                    Icon(
                      CupertinoIcons.flame_fill,
                      size: 80,
                      color: CupertinoColors.activeOrange,
                    ),
                    SizedBox(height: 20),
                    // Tên ứng dụng
                    Text(
                      "Calo App",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.darkBackgroundGray,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Slogan/Mô tả
                    Text(
                      "Theo dõi sức khỏe, làm chủ vóc dáng",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),

              // Phần dưới chứa nút đăng nhập
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nút đăng nhập với Google
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: Colors.white,
                      onPressed: () => _handleGoogleSignIn(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TO DO: Thay thế bằng logo Google từ assets
                          // Ví dụ: Image.asset('assets/google_logo.png', height: 24)
                          const Icon(
                            Icons.android,
                            color: Colors.black87,
                          ), // Icon tạm thời
                          const SizedBox(width: 12),
                          const Text(
                            "Đăng nhập với Google",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Nút "Bỏ qua"
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // TO DO: Xử lý logic khi người dùng bỏ qua đăng nhập
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (_) => const TestScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Bỏ qua",
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
