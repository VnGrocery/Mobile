import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

import 'core/storage/hive_storage_service.dart';
import 'features/account/controllers/session_cubit.dart';
import 'features/account/controllers/session_state.dart';
import 'features/cart/controllers/cart_bloc.dart';
import 'features/cart/controllers/cart_event.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'theme/app_palette.dart';
import 'theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorageService.init();
  runApp(const VnGroceryApp());
}

class VnGroceryApp extends StatelessWidget {
  const VnGroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.mode,
      builder: (context, themeMode, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SessionCubit()),
            BlocProvider(create: (_) => CartBloc()..add(const CartStarted())),
          ],
          child: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, session) {
              return MaterialApp(
                onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                builder: (context, child) =>
                    _AppBackdrop(child: child ?? const SizedBox()),
                scrollBehavior: const _AppScrollBehavior(),
                initialRoute: Routes.splash,
                onGenerateRoute: Routes.routeFactory(session),
              );
            },
          ),
        );
      },
    );
  }
}

class _AppBackdrop extends StatefulWidget {
  final Widget child;

  const _AppBackdrop({required this.child});

  @override
  State<_AppBackdrop> createState() => _AppBackdropState();
}

class _AppBackdropState extends State<_AppBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drumSpin;

  @override
  void initState() {
    super.initState();
    _drumSpin = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 52),
    )..repeat();
  }

  @override
  void dispose() {
    _drumSpin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.instance.mode.value == ThemeMode.dark;
    final background = context.palette.appBackground;
    final barStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: background,
      systemNavigationBarDividerColor: background,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );

    SystemChrome.setSystemUIOverlayStyle(barStyle);

    return ColoredBox(
      color: background,
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final motifSize = width * 1.18;
                  return Stack(
                    children: [
                      Positioned(
                        top: -motifSize * 0.55,
                        right: -motifSize * 0.48,
                        child: Opacity(
                          opacity: 0.10,
                          child: RotationTransition(
                            turns: _drumSpin,
                            child: SizedBox(
                              width: motifSize,
                              height: motifSize,
                              child: const CustomPaint(
                                painter: _DongSonMotifPainter(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _DongSonMotifPainter extends CustomPainter {
  const _DongSonMotifPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 8;
    final gold = Paint()
      ..color = const Color(0xFFD9981F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.1
      ..strokeCap = StrokeCap.round;
    final fineGold = Paint()
      ..color = const Color(0xFFD9981F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final fillGold = Paint()
      ..color = const Color(0xFFD9981F)
      ..style = PaintingStyle.fill;

    for (final r in [
      radius,
      radius - 10,
      radius - 22,
      radius - 42,
      radius - 78,
      radius - 104,
    ]) {
      canvas.drawCircle(center, r, gold);
    }

    _drawTicks(canvas, center, radius - 32, 96, 4, fillGold);
    _drawTicks(canvas, center, radius - 68, 36, 8, fillGold);
    _drawBirdRing(canvas, center, radius - 60, fillGold);
    _drawStar(canvas, center, radius * 0.34, fillGold);

    canvas.drawCircle(center, radius * 0.42, fineGold);
    canvas.drawCircle(center, radius * 0.48, fineGold);
  }

  void _drawTicks(
    Canvas canvas,
    Offset center,
    double ringRadius,
    int count,
    double size,
    Paint paint,
  ) {
    for (var i = 0; i < count; i++) {
      final angle = i * math.pi * 2 / count;
      final outer = Offset(
        center.dx + ringRadius * math.cos(angle),
        center.dy + ringRadius * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (ringRadius - size) * math.cos(angle),
        center.dy + (ringRadius - size) * math.sin(angle),
      );
      final side = Offset(
        size * 0.55 * math.cos(angle + math.pi / 2),
        size * 0.55 * math.sin(angle + math.pi / 2),
      );
      final path = Path()
        ..moveTo(outer.dx, outer.dy)
        ..lineTo(inner.dx + side.dx, inner.dy + side.dy)
        ..lineTo(inner.dx - side.dx, inner.dy - side.dy)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  void _drawBirdRing(
    Canvas canvas,
    Offset center,
    double ringRadius,
    Paint paint,
  ) {
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi * 2 / 12;
      canvas.save();
      canvas.translate(
        center.dx + ringRadius * math.cos(angle),
        center.dy + ringRadius * math.sin(angle),
      );
      canvas.rotate(angle + math.pi / 2);
      final bird = Path()
        ..moveTo(-17, 0)
        ..quadraticBezierTo(-6, -10, 11, -2)
        ..lineTo(22, -9)
        ..lineTo(15, 1)
        ..quadraticBezierTo(4, 8, -10, 5)
        ..lineTo(-17, 0)
        ..moveTo(-2, 4)
        ..lineTo(-8, 14)
        ..moveTo(5, 4)
        ..lineTo(1, 15);
      canvas.drawPath(bird, paint);
      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 32; i++) {
      final r = i.isEven ? radius : radius * 0.42;
      final angle = -math.pi / 2 + i * math.pi / 16;
      final point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DongSonMotifPainter oldDelegate) => false;
}

class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
