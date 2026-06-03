import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_cubit.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_state.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_shop_components.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerShopScreen extends StatefulWidget {
  final double bottomContentInset;

  const SellerShopScreen({super.key, this.bottomContentInset = 0});

  @override
  State<SellerShopScreen> createState() => _SellerShopScreenState();
}

class _SellerShopScreenState extends State<SellerShopScreen> {
  late final SellerShopCubit _shopCubit;
  late final TextEditingController _name;
  late final TextEditingController _description;
  late final TextEditingController _address;

  bool get _canSave =>
      _name.text.trim().isNotEmpty && _address.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _shopCubit = SellerShopCubit(
      shopId: context.read<SessionCubit>().state.shopId,
    )..load();
    final shop = _shopCubit.state.shop!;
    _name = TextEditingController(text: shop.name);
    _description = TextEditingController(text: shop.description);
    _address = TextEditingController(text: shop.address);
  }

  @override
  void dispose() {
    _shopCubit.close();
    _name.dispose();
    _description.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _shopCubit,
      child: BlocBuilder<SellerShopCubit, SellerShopState>(
        builder: (context, state) {
          final dashboard = state.dashboard;
          if (dashboard == null) {
            return Scaffold(
              backgroundColor: context.palette.appBackground,
              appBar: AppBar(title: const Text('Thông tin cửa hàng')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: context.palette.appBackground,
            appBar: AppBar(
              title: const Text(
                'Thông tin cửa hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + widget.bottomContentInset,
              ),
              children: [
                SellerShopSummaryCard(dashboard: dashboard),
                const SizedBox(height: 16),
                SellerShopFields(
                  name: _name,
                  description: _description,
                  address: _address,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 18),
                SellerShopSaveButton(
                  saving: state.saving,
                  enabled: _canSave,
                  onSave: _save,
                ),
                const SizedBox(height: 16),
                const SellerShopFootnote(),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _save() async {
    await _shopCubit.save(
      name: _name.text,
      description: _description.text,
      address: _address.text,
    );
    final shop = _shopCubit.state.shop;
    if (!mounted || shop == null) return;
    context.read<SessionCubit>().setShopId(shop.id);
    AppFeedback.showSnackBar(context, 'Đã lưu thông tin cửa hàng demo');
  }
}
