import 'package:flutter/material.dart';
import 'package:pasal_pro/core/constants/app_colors.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/dashboard/constants/dashboard_spacing.dart';

/// Modern metric card with icon, value, trend indicator, and timestamp
/// Follows modern design standards with 28px values, clean layout, and hover effects
class MetricCard extends StatefulWidget {
  final String title;
  final String value;
  final String trend; // e.g., "↑ 12% vs yesterday"
  final bool isPositive; // Trend direction: true = green, false = red
  final IconData icon;
  final String? timestamp; // e.g., "Last updated: 2m ago"

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.trend,
    required this.isPositive,
    required this.icon,
    this.timestamp,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Resolve color tokens from Mix theme
    final surfaceColor = PasalColorToken.surface.token.resolve(context);
    final borderColor = PasalColorToken.border.token.resolve(context);
    final textPrimary = PasalColorToken.textPrimary.token.resolve(context);
    final textSecondary = PasalColorToken.textSecondary.token.resolve(context);
    final textTertiary = PasalColorToken.textTertiary.token.resolve(context);
    final primaryColor = PasalColorToken.primary.token.resolve(context);

    // Semantic colors for metrics
    final trendColor = widget.isPositive
        ? AppColors.successGreen
        : AppColors.dangerRed;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: DashboardSpacing.hoverTransitionDuration,
        padding: DashboardSpacing.getCardPadding(),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: borderColor, width: 1.0),
          borderRadius: BorderRadius.circular(
            DashboardSpacing.cardBorderRadius,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: DashboardSpacing.hoverShadowOpacity,
                    ),
                    blurRadius: DashboardSpacing.hoverShadowBlur,
                    spreadRadius: DashboardSpacing.hoverShadowSpread,
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header: Icon + Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: DashboardSpacing.metricTitleFontSize,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(
                  width: DashboardSpacing.metricIconSize,
                  height: DashboardSpacing.metricIconSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Center(
                      child: Icon(widget.icon, size: 18.0, color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),

            // Vertical spacer
            SizedBox(height: 8.0),

            // Main value (28px, bold)
            Text(
              widget.value,
              style: TextStyle(
                fontSize: DashboardSpacing.metricValueFontSize,
                fontWeight: FontWeight.w700,
                color: textPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Trend indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isPositive
                      ? AppIcons.trendingUp
                      : AppIcons.trendingDown,
                  size: 12.0,
                  color: trendColor,
                ),
                SizedBox(width: 4.0),
                Flexible(
                  child: Text(
                    widget.trend,
                    style: TextStyle(
                      fontSize: DashboardSpacing.metricTrendFontSize,
                      fontWeight: FontWeight.w500,
                      color: textSecondary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),

            // Timestamp (if provided)
            if (widget.timestamp != null) ...[
              SizedBox(height: 4.0),
              Text(
                widget.timestamp!,
                style: TextStyle(
                  fontSize: DashboardSpacing.metricTimestampFontSize,
                  fontWeight: FontWeight.w400,
                  color: textTertiary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
