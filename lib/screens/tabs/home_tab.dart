import 'package:flutter/material.dart';

import '../../data/data_hooks.dart';
import '../../data/models.dart';
import '../../data/session.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../utils/format.dart';

class _Cat {
  final String label;
  final IconData icon;
  const _Cat(this.label, this.icon);
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _search = TextEditingController();
  String _category = 'Tất cả';

  static const _cats = [
    _Cat('Thịt heo', Icons.kebab_dining),
    _Cat('Thịt bò', Icons.lunch_dining),
    _Cat('Gia cầm', Icons.egg_alt),
    _Cat('Hải sản', Icons.set_meal),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataHooks.instance;
    final shops = data.getShops();
    final products = data.getProducts();
    final featuredProducts = products.take(3).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _header(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _searchBar(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _heroCard(),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Danh mục', showAction: false),
            const SizedBox(height: 12),
            _categories(),
            const SizedBox(height: 28),
            _sectionTitle('Cửa hàng uy tín', showAction: false),
            const SizedBox(height: 12),
            SizedBox(
              height: 134,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: shops.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _TrustShopCard(shop: shops[i]),
              ),
            ),
            const SizedBox(height: 30),
            _sectionTitle(
              'Bảng tin cam kết',
              onSeeAll: () => _showAllPledges(products),
            ),
            const SizedBox(height: 12),
            ...featuredProducts.map((p) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: _PledgeCard(product: p),
                )),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final name = SessionManager.instance.displayName;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/images/user.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.card,
                child: Icon(Icons.person, color: AppColors.primaryGreen),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Xin chào,',
                    style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.location_on,
                    color: AppColors.primaryGreen, size: 16),
                SizedBox(width: 4),
                Text('Quận 1',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down,
                    color: AppColors.primaryGreen, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      controller: _search,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Tìm shop, sản phẩm...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _search.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => setState(() => _search.clear()),
              ),
      ),
    );
  }

  Widget _heroCard() {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.pushNamed(context, Routes.scan),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white),
                      const SizedBox(height: 8),
                      const Text('Kiểm tra AI',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Text('Đối chứng thực tế với cam kết',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.photo_camera,
                      color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String t, {
    bool showAction = true,
    VoidCallback? onSeeAll,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (showAction)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Xem tất cả',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      );

  void _showAllPledges(List<Product> products) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Bảng tin cam kết',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.62,
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _PledgeCard(product: products[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: _cats.map((c) {
          final sel = c.label == _category;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _category = sel ? 'Tất cả' : c.label),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        sel ? AppColors.primaryGreen : AppColors.card,
                    child: Icon(c.icon,
                        color: sel ? Colors.white : AppColors.primaryGreen,
                        size: 26),
                  ),
                  const SizedBox(height: 8),
                  Text(c.label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? AppColors.primaryGreen : Colors.black)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TrustShopCard extends StatelessWidget {
  final Shop shop;
  const _TrustShopCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.pushNamed(context, Routes.storeDetail,
              arguments: shop.id),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/meat.png',
                      width: 26,
                      height: 26,
                      errorBuilder: (_, __, ___) => const Icon(Icons.storefront,
                          color: AppColors.primaryGreen)),
                ),
                const SizedBox(height: 10),
                Text(shop.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.warningOrange, size: 14),
                    Text(' ${shop.rating}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${shop.reviewCount} đánh giá',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PledgeCard extends StatelessWidget {
  final Product product;
  const _PledgeCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = AppDataHooks.instance.getShop(product.shopId);
    final scoreColor = AppColors.freshnessColor(product.freshnessScore);
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.productDetail,
          arguments: {'shopId': product.shopId, 'productId': product.id},
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 72,
                  height: 72,
                  color: Colors.white,
                  child: Image.asset('assets/images/lamb_meat.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image,
                          color: AppColors.textSecondary)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 6),
                    Text(formatVnd(product.price),
                        style: const TextStyle(
                            color: AppColors.priceRed,
                            fontWeight: FontWeight.w800,
                            fontSize: 15)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${product.freshnessScore}',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          color: scoreColor)),
                  const Text('AI Score',
                      style: TextStyle(
                          fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
