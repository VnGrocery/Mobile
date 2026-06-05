import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vngrocery/features/seller_products/seller_product_presenter.dart';
import 'package:vngrocery/theme/app_colors.dart';

void main() {
  group('SellerProductPresenter', () {
    test('stateLabel maps known statuses', () {
      expect(SellerProductPresenter.stateLabel('Published'), 'Đang bán');
      expect(SellerProductPresenter.stateLabel('Draft'), 'Bản nháp');
      expect(SellerProductPresenter.stateLabel('Archived'), 'Đã ẩn');
      expect(SellerProductPresenter.stateLabel('Paused'), 'Paused');
    });

    test('statusForeground maps statuses to expected colors', () {
      expect(
        SellerProductPresenter.statusForeground('Published'),
        AppColors.trustGreen,
      );
      expect(SellerProductPresenter.statusForeground('Draft'), Colors.grey);
      expect(
        SellerProductPresenter.statusForeground('Archived'),
        AppColors.warningOrange,
      );
    });

    test('parsePrice strips non-digits and falls back to zero', () {
      expect(SellerProductPresenter.parsePrice('120.000đ'), 120000);
      expect(SellerProductPresenter.parsePrice(' 85,500 VND '), 85500);
      expect(SellerProductPresenter.parsePrice('abc'), 0);
    });

    test('parseTags trims values and drops empty tags', () {
      expect(
        SellerProductPresenter.parseTags(' sạch, ngon ,, hữu cơ , '),
        ['sạch', 'ngon', 'hữu cơ'],
      );
    });

    test('freshnessNote reflects image presence', () {
      expect(
        SellerProductPresenter.freshnessNote(true),
        'Sản phẩm mới tạo, đã có ảnh demo.',
      );
      expect(
        SellerProductPresenter.freshnessNote(false),
        'Sản phẩm mới tạo.',
      );
    });
  });
}
