import 'package:flutter/material.dart';

import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/theme/app_colors.dart';
import 'package:vngrocery/theme/app_palette.dart';

class ExploreSearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const ExploreSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context).exploreSearchHint,
        filled: true,
        fillColor: palette.field,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: const Icon(Icons.filter_list),
      ),
    );
  }
}

class ExploreFilterBar extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelect;

  const ExploreFilterBar({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = filters[i];
          final selected = filter == selectedFilter;
          return FilterChip(
            label: Text(filter),
            selected: selected,
            showCheckmark: false,
            selectedColor: AppColors.meatRed.withValues(alpha: 0.1),
            labelStyle: TextStyle(
              color: selected ? AppColors.meatRed : scheme.onSurface,
            ),
            onSelected: (_) => onSelect(filter),
          );
        },
      ),
    );
  }
}

class ExploreStoreListHeader extends StatelessWidget {
  final String title;
  final bool showDirections;
  final VoidCallback? onDirections;

  const ExploreStoreListHeader({
    super.key,
    required this.title,
    this.showDirections = false,
    this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (showDirections)
            TextButton.icon(
              onPressed: onDirections,
              icon: const Icon(Icons.directions, size: 18),
              label: Text(AppLocalizations.of(context).exploreDirections),
            ),
        ],
      ),
    );
  }
}
