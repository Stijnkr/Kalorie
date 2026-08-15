import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../core/widgets/stroke_icon.dart';
import '../../data/local/collections/enums.dart';
import '../../data/providers.dart';
import '../../data/remote/off_mapper.dart';
import '../../data/remote/rate_limiter.dart';
import '../add_food/quick_log.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({
    super.key,
    this.popWithFood = false,
    this.initialMeal,
  });

  final bool popWithFood;
  final String? initialMeal;

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen>
    with SingleTickerProviderStateMixin {
  final _controller = MobileScannerController();
  final _manual = TextEditingController();
  late final AnimationController _scanLine;
  bool _busy = false;
  bool _manualOpen = false;

  @override
  void initState() {
    super.initState();
    _scanLine = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLine.dispose();
    _controller.dispose();
    _manual.dispose();
    super.dispose();
  }

  MealType get _meal => widget.initialMeal == null
      ? mealForNow()
      : MealType.values.firstWhere(
          (m) => m.name == widget.initialMeal,
          orElse: mealForNow,
        );

  Future<void> _restart() async {
    if (!mounted) return;
    setState(() => _busy = false);
    await _controller.start();
  }

  Future<void> _onCode(String code) async {
    if (_busy || code.isEmpty) return;
    setState(() => _busy = true);
    await _controller.stop();
    var transient = false;
    try {
      final repo = ref.read(foodRepositoryProvider);
      var food = await repo.getByBarcode(code);
      if (food == null) {
        try {
          food =
              await ref.read(catalogRepositoryProvider).getRemoteByBarcode(code);
        } catch (_) {
          food = null;
        }
      }
      if (food == null) {
        try {
          final product = await ref.read(offRemoteProvider).getByBarcode(code);
          final mapped = product == null ? null : mapOffProduct(product);
          if (mapped != null) {
            food = await repo.cacheOffProduct(mapped);
          }
        } on RateLimitedException {
          transient = true;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).rateLimited)),
            );
          }
        } catch (_) {
          transient = true;
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context).networkError)),
            );
          }
        }
      }
      if (!mounted) return;
      if (food == null) {
        if (transient) {
          await _restart();
          return;
        }
        context.pushReplacement(
          '/add/custom?barcode=$code&meal=${_meal.name}&log=1',
        );
        return;
      }
      if (widget.popWithFood) {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop(food);
        return;
      }
      await quickLogFood(context, ref, food: food, meal: _meal);
      if (!mounted) return;
      context.go('/today');
    } finally {
      if (mounted && _busy) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const ink = KalorieColors.paperDark;
    const paper = KalorieColors.inkDark;
    const accent = KalorieColors.sageDark;

    return Scaffold(
      backgroundColor: ink,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final code = capture.barcodes.firstOrNull?.rawValue;
              if (code != null) _onCode(code);
            },
            errorBuilder: (context, error) {
              return _CameraError(
                message: l10n.cameraDenied,
                actionLabel: l10n.enterBarcode,
                onAction: () => setState(() => _manualOpen = true),
              );
            },
          ),
          const ColoredBox(color: Color(0x59121411)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
                  child: Row(
                    children: [
                      KalorieTapTarget(
                        onTap: () => context.pop(),
                        child: const StrokeIcon(
                          StrokeShape.close,
                          size: 14,
                          color: paper,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          l10n.scanBarcode,
                          style: const TextStyle(
                            color: paper,
                            fontSize: 17,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      KalorieTapTarget(
                        tooltip: l10n.enterBarcode,
                        onTap: () => setState(() => _manualOpen = !_manualOpen),
                        child: const StrokeIcon(
                          StrokeShape.barcode,
                          size: 16,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final top = constraints.maxHeight * 0.22;
                      return Stack(
                        children: [
                          Positioned(
                            left: 44,
                            right: 44,
                            top: top,
                            height: 210,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: paper.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _scanLine,
                            builder: (context, child) {
                              final curve = Curves.easeInOut
                                  .transform(_scanLine.value);
                              return Positioned(
                                left: 60,
                                right: 60,
                                top: top + 14 + curve * 182,
                                child: child!,
                              );
                            },
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: accent,
                                boxShadow: [
                                  BoxShadow(
                                    color: accent.withValues(alpha: 0.7),
                                    blurRadius: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 32,
                            right: 32,
                            bottom: 24,
                            child: Text(
                              l10n.scanSimulateHint,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: paper.withValues(alpha: 0.72),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          if (_busy)
                            const Center(
                              child: CircularProgressIndicator(color: accent),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                if (_manualOpen)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      0,
                      24,
                      16 + MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: TextField(
                      controller: _manual,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      style: const TextStyle(color: paper, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: l10n.enterBarcode,
                        hintStyle: TextStyle(
                          color: paper.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: paper.withValues(alpha: 0.08),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: paper.withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: accent),
                        ),
                        suffixIcon: IconButton(
                          color: accent,
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () => _onCode(_manual.text.trim()),
                        ),
                      ),
                      onSubmitted: _onCode,
                    ),
                  )
                else
                  const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  const _CameraError({
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    const paper = KalorieColors.inkDark;
    const accent = KalorieColors.sageDark;
    return ColoredBox(
      color: KalorieColors.paperDark,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: paper,
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(
                  actionLabel,
                  style: const TextStyle(color: accent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
