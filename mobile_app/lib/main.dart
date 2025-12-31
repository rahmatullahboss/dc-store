import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/cache/cache_service.dart';
import 'core/config/white_label_config.dart';
import 'core/config/app_config.dart';
import 'core/network/dio_client.dart' show storageServiceProvider;
// import 'core/widgets/app_error_boundary.dart'; // Temporarily disabled
import 'l10n/app_localizations.dart';
import 'navigation/app_router.dart';
import 'services/storage_service.dart';
import 'services/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service (singleton)
  final storageService = await StorageService.getInstance();

  // Initialize cache service
  final cacheService = CacheService();
  await cacheService.init();

  // Initialize Stripe payment service
  await PaymentService.instance.initialize(
    stripePublishableKey: AppConfig.stripePublishableKey,
  );

  // Create router with storage service for route guards
  final appRouter = AppRouter(storageService);

  runApp(
    ProviderScope(
      overrides: [
        cacheServiceProvider.overrideWithValue(cacheService),
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: MyApp(appRouter: appRouter),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // AppErrorBoundary temporarily disabled - causing framework errors
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: WhiteLabelConfig.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        routerConfig: appRouter.router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
