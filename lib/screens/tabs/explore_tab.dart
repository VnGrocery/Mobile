import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';
import 'package:vngrocery/features/explore/controllers/explore_state.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';
import 'package:vngrocery/features/explore/widgets/explore_tab_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ExploreTab extends StatefulWidget {
  final bool showMap;
  final double bottomContentInset;

  const ExploreTab({
    super.key,
    this.showMap = true,
    this.bottomContentInset = 0,
  });

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _search = TextEditingController();
  late final ExploreCubit _exploreCubit;

  @override
  void initState() {
    super.initState();
    _exploreCubit = ExploreCubit()..load();
  }

  @override
  void dispose() {
    _exploreCubit.close();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return BlocProvider.value(
      value: _exploreCubit,
      child: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          final shops = state.shops;
          final selectedShop = widget.showMap ? state.selectedShop : null;

          return Scaffold(
            backgroundColor: palette.appBackground,
            appBar: AppBar(
              title: Text(
                widget.showMap ? l10n.exploreTitle : l10n.exploreStoreTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                // The map used to be its own bottom tab showing the same shops
                // as this list. It is one tap away from here instead.
                if (!widget.showMap)
                  IconButton(
                    tooltip: l10n.exploreTitle,
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.exploreMap),
                    icon: const Icon(Icons.map_outlined),
                  ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ExploreSearchField(
                    controller: _search,
                    onChanged: () => _exploreCubit.setQuery(_search.text),
                  ),
                ),
                ExploreFilterBar(
                  filters: ExplorePresenter.filters(l10n),
                  selectedFilter: state.selectedFilter,
                  onSelect: _exploreCubit.setFilter,
                ),
                SizedBox(height: widget.showMap ? 16 : 12),
                if (widget.showMap) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ExploreMapPreview(
                      shops: shops,
                      selectedShopId: selectedShop?.id,
                      onOpenMap: () => Navigator.pushNamed(
                        context,
                        Routes.exploreMap,
                        arguments:
                            ExploreMapArgs(initialShopId: selectedShop?.id),
                      ),
                      onSelectShop: (shop) => _exploreCubit.selectShop(shop.id),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ExploreStoreListHeader(
                  title: widget.showMap
                      ? l10n.exploreNearbyStoresTitle
                      : l10n.exploreAllStoresTitle,
                  showDirections: widget.showMap && selectedShop != null,
                  onDirections: selectedShop == null
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            Routes.storeDetail,
                            arguments: StoreDetailArgs(selectedShop.id),
                          ),
                ),
                Expanded(
                  child: shops.isEmpty
                      ? Center(
                          child: Text(
                            l10n.exploreNoResults,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            4,
                            16,
                            16 + widget.bottomContentInset,
                          ),
                          itemCount: shops.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => ExploreShopCard(
                            shop: shops[i],
                            selected: widget.showMap &&
                                shops[i].id == state.selectedShopId,
                            onTap: () {
                              if (widget.showMap) {
                                _exploreCubit.selectShop(shops[i].id);
                                return;
                              }
                              Navigator.pushNamed(
                                context,
                                Routes.storeDetail,
                                arguments: StoreDetailArgs(shops[i].id),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
