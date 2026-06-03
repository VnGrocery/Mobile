import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui/app_feedback.dart';
import '../../../features/cart/controllers/cart_bloc.dart';
import '../../../features/cart/controllers/cart_event.dart';
import '../../../routes/app_routes.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';
import '../../../utils/format.dart';
import '../../../widgets/score_badge.dart';
import '../home_presenter.dart';

class HomePledgeCard extends StatelessWidget {
  final HomePledgeItem item;

  const HomePledgeCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final shop = item.shop;
    final palette = context.palette;
    return Material(
      color: palette.card,
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
                  color: palette.elevatedCard,
                  child: Image.asset(
                    'assets/images/lamb_meat.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatVnd(product.price),
                      style: const TextStyle(
                        color: AppColors.priceRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cập nhật 2 giờ trước bởi @user123',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ScoreRingBadge(score: product.freshnessScore),
                  const SizedBox(height: 8),
                  IconButton.filled(
                    tooltip: 'Thêm vào giỏ',
                    onPressed: () {
                      context
                          .read<CartBloc>()
                          .add(CartAddRequested(product: product));
                      AppFeedback.showSnackBar(
                        context,
                        'Đã thêm ${product.name}',
                        icon: Icons.add_shopping_cart_rounded,
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showHomePledgeSheet(BuildContext context, List<HomePledgeItem> items) {
  final palette = context.palette;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: palette.elevatedCard,
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
                    'Sản phẩm mới kiểm tra',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => HomePledgeCard(item: items[i]),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
