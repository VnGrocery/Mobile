import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/widgets/home_components.dart';
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
    _homeCubit = HomeCubit()..load();
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
                  HomeHeader(userName: userName, onOpenMenu: widget.onOpenMenu),
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
                  const SizedBox(height: 28),
                  HomeSectionTitle(
                    l10n.homeTopRatedStoresTitle,
                    showAction: false,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    // Fits a two-line shop name plus the trust chip and the
                    // rating row. Real shop names wrap ("Trái Cây Nhà Vườn Cái
                    // Mơn"), which the earlier 150 did not allow for.
                    height: 172,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.shops.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) =>
                          HomeTrustShopCard(shop: state.shops[i]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  HomeSectionTitle(
                    l10n.homeRecentChecksTitle,
                    onSeeAll: () =>
                        showHomePledgeSheet(context, state.pledgeItems),
                  ),
                  const SizedBox(height: 12),
                  ...featuredPledgeItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 5,
                      ),
                      child: HomePledgeCard(item: item),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
