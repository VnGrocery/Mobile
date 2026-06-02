import 'package:flutter/material.dart';

import '../../features/explore/explore_presenter.dart';
import '../../features/explore/widgets/explore_tab_components.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_palette.dart';

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
  String _filter = 'Đánh giá tốt';
  String? _selectedShopId;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final shops = ExplorePresenter.filteredShops(_search.text);
    final selectedShop = widget.showMap
        ? ExplorePresenter.selectedShop(shops, _selectedShopId)
        : null;

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
              onChanged: () => setState(() => _selectedShopId = null),
            ),
          ),
          ExploreFilterBar(
            filters: ExplorePresenter.filters,
            selectedFilter: _filter,
            onSelect: (filter) => setState(() => _filter = filter),
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
                onSelectShop: (shop) =>
                    setState(() => _selectedShopId = shop.id),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ExploreStoreListHeader(
            title: widget.showMap ? 'Cửa hàng gần bạn' : 'Tất cả cửa hàng',
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
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => ExploreShopCard(
                      shop: shops[i],
                      selected:
                          widget.showMap && shops[i].id == _selectedShopId,
                      onTap: () {
                        if (widget.showMap) {
                          setState(() => _selectedShopId = shops[i].id);
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
  }
}
