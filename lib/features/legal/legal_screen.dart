import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/kalorie_ui.dart';
import 'legal_copy.dart';

enum LegalDoc { privacy, terms }

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final title = doc == LegalDoc.privacy ? l10n.privacyTitle : l10n.termsTitle;
    final sections = doc == LegalDoc.privacy ? LegalCopy.privacy : LegalCopy.terms;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KalorieOverlayHeader(
              title: title,
              onBack: () => context.canPop() ? context.pop() : context.go('/today'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 40),
                children: [
                  for (final section in sections) ...[
                    KalorieSectionLabel(
                      section.title,
                      padding: const EdgeInsets.only(bottom: 6, top: 14),
                    ),
                    Text(
                      section.body,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.55),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Voetregel onder inloggen/aanmaken: korte zin plus twee tikbare stukken.
class AuthLegalFooter extends StatelessWidget {
  const AuthLegalFooter({super.key, this.align = TextAlign.center});

  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hint = theme.textTheme.labelMedium?.copyWith(
      color: context.tones.hint,
      height: 1.6,
    );
    final link = hint?.copyWith(color: theme.colorScheme.primary);

    return Column(
      crossAxisAlignment: align == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.stretch,
      children: [
        Text(l10n.authLegal, textAlign: align, style: hint),
        const SizedBox(height: 4),
        Wrap(
          alignment: align == TextAlign.left
              ? WrapAlignment.start
              : WrapAlignment.center,
          spacing: 16,
          children: [
            TextButton(
              onPressed: () => context.push('/legal/terms'),
              child: Text(l10n.termsTitle, style: link),
            ),
            TextButton(
              onPressed: () => context.push('/legal/privacy'),
              child: Text(l10n.privacyTitle, style: link),
            ),
          ],
        ),
      ],
    );
  }
}
