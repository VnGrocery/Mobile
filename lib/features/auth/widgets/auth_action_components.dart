import 'package:flutter/material.dart';

import 'package:vngrocery/theme/app_palette.dart';
import 'auth_segment_item.dart';

class AuthSegmentedControl extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const AuthSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: palette.mutedSurface,
        borderRadius: BorderRadius.circular(27),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment:
                value == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.elevatedCard,
                  borderRadius: BorderRadius.circular(23),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              AuthSegmentItem(
                label: 'Đăng nhập',
                index: 0,
                active: value == 0,
                onTap: onChanged,
              ),
              AuthSegmentItem(
                label: 'Đăng ký',
                index: 1,
                active: value == 1,
                onTap: onChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  final bool loading;
  final bool register;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    super.key,
    required this.loading,
    required this.register,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                register ? 'Tạo tài khoản' : 'Đăng nhập',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const GoogleSignInButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          side: BorderSide(color: context.palette.border),
        ),
        icon: const Icon(Icons.g_mobiledata, size: 26),
        label: const Text('Tiếp tục với Google'),
      ),
    );
  }
}
