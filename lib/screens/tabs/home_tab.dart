import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/widgets/home_components.dart';
import 'package:vngrocery/features/home/widgets/home_status_message.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback? onOpenMenu;
  final double bottomContentInset;

  const HomeTab({super.key, this.onOpenMenu, this.bottomContentInset = 0});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _search = TextEditingController();
  late final HomeCubit _homeCubit;
  static const _allCategory = 'all';
  String _category = _allCategory;

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit()
      ..load()
      ..locateReader();
  }

  @override
  void dispose() {
    _homeCubit.close();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userName = context.watch<SessionCubit>().state.displayName;
    return BlocProvider.value(
      value: _homeCubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final categories = state.categories;
          final activeCategory = categories.contains(_category)
              ? _category
              : _allCategory;
          final topRatedShops = state.topRatedShops;
          // Everything loaded, the reader is located, and none of it is close
          // enough to be worth showing.
          final outOfRange =
              state.location != null &&
              state.pledgeItems.isNotEmpty &&
              state.nearbyPledgeItems.isEmpty;
          final featuredPledgeItems = state.featuredPledgeItems(
            category: activeCategory == _allCategory ? null : activeCategory,
          );

          return Scaffold(
            backgroundColor: context.palette.appBackground,
            body: SafeArea(
              bottom: false,
              child: ListView(
                padding: EdgeInsets.only(bottom: widget.bottomContentInset),
                children: [
                  HomeHeader(
                    userName: userName,
                    onOpenMenu: widget.onOpenMenu,
                    areaName: state.location?.areaName ?? '',
                    located: state.location != null,
                    onOpenMap: () =>
                        Navigator.pushNamed(context, Routes.exploreMap),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeSearchBar(
                      controller: _search,
                      onChanged: () => setState(() {}),
                      onClear: () => setState(_search.clear),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeScanHeroCard(
                      onTap: () => Navigator.pushNamed(context, Routes.scan),
                    ),
                  ),
                  // Hidden entirely when nothing has a category yet, rather
                  // than showing chips that match no product.
                  if (categories.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    HomeSectionTitle(
                      l10n.homeCategoriesTitle,
                      showAction: false,
                    ),
                    const SizedBox(height: 12),
                    HomeCategoryList(
                      categories: categories,
                      selectedCategory: activeCategory,
                      onSelect: (category) => setState(() {
                        // Tapping the active one clears the filter.
                        _category = category == activeCategory
                            ? _allCategory
                            : category;
                      }),
                    ),
                  ],
                  if (topRatedShops.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    HomeSectionTitle(
                      l10n.homeTopRatedStoresTitle,
                      showAction: false,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      // Fits a two-line shop name plus the trust chip and the
                      // rating row. Real shop names wrap ("Trái Cây Nhà Vườn
                      // Cái Mơn"), which the earlier 150 did not allow for.
                      height: 172,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: topRatedShops.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            HomeTrustShopCard(shop: topRatedShops[i]),
                      ),
                    ),
                  ],
                  if (state.isEmpty)
                    // Nothing at all: one message for the whole page beats a
                    // heading with a blank space under it.
                    switch (state.status) {
                      HomeStatus.loading => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 64),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      HomeStatus.failed => HomeStatusMessage(
                        icon: Icons.cloud_off,
                        title: l10n.homeLoadFailedTitle,
                        message: l10n.homeLoadFailedMessage,
                        actionLabel: l10n.homeRetryAction,
                        onAction: _homeCubit.load,
                      ),
                      HomeStatus.ready => HomeStatusMessage(
                        icon: Icons.inventory_2_outlined,
                        title: l10n.homeEmptyTitle,
                        message: l10n.homeEmptyMessage,
                      ),
                    }
                  else ...[
                    const SizedBox(height: 30),
                    HomeSectionTitle(
                      l10n.homeRecentChecksTitle,
                      // Nothing to open when the filter matched nothing.
                      showAction: featuredPledgeItems.isNotEmpty,
                      onSeeAll: () =>
                          showHomePledgeSheet(context, state.pledgeItems),
                    ),
                    const SizedBox(height: 12),
                    if (featuredPledgeItems.isEmpty)
                      // There is a catalogue, so an empty list here means
                      // nothing of it is within reach — a different problem
                      // from having no products at all.
                      outOfRange
                          ? HomeStatusMessage(
                              icon: Icons.location_searching,
                              title: l10n.homeNoShopNearbyTitle,
                              message: l10n.homeNoShopNearbyMessage,
                            )
                          : HomeStatusMessage(
                              icon: Icons.inventory_2_outlined,
                              title: l10n.homeEmptyTitle,
                              message: l10n.homeEmptyMessage,
                            )
                    else
                      ...featuredPledgeItems.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 5,
                          ),
                          child: HomePledgeCard(
                            item: entry.item,
                            distanceKm: entry.distanceKm,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
