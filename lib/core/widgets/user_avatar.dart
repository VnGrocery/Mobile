import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_colors.dart';

/// Round avatar built from the account's own name.
///
/// Every account used to render the same bundled illustration, so a seller,
/// a buyer and a signed-out visitor all looked like the same person. There is
/// no avatar field on the server yet, so the honest stand-in is the user's own
/// initials.
class UserAvatar extends StatelessWidget {
  final String name;
  final double radius;

  const UserAvatar({super.key, required this.name, this.radius = 24});

  /// First letter of the first and last word: "Trần Minh Anh" -> "TA".
  /// Falls back to a person glyph when the name is empty or has no letters.
  static String? initialsOf(String name) {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return null;

    final first = words.first.characters.first;
    final letters = words.length == 1
        ? first
        : '$first${words.last.characters.first}';
    final initials = letters.toUpperCase();
    return initials.trim().isEmpty ? null : initials;
  }

  @override
  Widget build(BuildContext context) {
    final initials = initialsOf(name);

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      child: initials == null
          ? Icon(
              Icons.person,
              color: AppColors.primaryGreen,
              size: radius * 1.1,
            )
          : Text(
              initials,
              style: TextStyle(
                fontSize: radius * 0.72,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
    );
  }
}
