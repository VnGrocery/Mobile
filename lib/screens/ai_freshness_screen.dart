import 'package:flutter/material.dart';

import 'package:vngrocery/core/services/app_delay_service.dart';
import 'package:vngrocery/l10n/app_localizations.dart';
import 'package:vngrocery/routes/app_routes.dart';
import 'package:vngrocery/theme/app_palette.dart';

class AiFreshnessScreen extends StatefulWidget {
  const AiFreshnessScreen({
    super.key,
    this.delayService = AppDelayService.instance,
  });

  final AppDelayService delayService;

  @override
  State<AiFreshnessScreen> createState() => _AiFreshnessScreenState();
}

class _AiFreshnessScreenState extends State<AiFreshnessScreen> {
  bool _analyzing = false;

  Future<void> _analyze() async {
    setState(() => _analyzing = true);
    await widget.delayService.wait(AppDelayKind.freshnessAnalysis);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.buyerCheckResult);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.palette.appBackground,
      appBar: AppBar(title: Text(l10n.aiFreshnessTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.aiFreshnessHeading,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.aiFreshnessBody,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Container(
              height: 350,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _analyzing
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(color: Colors.white),
                          const SizedBox(height: 16),
                          Text(
                            l10n.aiFreshnessAnalyzing,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.photo_camera,
                        size: 64,
                        color: Color(0xFF555555),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _analyzing ? null : _analyze,
                child: Text(
                  l10n.aiFreshnessAction,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
