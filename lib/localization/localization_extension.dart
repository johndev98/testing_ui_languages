import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'localization.dart';

extension LocalizationRef on WidgetRef {
  AppLocalizations get loc {
    final localization = watch(localizationProvider);
    if (localization == null) {
      throw Exception('Localization chưa sẵn sàng');
    }
    return localization;
  }
  // Nếu không dùng thêm cái này, thì nếu lỗi load json -> sẽ không hiển thị được gây crash
  AppLocalizations? get locOrNull => watch(localizationProvider);
}
