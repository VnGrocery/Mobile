import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final String selectorKey;

  const NavigationItem(this.icon, this.label, {required this.selectorKey});
}
