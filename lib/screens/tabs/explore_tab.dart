import 'package:flutter/material.dart';

import '../../data/data_hooks.dart';
import '../../data/models.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _search = TextEditingController();
  String _filter = 'Uy tín cao';

  static const _filters = ['Uy tín cao', 'Có cam kết', 'Gần bạn', 'Mới nhất'];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shops = AppDataHooks.instance.getShops();
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(
        title: const Text('Khám phá cửa hàng',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Tìm tên cửa hàng hoặc địa chỉ...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.filter_list),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = f == _filter;
                return FilterChip(
                  label: Text(f),
                  selected: sel,
                  showCheckmark: false,
                  selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: sel ? AppColors.meatRed : Colors.black,
                  ),
                  onSelected: (_) => setState(() => _filter = f),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: shops.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ShopExploreCard(shop: shops[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopExploreCard extends StatelessWidget {
  final Shop shop;
  const _ShopExploreCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, Routes.storeDetail,
            arguments: shop.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const GrayBox(size: 70, radius: 12, icon: Icons.store,
                  iconSize: 32, iconColor: AppColors.meatRed),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(shop.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.trustGreenBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: AppColors.warningOrange, size: 12),
                              Text(' ${shop.rating} Trust Score',
                                  style: const TextStyle(
                                      color: AppColors.trustGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (shop.reviewCount > 100)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.meatRed.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Uy tín cao',
                                style: TextStyle(
                                    color: AppColors.meatRed,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
