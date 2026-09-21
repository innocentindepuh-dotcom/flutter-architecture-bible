// apps/enterprise_app/lib/bootstrap.dart

import "dart:async";
import "dart:developer";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

void bootstrap(FutureOr<Widget> Function() builder) {
  FlutterError.onError = (details) {
    log(
      "Flutter Framework Error: ${details.exceptionAsString()}",
      name: "CRASH_REPORT",
      stackTrace: details.stack,
      error: details.exception,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(
      "Unhandled Platform Error: $error",
      name: "FATAL_ERROR",
      stackTrace: stack,
      error: error,
    );
    return true;
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final app = await builder();
      runApp(app);
    },
    (error, stack) {
      log(
        "Critical Uncaught Root Error: $error",
        name: "ROOT_GUARD",
        stackTrace: stack,
        error: error,
      );
    },
  );
}

