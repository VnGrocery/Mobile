import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:vngrocery/core/ui/app_feedback.dart';
import 'package:vngrocery/features/account/controllers/session_cubit.dart';
import 'package:vngrocery/features/account/controllers/session_state.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_cubit.dart';
import 'package:vngrocery/features/seller_shop/controllers/seller_shop_state.dart';
import 'package:vngrocery/features/seller_shop/widgets/seller_shop_components.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/screens/seller_comment_queue_screen.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerShopScreen extends StatefulWidget {
  final double bottomContentInset;

  const SellerShopScreen({super.key, this.bottomContentInset = 0});

  @override
  State<SellerShopScreen> createState() => _SellerShopScreenState();
}

class _SellerShopScreenState extends State<SellerShopScreen> {
  late final SellerShopCubit _shopCubit;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _address = TextEditingController();

  /// Why this edit is being made. Signed with the change, so the server
  /// refuses an update without it.
  final TextEditingController _changeReason = TextEditingController();

  /// The shop the fields were last filled from. The shop arrives after the
  /// first build, so the form has to be filled when it lands - but only once,
  /// or a background refresh would wipe out what the seller is typing.
  String? _filledFrom;

  /// Whether new product comments wait for this shop before buyers read them.
  bool _commentModeration = false;

  bool _canSave(SellerShopState state) {
    if (_name.text.trim().isEmpty || _address.text.trim().isEmpty) return false;
    // Creating a shop explains itself; changing one has to say why.
    if (state.isCreating) return true;
    return _changeReason.text.trim().length >= 5;
  }

  @override
  void initState() {
    super.initState();
    _shopCubit = SellerShopCubit(
      shopId: context.read<SessionCubit>().state.shopId,
    );
    // This used to read state.shop! straight after construction, which threw
    // for every account whose shop was not already cached - including any
    // account arriving here to create its first one.
    _fill(_shopCubit.state);
    _shopCubit.load();
  }

  void _fill(SellerShopState state) {
    final shop = state.shop;
    if (shop == null || shop.id == _filledFrom) return;
    _filledFrom = shop.id;
    _name.text = shop.name;
    _description.text = shop.description;
    _address.text = shop.address;
    _commentModeration = shop.commentModeration;
  }

  @override
  void dispose() {
    _shopCubit.close();
    _name.dispose();
    _description.dispose();
    _address.dispose();
    _changeReason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _shopCubit,
      // The tab is kept alive behind an IndexedStack, so it loaded once and
      // never again: a shop created elsewhere in the app left this screen
      // still offering to create one.
      child: BlocListener<SessionCubit, SessionState>(
        listenWhen: (previous, current) => previous.shopId != current.shopId,
        listener: (context, _) => _shopCubit.load(),
        child: BlocConsumer<SellerShopCubit, SellerShopState>(
          listener: (context, state) => setState(() => _fill(state)),
          builder: (context, state) {
            final l10n = AppLocalizations.of(context);
            final title = state.isCreating
                ? l10n.sellerDashboardNoShopAction
                : l10n.accountStoreInfo;

            if (state.isBusy) {
              return _shell(
                title: title,
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            if (state.status == SellerShopStatus.failed && state.shop == null) {
              return _shell(
                title: title,
                body: _LoadFailed(onRetry: _shopCubit.load),
              );
            }

            final dashboard = state.dashboard;
            return _shell(
              title: title,
              body: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  16 + widget.bottomContentInset,
                ),
                children: [
                  if (dashboard != null) ...[
                    SellerShopSummaryCard(dashboard: dashboard),
                    const SizedBox(height: 16),
                  ],
                  SellerShopFields(
                    name: _name,
                    description: _description,
                    address: _address,
                    changeReason: state.isCreating ? null : _changeReason,
                    commentModeration: state.isCreating
                        ? null
                        : _commentModeration,
                    onCommentModerationChanged: (value) =>
                        setState(() => _commentModeration = value),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 18),
                  SellerShopSaveButton(
                    saving: state.saving,
                    enabled: _canSave(state),
                    creating: state.isCreating,
                    onSave: _save,
                  ),
                  const SizedBox(height: 16),
                  const SellerShopFootnote(),
                  // Below the save button, not between the reason field and
                  // it: this leaves the screen, and a row that sits inside the
                  // form invites a tap that drops unsaved edits.
                  if (!state.isCreating && state.shop != null) ...[
                    const SizedBox(height: 8),
                    const Divider(height: 24),
                    SellerCommentQueueLink(shopId: state.shop!.id),
                    SellerShopLinkRow(
                      icon: Icons.local_activity_outlined,
                      label: l10n.sellerVouchersTitle,
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.sellerVouchers,
                        arguments: SellerShopArgs(state.shop!.id),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _shell({required String title, required Widget body}) {
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: body,
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    try {
      await _shopCubit.save(
        name: _name.text,
        description: _description.text,
        address: _address.text,
        changeReason: _changeReason.text,
        commentModeration: _commentModeration,
      );
    } catch (_) {
      // The save used to report success whatever happened, so a shop that
      // never reached the server looked saved.
      if (!mounted) return;
      AppFeedback.showSnackBar(
        context,
        l10n.sellerShopSaveFailed,
        icon: Icons.error_outline,
      );
      return;
    }
    final shop = _shopCubit.state.shop;
    if (!mounted || shop == null) return;
    // The next change needs its own reason. Leaving this one in the field lets
    // an unrelated edit be signed with a sentence written for the last one.
    _changeReason.clear();
    setState(() {});
    context.read<SessionCubit>().setShopId(shop.id);
    AppFeedback.showSnackBar(context, l10n.sellerShopSaved);
  }
}

class _LoadFailed extends StatelessWidget {
  final VoidCallback onRetry;

  const _LoadFailed({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off,
              size: 44,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              l10n.sellerShopLoadFailedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.sellerDashboardFailedBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onRetry, child: Text(l10n.homeRetryAction)),
          ],
        ),
      ),
    );
  }
}
