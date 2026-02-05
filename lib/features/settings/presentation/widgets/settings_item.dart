import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Individual settings item with icon, title, subtitle, and optional trailing widget using Mix
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);

    return PressableBox(
      onPress: onTap,
      style: BoxStyler()
          .paddingX(16.0)
          .paddingY(12.0)
          .onHovered(BoxStyler().color(surfaceHover)),
      child: Row(
        children: [
          StyledIcon(
            icon: icon,
            style: IconStyler().size(20).color(textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StyledText(
                  title,
                  style: TextStyler()
                      .fontSize(14)
                      .fontWeight(FontWeight.w500)
                      .color(textPrimary),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  StyledText(
                    subtitle!,
                    style: TextStyler().fontSize(12).color(textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            StyledIcon(
              icon: Icons.chevron_right,
              style: IconStyler().size(20).color(textSecondary),
            ),
        ],
      ),
    );
  }
}
