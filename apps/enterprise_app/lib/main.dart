// apps/enterprise_app/lib/main.dart

import "package:core_ui_kit/core_ui_kit.dart";
import "package:feature_auth/feature_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "bootstrap.dart";
import "di/injection.dart";

void main() {
  const baseUrl = String.fromEnvironment(
    "API_BASE_URL",
    defaultValue: "https://api.enterprise.com",
  );

  bootstrap(() async {
    await configureDependencies(baseUrl: baseUrl);
    return const EnterpriseApp();
  });
}

class EnterpriseApp extends StatelessWidget {
  const EnterpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => locator<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
      ],
      child: MaterialApp(
        title: "Flutter Architecture Bible",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}

