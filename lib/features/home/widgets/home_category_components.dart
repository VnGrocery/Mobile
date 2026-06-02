import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_palette.dart';

class HomeCategory {
  final String label;
  final IconData icon;

  const HomeCategory(this.label, this.icon);
}

class HomeCategoryList extends StatelessWidget {
  final List<HomeCategory> categories;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          final selected = category.label == selectedCategory;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(category.label),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        selected ? AppColors.primaryGreen : palette.card,
                    child: Icon(
                      category.icon,
                      color: selected ? Colors.white : AppColors.primaryGreen,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color:
                          selected ? AppColors.primaryGreen : scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
