import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../onboarding_page_data.dart';

class OnboardingSkipButton extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingSkipButton({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: onSkip,
          child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}

class OnboardingPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: OnboardingPages.items.length,
      onPageChanged: onPageChanged,
      itemBuilder: (_, index) {
        return OnboardingPageContent(page: OnboardingPages.items[index]);
      },
    );
  }
}

class OnboardingPageContent extends StatelessWidget {
  final OnboardingPageData page;

  const OnboardingPageContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.meatRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 60, color: AppColors.meatRed),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingBottomBar extends StatelessWidget {
  final int page;
  final VoidCallback onNext;

  const OnboardingBottomBar({
    super.key,
    required this.page,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = page == OnboardingPages.items.length - 1;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OnboardingDots(page: page),
          FilledButton(
            onPressed: onNext,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isLast ? 'Bắt đầu' : 'Tiếp tục'),
                if (!isLast) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingDots extends StatelessWidget {
  final int page;

  const OnboardingDots({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(OnboardingPages.items.length, (index) {
        final active = index == page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 8),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.meatRed : context.palette.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
