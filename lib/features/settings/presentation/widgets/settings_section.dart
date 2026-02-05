import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Settings section container with title and icon using Mix
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);

    return Box(
      style: BoxStyler()
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Box(
            style: BoxStyler().paddingAll(16.0),
            child: Row(
              children: [
                Box(
                  style: BoxStyler()
                      .paddingAll(8.0)
                      .borderRounded(8.0)
                      .color(primaryColor.withValues(alpha: 0.1)),
                  child: StyledIcon(
                    icon: icon,
                    style: IconStyler().size(18).color(primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                StyledText(
                  title,
                  style: TextStyler()
                      .fontSize(15)
                      .fontWeight(FontWeight.w600)
                      .color(textPrimary),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: borderColor),
          ...children,
        ],
      ),
    );
  }
}
