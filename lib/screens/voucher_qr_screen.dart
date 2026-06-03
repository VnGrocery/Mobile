import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/ui/app_feedback.dart';
import '../features/vouchers/controllers/voucher_qr_cubit.dart';
import '../features/vouchers/controllers/voucher_qr_state.dart';
import '../features/vouchers/widgets/voucher_components.dart';
import '../features/vouchers/widgets/voucher_qr_components.dart';
import '../routes/app_routes.dart';
import '../theme/app_palette.dart';

class VoucherQrScreen extends StatefulWidget {
  final String userVoucherId;

  const VoucherQrScreen({super.key, required this.userVoucherId});

  @override
  State<VoucherQrScreen> createState() => _VoucherQrScreenState();
}

class _VoucherQrScreenState extends State<VoucherQrScreen> {
  late final VoucherQrCubit _voucherQrCubit;

  @override
  void initState() {
    super.initState();
    _voucherQrCubit = VoucherQrCubit(userVoucherId: widget.userVoucherId)
      ..load();
  }

  @override
  void dispose() {
    _voucherQrCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return BlocProvider.value(
      value: _voucherQrCubit,
      child: BlocBuilder<VoucherQrCubit, VoucherQrState>(
        builder: (context, state) {
          final userVoucher = state.userVoucher;
          final voucher = state.voucher;
          final shop = state.shop;
          if (userVoucher == null || voucher == null || shop == null) {
            return Scaffold(
              backgroundColor: palette.appBackground,
              appBar: AppBar(title: const Text('Dùng voucher')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            backgroundColor: palette.appBackground,
            appBar: AppBar(title: const Text('Dùng voucher')),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                VoucherUseHeader(
                  voucher: voucher,
                  shop: shop,
                  userVoucher: userVoucher,
                ),
                const SizedBox(height: 20),
                VoucherCodeCard(
                  userVoucher: userVoucher,
                  voucher: voucher,
                  shop: shop,
                ),
                if (voucher.isManual) ...[
                  const SizedBox(height: 14),
                  const VoucherNotice(
                    text:
                        'Thông tin voucher này do bạn tự nhập và chưa được cửa hàng xác thực. Hãy kiểm tra lại điều kiện tại quầy trước khi sử dụng.',
                  ),
                ],
                const SizedBox(height: 20),
                VoucherRuleCard(voucher: voucher, shop: shop),
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed:
                        state.disabled || state.confirming ? null : _markUsed,
                    icon: Icon(
                      userVoucher.isUsed ? Icons.check : Icons.point_of_sale,
                    ),
                    label: Text(
                      userVoucher.isUsed
                          ? 'Voucher đã dùng'
                          : 'Đánh dấu đã dùng',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    Routes.storeDetail,
                    arguments: shop.id,
                  ),
                  child: const Text('Xem cửa hàng áp dụng'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _markUsed() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận dùng voucher'),
        content: const Text(
          'Voucher chỉ dùng được 1 lần. Sau khi xác nhận, voucher sẽ chuyển sang trạng thái đã dùng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _voucherQrCubit.markUsed();
    if (!mounted) return;
    AppFeedback.showSnackBar(context, 'Đã sử dụng voucher');
  }
}
