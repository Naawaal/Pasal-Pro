import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:pasal_pro/core/constants/app_responsive.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/sales_entry_form.dart';
import 'package:pasal_pro/features/sales/presentation/widgets/daily_sales_log.dart';

/// Modern Daily Sales Page
/// Clean flat design with smooth interactions
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
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        padding: AppResponsive.getPagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.point_of_sale,
                    color: Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Record sales and track profit',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppResponsive.getSectionGap(context)),

            // Responsive 2-Column/Stacked Layout
            Expanded(
              child: ResponsiveRowColumn(
                layout: AppResponsive.shouldStack(context)
                    ? ResponsiveRowColumnType.COLUMN
                    : ResponsiveRowColumnType.ROW,
                children: [
                  // Entry form panel
                  ResponsiveRowColumnItem(
                    rowFlex: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: const SalesEntryForm(),
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    child: SizedBox(
                      height: AppResponsive.shouldStack(context)
                          ? AppResponsive.getSectionGap(context)
                          : 0,
                      width: AppResponsive.shouldStack(context)
                          ? 0
                          : AppResponsive.getSectionGap(context),
                    ),
                  ),

                  // Daily sales log panel
                  ResponsiveRowColumnItem(
                    rowFlex: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
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
