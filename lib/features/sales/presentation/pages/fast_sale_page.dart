import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pasal_pro/core/constants/app_icons.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/core/theme/mix_tokens.dart';
import 'package:pasal_pro/features/sales/constants/sales_spacing.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/sales_entry_form.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/daily_sales_log.dart';

/// Daily Sales Page - Fast entry & real-time log
///
/// Layout:
/// - 40/60 split (form/log) on desktop
/// - Stacked vertically on tablet/mobile
/// - Responsive breakpoints: 1366px, 1920px, 2560px
///
/// Features:
/// - SalesSpacing constants throughout
/// - Keyboard shortcuts (F1 help)
/// - Real-time profit calculation & tracking
class FastSalePage extends ConsumerStatefulWidget {
  const FastSalePage({super.key});

  @override
  ConsumerState<FastSalePage> createState() => _FastSalePageState();
}

class _FastSalePageState extends ConsumerState<FastSalePage> {
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyboardShortcut(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('💡 F1: Focus product search'),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyboardShortcut,
      child: Container(
        color: PasalColorToken.background.token.resolve(context),
        padding: AppResponsive.getPagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                // Icon container - using application primary color
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PasalColorToken.primary.token
                        .resolve(context)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    AppIcons.shoppingCart,
                    color: PasalColorToken.primary.token.resolve(context),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Sales',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: PasalColorToken.textPrimary.token.resolve(
                            context,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Record sales and track profit in real-time',
                        style: TextStyle(
                          fontSize: 13,
                          color: PasalColorToken.textSecondary.token.resolve(
                            context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.getSectionGap(context)),

            // Responsive 40/60 split (form/log) or stacked layout
            Expanded(
              child: ResponsiveRowColumn(
                layout: AppResponsive.shouldStack(context)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                children: [
                  // Entry form panel (40% on desktop)
                  ResponsiveRowColumnItem(
                    rowFlex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: PasalColorToken.surface.token.resolve(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: PasalColorToken.border.token.resolve(context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const SalesEntryForm(),
                    ),
                  ),

                  // Horizontal/vertical gap (responsive)
                  ResponsiveRowColumnItem(
                    child: SizedBox(
                      height: AppResponsive.shouldStack(context)
                          ? SalesSpacing.formSectionGap
                          : 0,
                      width: AppResponsive.shouldStack(context)
                          ? 0
                          : SalesSpacing.formSectionGap,
                    ),
                  ),

                  // Daily sales log panel (60% on desktop)
                  ResponsiveRowColumnItem(
                    rowFlex: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: PasalColorToken.surface.token.resolve(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: PasalColorToken.border.token.resolve(context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const DailySalesLog(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
