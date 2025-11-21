import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'localization/providers/locale_provider.dart';
import 'onboarding/providers/user_profile_provider.dart';
import 'router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    // Ensure UserProfileNotifier is initialized to start loading
    ref.watch(userProfileProvider);
    final isLoading = ref.watch(isProfileLoadingProvider);

    // Wait for user profile to load before showing the app
    // This ensures router has correct initial location
    if (isLoading) {
      // While loading, we can either show the native splash (by doing nothing if preserved)
      // or show a loading indicator. Since we used preserve, the native splash covers this.
      return const CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CupertinoPageScaffold(
          child: Center(child: CupertinoActivityIndicator()),
        ),
      );
    }

    // Remove splash screen when loading is complete
    FlutterNativeSplash.remove();

    final router = ref.watch(routerProvider);

    return CupertinoApp.router(
      debugShowCheckedModeBanner: false,
      locale: Locale(locale),
      routerConfig: router,
    );
  }
}
