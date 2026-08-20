import 'package:flutter/material.dart';

import 'package:vngrocery/features/home/category_presenter.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class HomeCategoryList extends StatelessWidget {
  /// Raw category values taken from the products on screen.
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelect;

  const HomeCategoryList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == selectedCategory;
          // A scrolling row rather than equal-width columns: the categories come
          // from the data, so there may be one or a dozen, and stretching a
          // single chip across the screen looked broken.
          return SizedBox(
            width: 76,
            child: GestureDetector(
              onTap: () => onSelect(category),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: selected
                        ? AppColors.primaryGreen
                        : palette.card,
                    child: Icon(
                      CategoryPresenter.icon(category),
                      color: selected ? Colors.white : AppColors.primaryGreen,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CategoryPresenter.label(l10n, category),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.1,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? AppColors.primaryGreen
                          : scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
