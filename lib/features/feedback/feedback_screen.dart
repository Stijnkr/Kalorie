import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import '../../data/providers.dart';
import '../../data/repositories/feedback_repository.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  final _message = TextEditingController();
  FeedbackKind _kind = FeedbackKind.idea;
  bool _busy = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _message.text.trim();
    if (_busy || text.isEmpty) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(feedbackRepositoryProvider).send(
            kind: _kind,
            message: text,
          );
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackSent)));
      context.pop();
    } on FeedbackException {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackFailed)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final canSend = _message.text.trim().isNotEmpty && !_busy;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: l10n.feedback,
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 40),
                children: [
                  Text(
                    l10n.feedbackIntro,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      KaloriePill(
                        label: l10n.feedbackIdea,
                        selected: _kind == FeedbackKind.idea,
                        onTap: () => setState(() => _kind = FeedbackKind.idea),
                      ),
                      KaloriePill(
                        label: l10n.feedbackProblem,
                        selected: _kind == FeedbackKind.problem,
                        onTap: () =>
                            setState(() => _kind = FeedbackKind.problem),
                      ),
                      KaloriePill(
                        label: l10n.feedbackOther,
                        selected: _kind == FeedbackKind.other,
                        onTap: () => setState(() => _kind = FeedbackKind.other),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  KalorieSectionLabel(
                    l10n.feedback,
                    padding: const EdgeInsets.only(bottom: 6),
                  ),
                  TextField(
                    controller: _message,
                    minLines: 5,
                    maxLines: 10,
                    maxLength: 4000,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(hintText: l10n.feedbackHint),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: canSend ? _send : null,
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.feedbackSend),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
