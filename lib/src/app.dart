import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/navigation/app_router.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class PepeApp extends StatefulWidget {
  const PepeApp({super.key});

  @override
  State<PepeApp> createState() => _PepeAppState();
}

class _PepeAppState extends State<PepeApp> {
  GoRouter? _router;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (appState.isBootLoading) {
      return MaterialApp(
        theme: buildAppTheme(),
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.orangePrimary),
          ),
        ),
      );
    }
    _router ??= buildRouter(appState);
    return MaterialApp.router(
      title: 'Pepe Self Ordering',
      theme: buildAppTheme(),
      routerConfig: _router!,
      debugShowCheckedModeBanner: false,
    );
  }
}
