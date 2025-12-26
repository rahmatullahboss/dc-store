import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/external_launcher_service.dart';

/// Provider for ExternalLauncherService
///
/// Usage:
/// ```dart
/// final launcher = ref.read(externalLauncherServiceProvider);
/// final result = await launcher.launchEmail();
/// ```
final externalLauncherServiceProvider = Provider<ExternalLauncherService>((
  ref,
) {
  return ExternalLauncherService.instance;
});
