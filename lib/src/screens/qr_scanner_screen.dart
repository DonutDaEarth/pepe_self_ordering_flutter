import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:pepe_self_ordering_flutter/src/data/models/models.dart';
import 'package:pepe_self_ordering_flutter/src/state/app_state.dart';
import 'package:pepe_self_ordering_flutter/src/state/cart_state.dart';
import 'package:pepe_self_ordering_flutter/src/theme/app_theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});
  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool handled = false;
  ScannedQrData? scanned;
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      backgroundColor: const Color(0xFF2C2C2C),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (handled) return;
              final value = capture.barcodes.first.rawValue;
              if (value == null) return;
              final parsed = AppState.parseQr(value);
              if (parsed == null) return;
              setState(() {
                handled = true;
                scanned = parsed;
              });
              context.read<AppState>().setOutlet(parsed);
              context.read<CartState>().clear();
              // context.go('/main_menu');
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                width: 227,
                height: 227,
                decoration: BoxDecoration(
                  // color: AppColors.orangePrimary,
                  borderRadius: BorderRadius.circular(24),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/pepe_app_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: scanned == null
                        ? null
                        : () => context.go('/main_menu'),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.orangePrimary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: scanned == null
                          ? const Text(
                              "Scan your Table's QR Code",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "CarterOne",
                                fontSize: 18,
                                color: AppColors.brownDark,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  app.outletName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "CarterOne",
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  app.tableNumber,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "CarterOne",
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () async {
                      await context.read<AppState>().authRepo.logout();
                      if (!mounted) return;
                      context.read<CartState>().clear();
                      context.go('/register');
                    },
                    child: const Text(
                      'Log out of Current Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
