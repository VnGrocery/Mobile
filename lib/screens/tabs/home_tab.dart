import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/widgets/home_components.dart';
import 'package:vngrocery/features/home/widgets/home_status_message.dart';
import 'package:vngrocery/features/home/widgets/home_offer_card.dart';
import 'package:vngrocery/features/home/widgets/home_product_grid.dart';
import 'package:vngrocery/features/home/widgets/recommendation_section.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
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

  /// Opens the map, and looks for the reader again on the way back.
  ///
  /// The chip doubles as "we do not know where you are, look again", but
  /// tapping it only ever pushed the map. The map screen finds the position
  /// through its own cubit, so the reader would come back from a map centred on
  /// their own street to a header still insisting it had no idea where they
  /// were - and to a catalogue still ordered as though it did not.
  ///
  /// Only when the position was missing: a second fix costs a GPS read and
  /// would tell us nothing new.
  Future<void> _openMap({required bool hadLocation}) async {
    await Navigator.pushNamed(context, Routes.exploreMap);
    if (!mounted || hadLocation) return;
    await _homeCubit.locateReader();
  }

  /// Reloads the catalogue when the reader pulls the page down. The two calls
  /// run together so the spinner covers both the catalogue and the location
  /// fix, and it stays until the slower of the two finishes.
  Future<void> _refresh() async {
    await Future.wait([_homeCubit.load(), _homeCubit.locateReader()]);
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
          // Located, but everything is past the search radius: the list below
          // is the closest that exists rather than anything actually nearby.
          final outsideRange = state.outsideRange;

          final category = activeCategory == _allCategory
              ? null
              : activeCategory;
          final query = _search.text;
          final filtering = state.filtering(category: category, query: query);
          final spotlight = state.spotlightProducts;
          final grid = state.rankedGrid(category: category, query: query);
          // Only the server can say whether the ranking rests on anything this
          // reader has done; the heading follows that answer rather than
          // claiming "for you" by default.
          final personalised = state.recommendations?.personalised ?? false;

          return Scaffold(
            backgroundColor: context.palette.appBackground,
            body: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppColors.primaryGreen,
                onRefresh: _refresh,
                child: ListView(
                  // AlwaysScrollable so the pull-to-refresh gesture works even
                  // when the catalogue is short enough to fit on one screen.
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: widget.bottomContentInset),
                  children: [
                    HomeHeader(
                      userName: userName,
                      onOpenMenu: widget.onOpenMenu,
                      areaName: state.location?.areaName ?? '',
                      located: state.location != null,
                      onOpenMap: () =>
                          _openMap(hadLocation: state.location != null),
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
                    // The advert slot. Real offers only: the server has
                    // already dropped everything expired, paused, or belonging
                    // to a shop that is gone, and an empty list hides the slot
                    // rather than showing a banner for nothing.
                    if (state.offers.isNotEmpty) ...[
                      HomeOfferCard(offers: state.offers),
                      const SizedBox(height: 8),
                    ],
                    // Hidden entirely when nothing has a category yet, rather
                    // than showing chips that match no product.
                    if (categories.isNotEmpty) ...[
                      const SizedBox(height: 16),
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
                      // Both carousels stand down while the reader is
                      // searching or filtering: a "top rated" row carved out
                      // of their own results would hide matches from them.
                      if (!filtering) ...[
                        if (topRatedShops.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          HomeSectionTitle(
                            l10n.homeTopRatedStoresTitle,
                            showAction: false,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            // Fits a two-line shop name plus the trust chip
                            // and the rating row.
                            height: 172,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: topRatedShops.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, i) =>
                                  HomeTrustShopCard(shop: topRatedShops[i]),
                            ),
                          ),
                        ],
                        if (spotlight.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          RecommendationSection(
                            recommendations: state.recommendations!,
                            products: spotlight,
                            title: l10n.homeSpotlightTitle,
                          ),
                        ],
                      ],
                      const SizedBox(height: 28),
                      HomeSectionTitle(
                        filtering
                            ? l10n.homeFilterResults
                            : personalised
                            ? l10n.homeRankedTitle
                            : l10n.homeRankedPopularTitle,
                        showAction: false,
                      ),
                      if (outsideRange && !filtering)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            l10n.homeOutsideRangeNotice,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (grid.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            l10n.homeFilterEmpty,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.palette.textSecondary,
                            ),
                          ),
                        )
                      else
                        HomeProductGrid(
                          products: grid,
                          personalised: personalised,
                        ),
                      const SizedBox(height: 30),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
