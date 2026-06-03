import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/explore/controllers/explore_cubit.dart';
import 'package:vngrocery/features/explore/controllers/explore_state.dart';
import 'package:vngrocery/features/explore/explore_presenter.dart';
import 'package:vngrocery/features/explore/widgets/explore_tab_components.dart';
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
                widget.showMap ? 'Khám phá cửa hàng' : 'Cửa hàng',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
                  filters: ExplorePresenter.filters,
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
                        arguments: selectedShop?.id,
                      ),
                      onSelectShop: (shop) => _exploreCubit.selectShop(shop.id),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ExploreStoreListHeader(
                  title:
                      widget.showMap ? 'Cửa hàng gần bạn' : 'Tất cả cửa hàng',
                  showDirections: widget.showMap && selectedShop != null,
                  onDirections: selectedShop == null
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            Routes.storeDetail,
                            arguments: selectedShop.id,
                          ),
                ),
                Expanded(
                  child: shops.isEmpty
                      ? const Center(
                          child: Text(
                            'Không tìm thấy cửa hàng phù hợp',
                            style: TextStyle(color: AppColors.textSecondary),
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
                                arguments: shops[i].id,
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
