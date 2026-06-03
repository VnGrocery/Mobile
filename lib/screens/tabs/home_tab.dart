import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_cubit.dart';
import 'package:vngrocery/features/home/controllers/home_state.dart';
import 'package:vngrocery/features/home/widgets/home_components.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeTab extends StatefulWidget {
  final VoidCallback? onOpenMenu;
  final double bottomContentInset;

  const HomeTab({
    super.key,
    this.onOpenMenu,
    this.bottomContentInset = 0,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _search = TextEditingController();
  late final HomeCubit _homeCubit;
  String _category = 'Tất cả';

  static const _categories = [
    HomeCategory('Thịt heo', Icons.kebab_dining),
    HomeCategory('Thịt bò', Icons.lunch_dining),
    HomeCategory('Gia cầm', Icons.egg_alt),
    HomeCategory('Hải sản', Icons.set_meal),
  ];

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
    final userName = context.watch<SessionCubit>().state.displayName;

    return BlocProvider.value(
      value: _homeCubit,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final featuredPledgeItems = state.featuredPledgeItems();

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
                  const SizedBox(height: 24),
                  const HomeSectionTitle('Danh mục', showAction: false),
                  const SizedBox(height: 12),
                  HomeCategoryList(
                    categories: _categories,
                    selectedCategory: _category,
                    onSelect: (category) => setState(() {
                      _category = category == _category ? 'Tất cả' : category;
                    }),
                  ),
                  const SizedBox(height: 28),
                  const HomeSectionTitle(
                    'Cửa hàng được đánh giá tốt',
                    showAction: false,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 134,
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
                    'Sản phẩm mới kiểm tra',
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
