import 'package:go_router/go_router.dart';
import 'package:pepe_self_ordering_flutter/src/screens/screens.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';

GoRouter buildRouter(AppState appState) {
  return GoRouter(
    initialLocation: appState.startRoute,
    routes: [
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/qr_scanner', builder: (_, __) => const QrScannerScreen()),
      GoRoute(path: '/main_menu', builder: (_, __) => const MainMenuScreen()),
      GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
      GoRoute(
        path: '/payment_success',
        builder: (_, __) => const PaymentSuccessScreen(),
      ),
      GoRoute(path: '/receipt', builder: (_, __) => const ReceiptScreen()),
    ],
  );
}
