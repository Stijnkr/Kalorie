import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../data/providers.dart';
import '../../data/remote/off_mapper.dart';
import '../../data/remote/rate_limiter.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key, this.popWithFood = false});

  final bool popWithFood;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final _controller = MobileScannerController();
  final _manual = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    _manual.dispose();
    super.dispose();
  }

  Future<void> _onCode(String code) async {
    if (_busy || code.isEmpty) return;
    setState(() => _busy = true);
    await _controller.stop();
    try {
      final repo = ref.read(foodRepositoryProvider);
      var food = await repo.getByBarcode(code);
      if (food == null) {
        try {
          final product = await ref.read(offRemoteProvider).getByBarcode(code);
          final mapped = product == null ? null : mapOffProduct(product);
          if (mapped != null) {
            food = await repo.cacheOffProduct(mapped);
          }
        } on RateLimitedException {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).rateLimited)),
            );
          }
        } catch (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).networkError)),
            );
          }
        }
      }
      if (!mounted) return;
      if (food == null) {
        context.pushReplacement('/add/custom?barcode=$code');
        return;
      }
      HapticFeedback.mediumImpact();
      if (widget.popWithFood) {
        Navigator.of(context).pop(food);
        return;
      }
      context.pushReplacement('/add/amount/${food.id}');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanBarcode)),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    final code = capture.barcodes.firstOrNull?.rawValue;
                    if (code != null) _onCode(code);
                  },
                ),
                if (_busy)
                  const ColoredBox(
                    color: Color(0x66000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.scanHint, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                TextField(
                  controller: _manual,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.enterBarcode,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () => _onCode(_manual.text.trim()),
                    ),
                  ),
                  onSubmitted: _onCode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
