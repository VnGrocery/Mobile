import 'package:flutter/material.dart';

import 'package:vngrocery/data/models.dart';
import 'package:vngrocery/data/data_hooks.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class SellerProductPresenter {
  const SellerProductPresenter._();

  static final AppDataHooks _data = AppDataHooks.instance;

  static const states = ['Tất cả', 'Published', 'Draft', 'Archived'];
  static const categories = [
    'Thịt bò',
    'Thịt lợn',
    'Thịt gà',
    'Hải sản',
    'Gia cầm',
    'Khác',
  ];

  static String stateLabel(String status) {
    return switch (status) {
      'Published' => 'Đang bán',
      'Draft' => 'Bản nháp',
      'Archived' => 'Đã ẩn',
      _ => status,
    };
  }

  static Color statusBackground(BuildContext context, String status) {
    final palette = context.palette;
    return switch (status) {
      'Published' => palette.positiveBg,
      'Draft' => palette.mutedSurface,
      _ => palette.warningBg,
    };
  }

  static Color statusForeground(String status) {
    return switch (status) {
      'Published' => AppColors.trustGreen,
      'Draft' => Colors.grey,
      _ => AppColors.warningOrange,
    };
  }

  static int parsePrice(String value) {
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  static List<String> parseTags(String value) {
    return value
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  static String freshnessNote(bool hasImage) {
    return hasImage ? 'Sản phẩm mới tạo, đã có ảnh demo.' : 'Sản phẩm mới tạo.';
  }

  static List<Product> filteredProducts({
    required String shopId,
    required String state,
  }) {
    final all = _data.getProducts(shopId: shopId);
    if (state == states.first) return all;
    return all.where((product) => product.status == state).toList();
  }

  static Product addProduct({
    required String shopId,
    required String name,
    required String description,
    required String category,
    required bool hasImage,
    required String price,
    required String tags,
  }) {
    final product = Product(
      id: _data.nextId(),
      shopId: shopId,
      name: name.trim(),
      description: description.trim(),
      category: category,
      freshnessScore: 80,
      freshnessNote: freshnessNote(hasImage),
      price: parsePrice(price),
      tags: parseTags(tags),
      status: 'Draft',
    );
    _data.addProduct(product);
    return product;
  }
}
