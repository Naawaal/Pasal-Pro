import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';

/// Modern metric card with icon, value, and trend indicator using Mix
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final surfaceHover = PasalColorToken.surfaceHover.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);
    final profitColor = Color(0xFF4CAF50);
    final lossColor = Color(0xFFF44336);

    return PressableBox(
      onPress: () {},
      style: BoxStyler()
          .paddingAll(16.0)
          .borderRounded(12.0)
          .color(surfaceColor)
          .borderAll(color: borderColor)
          .onHovered(BoxStyler().color(surfaceHover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StyledText(
                  title,
                  style: TextStyler()
                      .fontSize(12)
                      .color(textSecondary)
                      .overflow(TextOverflow.ellipsis),
                ),
              ),
              const SizedBox(width: 8),
              Box(
                style: BoxStyler()
                    .paddingAll(6.0)
                    .borderRounded(6.0)
                    .color(primaryColor.withValues(alpha: 0.1)),
                child: StyledIcon(
                  icon: icon,
                  style: IconStyler().size(16).color(primaryColor),
                ),
              ),
            ],
          ),
          StyledText(
            value,
            style: TextStyler()
                .fontSize(20)
                .fontWeight(FontWeight.w700)
                .color(textPrimary)
                .overflow(TextOverflow.ellipsis),
          ),
          Row(
            children: [
              StyledIcon(
                icon: isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                style: IconStyler()
                    .size(12)
                    .color(isPositive ? profitColor : lossColor),
              ),
              const SizedBox(width: 4),
              StyledText(
                change,
                style: TextStyler()
                    .fontSize(11)
                    .fontWeight(FontWeight.w600)
                    .color(isPositive ? profitColor : lossColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
