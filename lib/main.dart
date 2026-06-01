import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const VnMeatApp());
}

class VnMeatApp extends StatelessWidget {
  const VnMeatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VnGrocery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
