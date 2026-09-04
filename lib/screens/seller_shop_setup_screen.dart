import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/onboarding/onboarding_page_data.dart';
import 'package:vngrocery/features/onboarding/widgets/onboarding_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/screens/seller_shop_screen.dart';
import 'package:vngrocery/theme/app_palette.dart';

/// Shown in place of the seller tabs to a newly-promoted seller who has no
/// shop yet: a short "next next" intro carousel, then the existing
/// create-shop form. A close button on every step leaves seller mode
/// instead of forcing the setup through.
class SellerShopSetupScreen extends StatefulWidget {
  const SellerShopSetupScreen({super.key});

  @override
  State<SellerShopSetupScreen> createState() => _SellerShopSetupScreenState();
}

class _SellerShopSetupScreenState extends State<SellerShopSetupScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _introDone = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_introDone) return const SellerShopScreen(showExitAction: true);

    final l10n = AppLocalizations.of(context);
    final pages = [
      OnboardingPageData(
        l10n.sellerOnboardingTitle1,
        l10n.sellerOnboardingBody1,
        Icons.storefront,
      ),
      OnboardingPageData(
        l10n.sellerOnboardingTitle2,
        l10n.sellerOnboardingBody2,
        Icons.inventory_2,
      ),
      OnboardingPageData(
        l10n.sellerOnboardingTitle3,
        l10n.sellerOnboardingBody3,
        Icons.verified,
      ),
    ];

    return Scaffold(
      backgroundColor: context.palette.appBackground,
      bottomNavigationBar: OnboardingBottomBar(
        page: _page,
        pageCount: pages.length,
        onNext: () => _next(pages.length),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: l10n.sellerShopSetupExit,
                onPressed: () =>
                    context.read<SessionCubit>().setSellerMode(false),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (_, index) =>
                    OnboardingPageContent(page: pages[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _next(int pageCount) {
    if (_page == pageCount - 1) {
      setState(() => _introDone = true);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}
