import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingPageData(this.title, this.description, this.icon);
}

class OnboardingPages {
  const OnboardingPages._();

  /// Built per-locale rather than held in a const list, so the slides follow
  /// the app language.
  static List<OnboardingPageData> of(AppLocalizations l10n) => [
    OnboardingPageData(
      l10n.onboardingTitle1,
      l10n.onboardingBody1,
      Icons.verified_user,
    ),
    OnboardingPageData(
      l10n.onboardingTitle2,
      l10n.onboardingBody2,
      Icons.photo_camera,
    ),
    OnboardingPageData(
      l10n.onboardingTitle3,
      l10n.onboardingBody3,
      Icons.check_circle,
    ),
  ];

  /// Number of slides, needed before a context is available.
  static const count = 3;
}
