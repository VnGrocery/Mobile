import 'package:flutter/material.dart';

import 'package:vngrocery/core/storage/hive_storage_service.dart';
import 'package:vngrocery/features/onboarding/onboarding_page_data.dart';
import 'package:vngrocery/features/onboarding/widgets/onboarding_components.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      bottomNavigationBar: OnboardingBottomBar(
        page: _page,
        onNext: _next,
      ),
      body: SafeArea(
        child: Column(
          children: [
            OnboardingSkipButton(onSkip: _finish),
            Expanded(
              child: OnboardingPageView(
                controller: _controller,
                onPageChanged: (index) => setState(() => _page = index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _finish() async {
    await HiveStorageService.markOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.auth);
  }

  void _next() {
    if (_page == OnboardingPages.items.length - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
