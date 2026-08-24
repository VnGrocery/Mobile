import 'package:flutter/material.dart';

class AppPalette extends ThemeExtension<AppPalette> {
  final Color appBackground;
  final Color card;
  final Color elevatedCard;
  final Color mutedSurface;
  final Color field;
  final Color border;
  final Color textSecondary;
  final Color textTertiary;
  final Color iconMuted;
  final Color positiveBg;
  final Color warningBg;
  final Color glass;
  final Color glassBorder;

  /// Green that carries text, per theme. A deep ink reads on white and is
  /// unreadable on the dark canvas; a bright green is the other way round.
  final Color greenInk;

  /// Warning colour for text, per theme, on the same principle.
  final Color warnInk;

  const AppPalette({
    required this.appBackground,
    required this.card,
    required this.elevatedCard,
    required this.mutedSurface,
    required this.field,
    required this.border,
    required this.textSecondary,
    required this.textTertiary,
    required this.iconMuted,
    required this.positiveBg,
    required this.warningBg,
    required this.glass,
    required this.glassBorder,
    required this.greenInk,
    required this.warnInk,
  });

  static const light = AppPalette(
    appBackground: Colors.white,
    card: Color(0xFFF3F5F7),
    elevatedCard: Colors.white,
    mutedSurface: Color(0xFFF3F5F7),
    field: Color(0xFFF3F5F7),
    border: Color(0xFFF1F1F5),
    // Đủ 4.5:1 trên cả nền trắng lẫn nền thẻ xám; xem AppColors.textSecondary.
    textSecondary: Color(0xFF626864),
    // Siêu dữ liệu chạy ở 11px — cỡ nhỏ nhất trong app — nên nó cần đủ 4.5:1
    // chứ không phải 3:1. #7C837E chỉ đo được 3.56:1 trên thẻ xám.
    textTertiary: Color(0xFF696F6B),
    iconMuted: Color(0xFF8BA1B2),
    positiveBg: Color(0xFFE8F5E9),
    warningBg: Color(0xFFFFF3E0),
    glass: Color(0xC7FFFFFF),
    glassBorder: Color(0xB8FFFFFF),
    greenInk: Color(0xFF157A33),
    warnInk: Color(0xFFA65200),
  );

  static const dark = AppPalette(
    appBackground: Color(0xFF0B100D),
    card: Color(0xFF202620),
    elevatedCard: Color(0xFF151B17),
    mutedSurface: Color(0xFF252B26),
    field: Color(0xFF202620),
    border: Color(0xFF303830),
    textSecondary: Color(0xFFA6AEA8),
    // Cùng lý do như bản sáng: #7F8A83 đo được 4.04:1 trên mutedSurface.
    textTertiary: Color(0xFF8F9A93),
    iconMuted: Color(0xFF9CAEA0),
    positiveBg: Color(0xFF12351F),
    warningBg: Color(0xFF3A2A13),
    glass: Color(0xB8151B17),
    glassBorder: Color(0x1AFFFFFF),
    // On #0B100D the light-mode ink measures 2.8:1; these are the same two
    // meanings, lifted so they read on the dark canvas.
    greenInk: Color(0xFF4FC776),
    warnInk: Color(0xFFFFB74D),
  );

  @override
  AppPalette copyWith({
    Color? appBackground,
    Color? card,
    Color? elevatedCard,
    Color? mutedSurface,
    Color? field,
    Color? border,
    Color? textSecondary,
    Color? textTertiary,
    Color? iconMuted,
    Color? positiveBg,
    Color? warningBg,
    Color? glass,
    Color? glassBorder,
    Color? greenInk,
    Color? warnInk,
  }) {
    return AppPalette(
      appBackground: appBackground ?? this.appBackground,
      card: card ?? this.card,
      elevatedCard: elevatedCard ?? this.elevatedCard,
      mutedSurface: mutedSurface ?? this.mutedSurface,
      field: field ?? this.field,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      iconMuted: iconMuted ?? this.iconMuted,
      positiveBg: positiveBg ?? this.positiveBg,
      warningBg: warningBg ?? this.warningBg,
      glass: glass ?? this.glass,
      glassBorder: glassBorder ?? this.glassBorder,
      greenInk: greenInk ?? this.greenInk,
      warnInk: warnInk ?? this.warnInk,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      appBackground: Color.lerp(appBackground, other.appBackground, t)!,
      card: Color.lerp(card, other.card, t)!,
      elevatedCard: Color.lerp(elevatedCard, other.elevatedCard, t)!,
      mutedSurface: Color.lerp(mutedSurface, other.mutedSurface, t)!,
      field: Color.lerp(field, other.field, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      iconMuted: Color.lerp(iconMuted, other.iconMuted, t)!,
      positiveBg: Color.lerp(positiveBg, other.positiveBg, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      greenInk: Color.lerp(greenInk, other.greenInk, t)!,
      warnInk: Color.lerp(warnInk, other.warnInk, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.light;
}
