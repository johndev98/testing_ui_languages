import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../locale_repository.dart';

class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier(this.repo, String initialLocale) : super(initialLocale);

  final LocaleRepository repo;

  Future<void> setLocale(String locale) async {
    state = locale;
    await repo.saveLocale(locale);
  }
}

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, String>((
  ref,
) {
  throw UnimplementedError('Must override in main()');
});
